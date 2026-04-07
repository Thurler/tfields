import 'package:flutter/material.dart';
import 'package:tfields/src/extensions/iterable.dart';
import 'package:tfields/src/mixins/standard_colorer.dart';
import 'package:tfields/src/widgets/clickable.dart';

/// The widget that displays the automatic update check status
class TUpdateStatus extends StatelessWidget with TStandardColorer {
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

  const TUpdateStatus({
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
      icon = Icon(Icons.cancel_outlined, color: errorColor(context));
      text = 'Error when searching for updates';
    } else if (hasUpdate) {
      icon = Icon(Icons.warning, color: errorColor(context));
      text = 'New version $latestVersion available, click here to download it';
      clickable = true;
    } else {
      icon = Icon(Icons.check_circle_outlined, color: successColor(context));
      text = 'You are using the latest version!';
    }

    return TClickable(
      onTap: clickable ? onUpdateTap : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Flexible(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ].separateWith(const SizedBox(width: 5)),
      ),
    );
  }
}
