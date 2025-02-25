import 'package:agattp/agattp.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:url_launcher/url_launcher.dart';

/// An abstract class intended for a singleton class that handles the process
/// of checking for updates - it is abstract purely so URL can be supplied
///
/// The URL must be for Github's Releases API:
///
/// https://api.github.com/repos/owner/repo/releases/latest
abstract class UpdateCheck with Loggable {
  /// The Agattp client
  static final Agattp agattp = Agattp.authBasic(username: '', password: '');

  /// The Github API endpoint used to check for updates
  String get githubEndpoint;

  /// The URL to link to that contains the latest version
  String latestVersionUrl = '';

  /// Whether updates have been checked for
  bool hasCheckedForUpdates = false;

  /// Whether update checking has succeeded
  bool updateCheckSucceeded = false;

  /// Whether an update is available to download
  bool hasUpdate = false;

  /// The latest version detected
  String latestVersion = '';

  /// Make an HTTP request to Github and check for software updates. The request
  /// fetches the latest version, which is then compared to the current one
  /// residing in the code somewhere
  Future<void> checkForUpdates(
    String currentVersion,
    Function() callback,
  ) async {
    // Never check multiple times
    if (hasCheckedForUpdates) {
      return;
    }
    try {
      latestVersion = currentVersion;
      AgattpJsonResponse<Map<String, dynamic>> response = await agattp.getJson(
        Uri.parse(githubEndpoint),
      );
      Map<String, dynamic> body = response.json;
      if (!body.containsKey('tag_name') || !body.containsKey('html_url')) {
        await log(LogLevel.warning, 'Invalid body when checking for updates');
        updateCheckSucceeded = false;
      } else {
        latestVersionUrl = body['html_url'];
        latestVersion = body['tag_name'];
        // Yes I know it should have a proper compare, but are you REALLY that
        // concerned about a rollback?
        hasUpdate = latestVersion != currentVersion;
        updateCheckSucceeded = true;
      }
    } catch (e) {
      // If any exception happens with the request or json parse, set error flag
      await log(LogLevel.warning, 'Exception when checking for updates: $e');
      updateCheckSucceeded = false;
    }
    hasCheckedForUpdates = true;
    callback();
  }

  /// Open the latest version URL so the user can download it
  Future<void> openLatestVersion() async {
    if (latestVersionUrl == '') {
      return;
    }
    if (!await launchUrl(Uri.parse(latestVersionUrl))) {}
  }
}
