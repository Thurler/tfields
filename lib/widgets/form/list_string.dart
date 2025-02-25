import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/clickable.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/string.dart';

/// A shorthand for a List String Form's state
typedef ListStringFormKey = GlobalKey<TFormListStringState<TFormListString>>;

/// The String Form's field widget, composed of a list of TextFormFields,
/// each decorated with a hint and suffix icons (one of them a remove button),
/// as well as a button to add a new value to the list
class TFormListStringField extends TFormField {
  final bool enabled;
  final String hintText;
  final String newEntryText;
  final List<TextEditingController> controllers;
  final List<TextInputFormatter> formatters;
  final List<Widget> rowIcons;
  final List<Key?>? rowKeys;
  final void Function() onRowAdd;
  final void Function(int) onRowRemove;

  const TFormListStringField({
    required this.enabled,
    required this.hintText,
    required this.newEntryText,
    required this.controllers,
    required this.formatters,
    required this.onRowAdd,
    required this.onRowRemove,
    this.rowIcons = const <Widget>[],
    this.rowKeys,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Each value's individual form
        ...List<Widget>.generate(
          controllers.length,
          (int i) => Row(
            children: <Widget>[
              Expanded(
                child: TFormStringField(
                  enabled: enabled,
                  hintText: hintText,
                  controller: controllers[i],
                  formatters: formatters,
                  icons: rowIcons,
                  key: rowKeys?[i],
                ),
              ),
              // The delete icon is always present and separate from the
              // value's individual icons
              Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TClickable(
                    onTap: () => onRowRemove(i),
                    child: Icon(Icons.delete, color: Colors.red[500]),
                  ),
                ),
              ),
            ],
          ),
        ),
        // The button to add new values
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TButton(
            text: newEntryText,
            onPressed: onRowAdd,
            icon: Icons.add,
          ),
        ),
      ].separateWith(const SizedBox(height: 10), separatorOnEnds: true),
    );
  }
}

/// The List String Form's stateful widget, which expands a regular List Form by
/// adding a list of formatters to mask the inputs, and a hint text used when
/// each of the values is empty, exactly like a String Form would. It also adds
/// a string to be used as the "add new value" button's string
class TFormListString extends TFormList<String> {
  final List<TextInputFormatter> formatters;
  final String hintText;
  final String newEntryText;

  const TFormListString({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    required this.newEntryText,
    this.hintText = '',
    this.formatters = const <TextInputFormatter>[],
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.key,
  });

  @override
  State<TFormListString> createState() =>
      TFormListStringState<TFormListString>();
}

/// The String Form's state, which is responsible for handling every text
/// controller's events properly, assigning them to the correct indexes. It must
/// also spawn new controllers when a new value is added, and reassign listen
/// callbacks when a new value is added or removed
class TFormListStringState<T extends TFormListString>
    extends TFormListState<String, T> {
  /// The list of text controllers that hold the values
  final List<TextEditingController> controllers = <TextEditingController>[];

  /// The list of text controllers callbacks that report on value changes
  final List<void Function()> listeners = <void Function()>[];

  late List<TextInputFormatter> formatters;

  /// Make a new callback function to be bound to a controller - the function
  /// will call `update` on the provided index
  void Function() makeListener(int index) =>
      () => update(index, controllers[index].text);

  /// Make a new text controller with the provided initial text, and bind it to
  /// the proper listener, updating the value as appropriate
  void makeController([String? initialText]) {
    int newIndex = value.length;
    void Function() listener = makeListener(newIndex);
    listeners.add(listener);
    TextEditingController newController = TextEditingController();
    newController.text = initialText ?? '';
    newController.addListener(listener);
    controllers.add(newController);
    value.add(initialText ?? '');
  }

  @override
  void addRow() {
    // We must first make the new controller and update all variables before
    // calling super's addRow, which will propagate the new value to the
    // callbacks
    makeController();
    super.addRow();
  }

  @override
  void deleteRow(int index) {
    // Removing the controller is the obvious step
    controllers.removeAt(index);
    // Reassigning the listeners, however... Is made simple since we store an
    // ordered list of listeners, created alongside the controllers. Therefore,
    // all we have to do is shift the list of listeners in the controllers, by
    // removing them from the current controller and adding them to the previous
    // one. This works since each listener is bound only to an index, it doesn't
    // care which controller holds it
    //
    // For example, if we have 4 values and delete the 2nd one:
    // Old state: 1st controller holds listener on index 0, 2nd on 1, etc
    // By removing the 2nd controller, we reduce the length from 4 to 3
    // Therefore we still need listeners bound to indexes 0 through 2
    // 1st controller was bound to index 0, keeps the same listener
    // 2nd controller was bound to index 1, but was removed so who cares
    // 3rd controller was bound to index 2, now needs to be bound to 1
    // 4th controller was bound to index 3, now needs to be bound to 2
    //
    // After removing a controller, the first index that needs changes is the
    // one that sits at the index we just deleted from, and we must iterate
    // every controller after that one
    //
    // The update simply removes the old listener (bound to current index + 1)
    // and adds the new listener (bound to current index). Because the listener
    // list is ordered, this is all a very simple for loop:
    for (int i = index; i < controllers.length; i++) {
      controllers[i].removeListener(listeners[i + 1]);
      controllers[i].addListener(listeners[i]);
    }
    // After reassigning everything, we can now delete the stale listener that
    // is no longer used, bound to the now unreachable index after reducing the
    // length
    listeners.removeLast();
    super.deleteRow(index);
  }

  @override
  void initState() {
    super.initState();
    // Gotta reset this so we can repopulate with proper controllers
    value = <String>[];
    formatters = widget.formatters;
    for (String rowValue in widget.initialValue) {
      makeController(rowValue);
    }
    validate();
  }

  @override
  TFormField get field => TFormListStringField(
    enabled: enabled,
    newEntryText: widget.newEntryText,
    hintText: widget.hintText,
    controllers: controllers,
    formatters: formatters,
    onRowAdd: addRow,
    onRowRemove: deleteRow,
  );
}
