import 'dart:async';
import 'dart:math';

/// Defines whether work should be processed sequentially or in parallel
enum TProcessMethod {
  sequential,
  parallel;
}

/// A mixin that adds the `divideWork` function to a class. That class can now
/// call this method to asynchronously execute tasks on a list of data elements,
/// without blocking the rendering thread
mixin TTaskDivider {
  /// Iterates over the work list, waiting for one execution before moving on to
  /// the next one. If any work returns FALSE, execution is aborted immediately.
  Future<bool> _doSequentialWork(List<Future<bool> Function()> workList) async {
    for (Future<bool> Function() work in workList) {
      bool keepGoing = await work();
      if (!keepGoing) {
        return false;
      }
    }
    return true;
  }

  /// Calls Future.wait on the work list that is passed in, returning whether
  /// ALL work calls returned TRUE
  Future<bool> _doParallelWork(List<Future<bool> Function()> workList) async {
    List<bool> results = await Future.wait(
      workList.map((Future<bool> Function() work) => work()),
    );
    return results.every((bool result) => result);
  }

  /// Receives a list of type `Data` to iterate through and a `SharedState`
  /// object to keep track of work done on the data list. The work is applied to
  /// each `Data` element through a `processFunction`, that takes in a `Data`
  /// point and the `SharedState` object.
  ///
  /// The data is divided into chunks of size `chunkSize`, that will be
  /// processed either sequentially or in parallel, depending on the
  /// `TprocessMethod` that is passed in.
  ///
  /// The caller is responsible for ensuring the `SharedState` object can keep
  /// track of the processing result, as well as handle concurrent access to it
  /// in case of parallel work divisions.
  ///
  /// The `processFunction` is responsible for returning whether iteration
  /// should keep going to the next data element / chunk of data elements, or
  /// whether execution should be aborted and the Future should be completed
  /// with the `SharedState` object as is.
  ///
  /// In case the work is set up to be divided in parallel, execution will still
  /// be done in chunks, even if the very first data point returns FALSE on its
  /// `processFunction` call. Execution will only move on to the next chunk if
  /// EVERY data process for a chunk returned TRUE.
  Future<SharedState> divideWork<Data, SharedState>({
    required List<Data> dataList,
    required SharedState sharedState,
    required Future<bool> Function(Data, SharedState) processFunction,
    required TProcessMethod processMethod,
    required int chunkSize,
  }) async {
    // Think of this as a Promise, we call completer.complete() like we would
    // call resolve()
    Completer<SharedState> completer = Completer<SharedState>();
    // If there's no data to iterate through, return an empty list
    if (dataList.isEmpty) {
      return sharedState;
    }
    int length = dataList.length;
    // This is just a fancy way to isolate a part of our function as a separate
    // function, so we can call that separate part recursively, keeping the
    // outside variables as context for the inner computation.
    // The only argument is the progress, so we can keep track of what each exec
    // loop needs to accomplish
    Function(int progress)? exec;
    exec = (int progress) async {
      // If our progress exceeds the length of data to check, resolve the value
      if (progress >= length) {
        return completer.complete(sharedState);
      }
      // Iterate on the next [chunk] elements of our given data. In order to
      // avoid going over the prefetched data length, we compute the minimum
      // between the length and our progress + chunk size
      List<Future<bool> Function()> workList = <Future<bool> Function()>[];
      for (int i = progress; i < min(length, progress + chunkSize); i++) {
        workList.add(() => processFunction(dataList[i], sharedState));
      }
      // Call the appropriate function to divide the work either sequentially or
      // in parallel. If the processing returns to not keep going, we resolve
      // the value and exit the processing
      bool keepGoing = await switch (processMethod) {
        TProcessMethod.sequential => _doSequentialWork(workList),
        TProcessMethod.parallel => _doParallelWork(workList),
      };
      if (!keepGoing) {
        return completer.complete(sharedState);
      }
      // After we're done processing a chunk, we add a recursive call to exec
      // to the event queue in Dart, so that the other events (like rendering
      // logic) can be processed before we continue our work.
      // This is achieved by creating a delayed Future with duration zero, so
      // that we can go right back to processing our data if there are no other
      // events in the queue
      Future<void>.delayed(
        Duration.zero,
        () => exec?.call(progress + chunkSize),
      );
    };
    // Start the processing and then return the future for the completer - that
    // future will complete when we call completer.complete() above
    exec(0);
    return completer.future;
  }
}
