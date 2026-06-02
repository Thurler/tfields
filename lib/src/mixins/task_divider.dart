import 'dart:async';

/// Defines whether work should be processed sequentially or in parallel
enum ProcessMethod {
  sequential,
  parallel;
}

/// A mixin that adds the `divideWork` function to a class. That class can now
/// call this method to asynchronously execute tasks on a list of data elements,
/// without blocking the rendering thread
mixin TaskDivider {
  /// Iterates over the work list, waiting for one execution before moving on to
  /// the next one. If any work returns FALSE, execution is aborted immediately.
  Future<bool> _doSequentialWork(
    Iterable<Future<bool> Function()> workList,
  ) async {
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
  Future<bool> _doParallelWork(
    Iterable<Future<bool> Function()> workList,
  ) async {
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
  /// `processMethod` that is passed in.
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
    required Iterable<Data> dataList,
    required SharedState sharedState,
    required Future<bool> Function(Data, SharedState) processFunction,
    required ProcessMethod processMethod,
    required int chunkSize,
  }) async {
    // Think of this as a Promise, we call completer.complete() like we would
    // call resolve()
    Completer<SharedState> completer = Completer<SharedState>();
    // If there's no data to iterate through, return an empty list
    if (dataList.isEmpty) {
      return sharedState;
    }
    // We keep this as a "global" variable for the async chunks
    bool isFinished = false;
    // Generates an iterable of at most [chunkSize] elements from the given
    // [iterator], effectively advancing the [iterator] by [chunkSize] positions
    // or until it is finished with no more data to be read
    //
    // The reason we declare it inline is because we need to update the state of
    // [isFinished] when we run out of elements
    Iterable<Data> generateChunk(int chunkSize, Iterator<Data> iterator) sync* {
      for (int i = 0; i < chunkSize; i++) {
        if (iterator.moveNext()) {
          yield iterator.current;
        } else {
          isFinished = true;
          break;
        }
      }
    }

    // This is just a fancy way to isolate a part of our function as a separate
    // function, so we can call that separate part recursively, keeping the
    // outside variables as context for the inner computation.
    // The only argument is the progress, so we can keep track of what each exec
    // loop needs to accomplish
    Function(Iterator<Data> iterator)? exec;
    exec = (Iterator<Data> iterator) async {
      // Iterate on the iterator [chunkSize] times, populating a data chunk to
      // work on and always updating whether more data is available or not
      Iterable<Data> dataChunk = generateChunk(chunkSize, iterator);
      Iterable<Future<bool> Function()> workList = dataChunk.map(
        (Data data) => () => processFunction(data, sharedState),
      );
      // Call the appropriate function to divide the work either sequentially or
      // in parallel. If the processing returns to not keep going, we resolve
      // the value and exit the processing
      // We also stop if we have run out of elements in our iterator
      bool keepGoing = await switch (processMethod) {
        ProcessMethod.sequential => _doSequentialWork(workList),
        ProcessMethod.parallel => _doParallelWork(workList),
      };
      if (!keepGoing || isFinished) {
        return completer.complete(sharedState);
      }
      // After we're done processing a chunk, we add a recursive call to exec
      // to the event queue in Dart, so that the other events (like rendering
      // logic) can be processed before we continue our work.
      // This is achieved by creating a delayed Future with duration zero, so
      // that we can go right back to processing our data if there are no other
      // events in the queue
      Future<void>.delayed(Duration.zero, () => exec?.call(iterator));
    };
    // Start the processing and then return the future for the completer - that
    // future will complete when we call completer.complete() above
    exec(dataList.iterator);
    return completer.future;
  }
}
