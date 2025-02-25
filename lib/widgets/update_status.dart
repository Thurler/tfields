import 'package:flutter/material.dart';
import 'package:tfields/widgets/clickable.dart';
import 'package:tfields/widgets/spaced_row.dart';

/// The widget that displays the automatic update check status
class UpdateStatus extends StatelessWidget {
  /// Whether updates have been checked for or not
  final bool hasCheckedForUpdates;

  /// Whether the update check succeeded or not
  final bool updateCheckSucceeded;

  /// Whether an update is available or not
  final bool hasUpdate;

  /// The latest version to display when there is an update available
  final String latestVersion;

  /// Callback to call when the update link is clicked on
  final void Function() onUpdateTap;

  const UpdateStatus({
    required this.hasCheckedForUpdates,
    required this.updateCheckSucceeded,
    required this.hasUpdate,
    required this.latestVersion,
    required this.onUpdateTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool clickable = false;
    Widget icon = const SizedBox(height: 1);
    String text;

    if (!hasCheckedForUpdates) {
      icon = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      );
      text = 'Looking for updates...';
    } else if (!updateCheckSucceeded) {
      icon = const Icon(Icons.cancel_outlined, color: Colors.red);
      text = 'Error when searching for updates';
    } else if (hasUpdate) {
      icon = const Icon(Icons.warning, color: Colors.red);
      text = 'New version $latestVersion available, click here to download it';
      clickable = true;
    } else {
      icon = const Icon(Icons.check_circle_outlined, color: Colors.green);
      text = 'You are using the latest version!';
    }

    Widget row = TSpacedRow(
      mainAxisAlignment: MainAxisAlignment.center,
      spacer: const SizedBox(width: 5),
      children: <Widget>[
        icon,
        Text(text),
      ],
    );

    if (!clickable) {
      return row;
    }
    return TClickable(onTap: onUpdateTap, child: row);
  }
}
