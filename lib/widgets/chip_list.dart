import 'package:flutter/material.dart';
import 'package:tfields/widgets/button.dart';

/// A typedef to simplify keeping track of the TChipList state
typedef TChipListKey<T> = GlobalKey<StatefulChipListState<T>>;

/// How the chip sort logic should be implemented
enum TChipSortLogic {
  /// No sorting is performed
  none,

  /// Sorting is done based on the chip type (the type must implement the
  /// `Comparable` interface with itself)
  object,

  /// Sorting is based on the chip text that is displayed for the object
  text;
}

/// A stateless version of a Chip list, displayed on a Wrap together with a
/// text and, optionally, an icon
class TChipList<T> extends StatelessWidget {
  /// The title that will be displayed before the chips
  final String title;

  /// The text to be displayed when there are no chips to display
  final String noChipsText;

  /// The text to be displayed when hovering over the chip delete button
  final String removeText;

  /// The icon to be displayed before the title
  final IconData? icon;

  /// The callback to call when the user clicks on the chip delete button
  final void Function(T)? deleteCallback;

  /// The content that will be displayed as Chips
  final List<T> content;

  /// The function to convert the displayed data into a String
  final String Function(T) dataToString;

  /// Defines how sorting should be performed in the chip elements. Defaults
  /// to ordering by the text value provided by the `dataToString` function
  final TChipSortLogic sortLogic;

  const TChipList({
    required this.title,
    required this.noChipsText,
    required this.removeText,
    required this.content,
    required this.dataToString,
    this.sortLogic = TChipSortLogic.text,
    this.deleteCallback,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<T> items = content.toList();
    // Convert the items to their respective texts
    Map<T, String> itemTexts = <T, String>{
      for (T option in items) option: dataToString(option),
    };
    // Make sure we sort the options
    switch (sortLogic) {
      // Sort by the object's own comparison function
      case TChipSortLogic.object: {
        if (items.isNotEmpty && items.first is Comparable<T>) {
          items.sort();
        }
      }
      // Sort by text that will be displayed
      case TChipSortLogic.text: {
        items.sort(
          (T one, T other) => itemTexts[one]!.compareTo(itemTexts[other]!),
        );
      }
      // Do nothing if no logic is set
      case TChipSortLogic.none: {}
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        if (icon != null) Icon(icon),
        SelectableText(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (content.isEmpty)
          SelectableText(noChipsText)
        else
          ...items.map(
            (T data) => Chip(
              label: SelectableText(itemTexts[data]!),
              // If we set the callback on the "onDeleted" instead of the
              // button's "onPressed", there will be no cursor change
              onDeleted: deleteCallback != null ? () {} : null,
              deleteIcon: deleteCallback != null
                ? TButton.iconOnly.close(
                    onPressed: () => deleteCallback!(data),
                    textOverride: removeText,
                  )
                : null,
            ),
          ),
      ],
    );
  }
}

/// A stateful version of a Chip list, displayed on a Wrap together with a text
/// and, optionally, an icon. Will keep track of the items being displayed in
/// its state.
class StatefulChipList<T> extends StatefulWidget {
  /// The title that will be displayed before the chips
  final String title;

  /// The text to be displayed when there are no chips to display
  final String noChipsText;

  /// The text to be displayed when hovering over the chip delete button
  final String removeText;

  /// The icon to be displayed before the title
  final IconData? icon;

  /// The callback to call when the user clicks on the chip delete button
  final void Function(T)? deleteCallback;

  /// The function to convert the displayed data into a String
  final String Function(T) dataToString;

  const StatefulChipList({
    required this.title,
    required this.noChipsText,
    required this.removeText,
    required this.dataToString,
    this.icon,
    this.deleteCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => StatefulChipListState<T>();
}

/// The actual state for the stateful version of the ChipList
class StatefulChipListState<T> extends State<StatefulChipList<T>> {
  /// The internal Set that tracks which data is being displayed
  final Set<T> _data = <T>{};

  /// This is done so that the Set itself is not shown publicly through the
  /// class - only a copy of it is returned as a List
  List<T> get data => _data.toList();

  /// Clears all data in the Set
  void clearData() => setState(_data.clear);

  /// Adds new data to the Set
  void addData(T newData) => setState(() {
    _data.add(newData);
  });

  /// Deletes a data entry from the Set and calls the delete callback
  void _deleteData(T target) => setState(() {
    _data.remove(target);
    widget.deleteCallback?.call(target);
  });

  @override
  Widget build(BuildContext context) {
    // We can just use the stateless version!
    return TChipList<T>(
      title: widget.title,
      noChipsText: widget.noChipsText,
      removeText: widget.removeText,
      dataToString: widget.dataToString,
      icon: widget.icon,
      deleteCallback: _deleteData,
      content: _data.toList(),
    );
  }
}
