import 'package:tfields/update_checker.dart';

/// Mixing this into any class will allow that class to standardize its
/// interactions with the application's automatic update process. It provides
/// a function to query for updates, and forces the mixed class to implement a
/// callback to receive the update check complete event
mixin UpdateChecker<U extends UpdateCheck> {
  /// The singleton instance of the the update checker class
  U get updateChecker;

  /// The callback that's called when the update checking has finished
  void updateCheckCallback();

  /// The function to call whenever an update check needs to be started
  Future<void> checkForUpdates(String currentVersion) =>
      updateChecker.checkForUpdates(currentVersion, updateCheckCallback);
}
