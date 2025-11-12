import 'package:meta/meta.dart';
import 'package:tfields/src/widgets/form/base.dart';

/// A specialization of TForm that handles a List of a given type. This will
/// prompt the user for a group of values of the same type, such as a list of
/// strings or a group of checkboxes
abstract class TFormList<Value> extends TForm<List<Value>> {
  /// Callback for when a value is added to the list of values
  final void Function(Value)? onValueAdded;

  /// Callback for when a value is removed from the list of values
  final void Function(Value)? onValueDeleted;

  const TFormList({
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.onValueAdded,
    this.onValueDeleted,
    super.readonly,
    super.validationCallback,
    super.subtitle,
    super.errorMessage,
    super.prefixIcon,
    super.suffixIcon,
    super.decoratorIcon,
    super.onValueChanged,
    super.key,
  });
}

/// The internal state gets some new overrides to handle List values
abstract class TFormListState<Value, AForm extends TFormList<Value>>
    extends TFormState<List<Value>, AForm> {
  @override
  bool get hasChanges {
    // Because the value is now a list, we need to provide deep equality!
    // Make sure the length matches, and then if the order of the items is
    // preserved
    int initialLength = initialValue?.length ?? 0;
    int valueLength = value?.length ?? 0;
    if (initialLength != valueLength) {
      return true;
    }
    for (int i = 0; i < valueLength; i++) {
      // This is safe since only non-null values will have lengths!
      if (initialValue![i] != value![i]) {
        return true;
      }
    }
    return false;
  }

  @override
  set value(List<Value>? newValue) {
    // Make a shallow copy - do we ever need a deep one? If yes, should caller
    // be responsible for it?
    super.value = newValue?.toList();
    validate();
  }

  @override
  void resetInitialValue() {
    initialValue = value?.toList(); // Shallow copy again - need a deep one?
  }

  /// This is used to update an item directly, as opposed to the entire list
  ///
  /// Will have no effect if the provided index is invalid or negative
  @mustCallSuper
  void updateAt(int index, Value newValue) {
    if (index < 0 || index >= (value?.length ?? 0)) {
      return;
    }
    // This is safe since only non-null values have length!
    value![index] = newValue;
    validate();
  }

  /// This should be called when adding a new item to the list of values
  @mustCallSuper
  void addElement(Value newValue) {
    // Make sure we have a non-null value before adding anything
    if (value == null) {
      super.value = <Value>[];
    }
    value?.add(newValue);
    validate();
    widget.onValueAdded?.call(newValue);
    widget.onValueChanged?.call(value);
  }

  /// This should be called to remove an item at a specific index
  @mustCallSuper
  void deleteElement(int index) {
    Value? deleted = value?.removeAt(index);
    validate();
    if (deleted != null) {
      widget.onValueDeleted?.call(deleted);
    }
    widget.onValueChanged?.call(value);
  }

  /// This should be called to remove an item by its reference - the raw pointer
  /// is checked instead of equality
  @mustCallSuper
  void deleteElementByReference(Value data) {
    value?.removeWhere((Value v) => identical(v, data));
    validate();
    widget.onValueDeleted?.call(data);
    widget.onValueChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    value = widget.initialValue?.toList(); // Another shallow copy - you get it
  }
}
