import 'package:flutter/material.dart';
import 'package:tfields/src/extensions/iterable.dart';
import 'package:tfields/src/mixins/icon_updateable_form.dart';
import 'package:tfields/src/widgets/chip_list.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/form/dropdown.dart';
import 'package:tfields/src/widgets/form/list/list.dart';

typedef TDropdownListChipFormKey<T> = GlobalKey<TFormDropdownListChipState<T>>;

/// A specialization of the generic List Form that allows the user to input a
/// series of Dropdown choices, and displays them as chips under the input
class TFormDropdownListChip<T> extends TFormList<T> {
  /// The text to be displayed next to the selected values
  final String selectedValuesText;

  /// The text to be displayed when no element has been selected
  final String noElementText;

  /// The hint text for the dropdown
  final String hintText;

  /// The options displayed in the dropdown
  final List<T> options;

  /// The function that will be used to convert T into a String for the user
  final String Function(T) toDropdownText;

  /// The function that will be used to determine if the option is enabled or
  /// not in the dropdown. If unspecified, all options are enabled by default
  final bool Function(T) isOptionEnabledCallback;

  /// Whether the last option should be interpreted as an "other" option to
  /// draw a secondary form for the user to fill in the custom value
  final bool otherOptionEnabled;

  /// Whether the "other" option's form will be placed horizontally or
  /// vertically aligned with this form
  final Axis? otherOptionAxis;

  /// The text that will be displayed when the "other" option is selected
  final String otherOptionText;

  /// The widget that will hold the form for the "other" option. It MUST have a
  /// key associated with it, so that we can access the form value
  final TForm<T>? otherOptionForm;

  /// The object that is used as a placeholder value for the "other" option in
  /// the dropdown. It will be returned when the form fails to return the input
  /// value from the state
  final T? otherOptionPlaceholder;

  /// Defines how sorting should be performed in the dropdown elements. Defaults
  /// to ordering by the text value provided by the `toDropdownText` function
  final TDropdownSortLogic sortLogic;

  /// Defines how sorting should be performed in the chip elements. Defaults
  /// to ordering by the text value provided by the `toDropdownText` function
  final TChipSortLogic chipSortLogic;

  /// A static function that always resolves to true, to be used as a default
  /// for [isOptionEnabledCallback]
  static bool _alwaysEnabled(_) => true;

  const TFormDropdownListChip({
    required this.selectedValuesText,
    required this.noElementText,
    required this.hintText,
    required this.options,
    required this.toDropdownText,
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.sortLogic = TDropdownSortLogic.text,
    this.chipSortLogic = TChipSortLogic.text,
    this.isOptionEnabledCallback = _alwaysEnabled,
    super.onValueAdded,
    super.onValueDeleted,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) :
    otherOptionForm = null,
    otherOptionPlaceholder = null,
    otherOptionEnabled = false,
    otherOptionText = '',
    otherOptionAxis = null;

  const TFormDropdownListChip.withOtherOption({
    required TForm<T> this.otherOptionForm,
    required T this.otherOptionPlaceholder,
    required this.otherOptionAxis,
    required this.selectedValuesText,
    required this.noElementText,
    required this.hintText,
    required this.options,
    required this.toDropdownText,
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.sortLogic = TDropdownSortLogic.text,
    this.chipSortLogic = TChipSortLogic.text,
    this.isOptionEnabledCallback = _alwaysEnabled,
    this.otherOptionText = '',
    super.onValueAdded,
    super.onValueDeleted,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.decoratorIcon,
    super.prefixIcon,
    super.suffixIcon,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  }) : otherOptionEnabled = true;

  @override
  TFormDropdownListChipState<T> createState() =>
      TFormDropdownListChipState<T>();
}

class TFormDropdownListChipState<T>
    extends TFormListState<T, TFormDropdownListChip<T>>
    with
        DecoratorIconUpdateableForm<List<T>, TFormDropdownListChip<T>>,
        PrefixIconUpdateableForm<List<T>, TFormDropdownListChip<T>>,
        SuffixIconUpdateableForm<List<T>, TFormDropdownListChip<T>> {
  /// And the associated form key
  final TDropdownFormKey<T> _dropdownKey = TDropdownFormKey<T>();

  /// Whether options have been updated manually
  bool _hasUpdatedOptions = false;

  late List<T> _totalOptions;

  /// Whether the currently selected option is the "other" option
  bool get otherOptionSelected =>
      _dropdownKey.currentState?.otherOptionSelected ?? false;

  /// The current list of available options in the dropdown, computed by
  /// removing the already selected values from the total option list
  Iterable<T> get _currentOptions => _totalOptions.where(
    (T data) => !(value ?? <T>[]).contains(data),
  );

  @override
  void validate() {
    super.validate();
    // Because the error message is displayed in the inner dropdown, we
    // propagate the validation call there
    _dropdownKey.currentState?.validate();
  }

  /// This will update the inner dropdown's options according to what we have
  /// already selected. It is imperative to have this called whenever we update
  /// the list of total options or update the selected values
  void _refreshDropdownOptions() =>
      _dropdownKey.currentState?.updateOptions(_currentOptions.toSet());

  @override
  set value(List<T>? newValue) {
    super.value = newValue;
    // After forcing an update on the list of selected values, we must re-render
    // the dropdown with the new options. Previously selected values that are
    // no longer available in the dropdown will still be selected
    _refreshDropdownOptions();
  }

  @override
  void addElement(T newValue) {
    // Suppress adding the other option placeholder, we instead want to add it
    // through the "other option submit" function
    if (newValue == widget.otherOptionPlaceholder || otherOptionSelected) {
      return;
    }
    super.addElement(newValue);
    // This will automatically reset the dropdown state to remove the selected
    // option from the option list
    _refreshDropdownOptions();
  }

  @override
  void deleteElement(int index) {
    super.deleteElement(index);
    // This will automatically re-include the deleted option in the dropdown
    _refreshDropdownOptions();
  }

  @override
  void deleteElementByReference(T data) {
    super.deleteElementByReference(data);
    // This will automatically re-include the deleted option in the dropdown
    _refreshDropdownOptions();
  }

  /// This function should be called to submit the current "other option" form's
  /// state as a new element in our list
  void submitOtherOption() {
    // If there's no other option, or if it's not selected, abort the call
    if (!otherOptionSelected) {
      return;
    }
    // Take the other option form's value and add it to the list of elements if
    // we have a valid value
    T? otherOptionValue = _dropdownKey.currentState?.value;
    if (otherOptionValue != null) {
      // We also set the dropdown value to null to reset the selected value
      _dropdownKey.currentState?.value = null;
      super.addElement(otherOptionValue);
    }
  }

  /// Updates the dropdown's current list of options, preserving the option that
  /// was appointed as an "other" option, and preserving the current value if
  /// it is still among the new options provided
  void updateOptions(Set<T> newOptions) {
    _hasUpdatedOptions = true;
    _updateOptions(newOptions);
  }

  void _updateOptions(Set<T> newOptions) {
    // First we update our inner list of options
    _totalOptions = newOptions.toList();
    // Because this triggers a change in the internal state that could cause
    // a validation error or a change in how the value is interpreted, we call
    // on both the validation and change callbacks
    validate();
    widget.onValueChanged?.call(value);
    // Finally, we propagate the new options to the inner dropdown
    _refreshDropdownOptions();
  }

  @override
  void didUpdateWidget(covariant TFormDropdownListChip<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Stop widget updates if we have ever updated options manually through the
    // public interface
    if (
      !_hasUpdatedOptions &&
      Object.hashAll(_totalOptions) != Object.hashAll(widget.options)
    ) {
      _updateOptions(widget.options.toSet());
    }
  }

  @override
  void initState() {
    super.initState();

    // Copy the given initial options into the inner state
    _totalOptions = widget.options;
  }

  Widget get _dropdown => widget.otherOptionEnabled
    ? TFormDropdown<T>.withOtherOption(
        key: _dropdownKey,
        enabled: enabled,
        readonly: readonly,
        title: title,
        subtitle: subtitle,
        hintText: widget.hintText,
        errorMessage: errorMessage,
        initialValue: null,
        options: _currentOptions.toList(),
        toDropdownText: widget.toDropdownText,
        isOptionEnabledCallback: widget.isOptionEnabledCallback,
        sortLogic: widget.sortLogic,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        otherOptionForm: widget.otherOptionForm!,
        otherOptionPlaceholder: widget.otherOptionPlaceholder != null
          ? widget.otherOptionPlaceholder!
          : throw Exception('Null placeholder received in T dropdown'),
        otherOptionAxis: widget.otherOptionAxis,
        otherOptionText: widget.otherOptionText,
        // There's no need to double validate, just display this form's error
        // message
        validationCallback: (_) => errorMessage,
        // Automatically add a value when we choose it in the dropdown
        onValueChanged: (T? chosen) =>
            chosen != null ? addElement(chosen) : null,
      )
    : TFormDropdown<T>(
        key: _dropdownKey,
        enabled: enabled,
        readonly: readonly,
        title: title,
        subtitle: subtitle,
        hintText: widget.hintText,
        errorMessage: errorMessage,
        initialValue: null,
        options: _currentOptions.toList(),
        toDropdownText: widget.toDropdownText,
        isOptionEnabledCallback: widget.isOptionEnabledCallback,
        sortLogic: widget.sortLogic,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // There's no need to double validate, just display this form's error
        // message
        validationCallback: (_) => errorMessage,
        // Automatically add a value when we choose it in the dropdown
        onValueChanged: (T? chosen) =>
            chosen != null ? addElement(chosen) : null,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _dropdown,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TChipList<T>(
            title: widget.selectedValuesText,
            noChipsText: widget.noElementText,
            removeText: 'Remove',
            content: value ?? <T>[],
            dataToString: widget.toDropdownText,
            deleteCallback:
                enabled && !readonly ? deleteElementByReference : null,
            sortLogic: widget.chipSortLogic,
          ),
        ),
      ].separateWith(const SizedBox(height: 10)),
    );
  }
}
