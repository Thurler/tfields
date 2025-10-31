import 'package:flutter/material.dart';
import 'package:tfields/mixins/standard_colorer.dart';
import 'package:tfields/widgets/circular_progress_icon.dart';

/// Whether an item from a ProgressChecklist is:
///
/// - none (the step has not been processed)
/// - ongoing (the step is being processed)
/// - done (the step is complete)
/// - error (the step has errored)
enum TProgressStatus {
  none,
  ongoing,
  done,
  error;
}

/// An item from a ProgressChecklist
class TProgressChecklistItem {
  TProgressStatus status;
  String text;

  TProgressChecklistItem({required this.status, required this.text});
}

/// A list of items that have a progress associated with them, displayed in a
/// column with aligned icons
class ProgressChecklist extends StatelessWidget with TStandardColorer {
  final List<TProgressChecklistItem> items;

  const ProgressChecklist({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map(
        (TProgressChecklistItem item) => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: switch (item.status) {
                TProgressStatus.ongoing => const TCircularProgressIcon(),
                TProgressStatus.none =>
                  const Icon(Icons.check_box_outline_blank),
                TProgressStatus.done =>
                  Icon(Icons.check_box, color: successColor(context)),
                TProgressStatus.error =>
                  Icon(Icons.cancel, color: errorColor(context)),
              },
            ),
            const SizedBox(width: 10),
            Flexible(child: SelectableText(item.text)),
          ],
        ),
      ).toList(),
    );
  }
}
