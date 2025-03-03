import 'package:flutter/material.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/discardable_changes.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/dialog.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/dropdown.dart';
import 'package:tfields/widgets/form/list_string.dart';
import 'package:tfields/widgets/form/number.dart';
import 'package:tfields/widgets/form/string.dart';
import 'package:tfields/widgets/form/switch.dart';
import 'package:tfields/widgets/rounded_border.dart';

/// A showcase of different form field widgets from the TFields library
class FormShowcase extends StatefulWidget {
  const FormShowcase({super.key});

  @override
  State<FormShowcase> createState() => FormShowcaseState();
}

/// State class for FormShowcase that demonstrates different form types
/// and their validation capabilities
class FormShowcaseState extends State<FormShowcase>
    with
        Loggable,
        AlertHandler<FormShowcase>,
        DiscardableChanges<FormShowcase> {
  // Determines if any of the form fields have pending changes
  // This is used by the PopScope to prevent accidental navigation away
  // and by the save button to know when changes need to be saved
  @override
  bool get hasChanges =>
      (_switchFormKey.currentState?.hasChanges ?? false) ||
      (_dropdownFormKey.currentState?.hasChanges ?? false) ||
      (_dropdownExtraFormKey.currentState?.hasChanges ?? false) ||
      (_stringFormKey.currentState?.hasChanges ?? false) ||
      (_listStringFormKey.currentState?.hasChanges ?? false) ||
      (_integerFormKey.currentState?.hasChanges ?? false) ||
      (_bigIntegerFormKey.currentState?.hasChanges ?? false);

  /// Determines if any of the form fields have validation errors
  /// Used to prevent saving changes while errors exist
  bool get hasErrors =>
      (_switchFormKey.currentState?.hasErrors ?? false) ||
      (_dropdownFormKey.currentState?.hasErrors ?? false) ||
      (_dropdownExtraFormKey.currentState?.hasErrors ?? false) ||
      (_stringFormKey.currentState?.hasErrors ?? false) ||
      (_listStringFormKey.currentState?.hasErrors ?? false) ||
      (_integerFormKey.currentState?.hasErrors ?? false) ||
      (_bigIntegerFormKey.currentState?.hasErrors ?? false);

  /// Collects error messages from all form fields with validation errors
  /// and formats them for display in a dialog
  String get errorMessages {
    List<String> errors = <String>[];

    // Check each form for errors and add them to the list with form type names
    if (_switchFormKey.currentState?.hasErrors ?? false) {
      errors.add('TFormSwitch: ${_switchFormKey.currentState!.errorMessage}');
    }

    if (_dropdownFormKey.currentState?.hasErrors ?? false) {
      errors.add(
        'TFormDropdown: ${_dropdownFormKey.currentState!.errorMessage}',
      );
    }

    if (_dropdownExtraFormKey.currentState?.hasErrors ?? false) {
      errors.add(
        'TFormDropdown.withOtherOption: '
        '${_dropdownExtraFormKey.currentState!.errorMessage}',
      );
    }

    if (_stringFormKey.currentState?.hasErrors ?? false) {
      errors.add('TFormString: ${_stringFormKey.currentState!.errorMessage}');
    }

    if (_listStringFormKey.currentState?.hasErrors ?? false) {
      errors.add(
        'TFormListString: ${_listStringFormKey.currentState!.errorMessage}',
      );
    }

    if (_integerFormKey.currentState?.hasErrors ?? false) {
      errors.add('TFormInteger: ${_integerFormKey.currentState!.errorMessage}');
    }

    if (_bigIntegerFormKey.currentState?.hasErrors ?? false) {
      errors.add(
        'TFormInteger: ${_bigIntegerFormKey.currentState!.errorMessage}',
      );
    }

    // Join all errors with newlines so they appear on separate lines
    return errors.join('\n');
  }

  // Handles saving changes from all forms
  // Shows an error dialog if any form has validation errors
  // Otherwise resets all forms' initial values to remove "changed" state
  @override
  Future<void> saveChanges() async {
    // First check if any forms have validation errors
    if (hasErrors) {
      // Show a warning dialog with all the error messages
      await showCommonDialog(
        TDialog.warning(
          titleText: 'Form Errors',
          bodyText: 'Please fix the following errors before saving:\n\n'
              '$errorMessages',
          confirmText: 'OK',
        ),
      );
      return;
    }

    // No errors, so reset all forms' initial values to match current values
    // This effectively marks all forms as "unchanged"
    _switchFormKey.currentState?.resetInitialValue();
    _dropdownFormKey.currentState?.resetInitialValue();
    _dropdownExtraFormKey.currentState?.resetInitialValue();
    _stringFormKey.currentState?.resetInitialValue();
    _listStringFormKey.currentState?.resetInitialValue();
    _integerFormKey.currentState?.resetInitialValue();
    _bigIntegerFormKey.currentState?.resetInitialValue();

    // Refresh the UI to reflect changes in hasChanges state
    setState(() {});
  }

  /// Validates the switch form's value against the dropdown form
  /// Returns an error message if both conditions are true
  String _switchFormValidation(bool value) =>
      (value && _dropdownFormKey.currentState?.value == 'Option1')
    ? 'TFormDropdown option 1 and TFormSwitch true are incompatible'
    : '';

  /// Validates the dropdown form's value against the switch form
  /// Returns an error message if both conditions are true
  String _dropdownFormValidation(String? value) =>
      (value == 'Option1' && (_switchFormKey.currentState?.value ?? false))
    ? 'TFormDropdown option 1 and TFormSwitch true are incompatible'
    : '';

  /// Validates dropdown with "Other" option
  /// Checks if the "Other" value is filled when "Other" is selected
  /// Also validates that the "Other" value doesn't contain any numbers
  String _dropdownExtraValidation(String? value) {
    if (value == 'Other') {
      // Get the actual text value entered in the "Other" field
      String? userInput = _dropdownExtraFormKey.currentState?.otherOptionValue;

      // Check if the "Other" value is empty
      if (userInput == null || userInput.isEmpty) {
        return 'Please fill in the "Other" value';
      }

      // Check if the "Other" value contains any numeric characters
      if (RegExp(r'\d+').hasMatch(userInput)) {
        return 'The "Other" value must not have numbers';
      }
    }
    return '';
  }

  /// Validates a string value to ensure it's not empty
  /// Returns an error message if the string is empty, otherwise empty string
  String _stringFormValidation(String value) {
    if (value.isEmpty) {
      return 'Field cannot be empty';
    }
    return '';
  }

  /// Validates a list of strings with multiple rules
  /// Returns a newline-separated list of errors for any validation failures
  String _listStringFormValidation(List<String> values) {
    // Collect all errors in a list to display them all at once
    List<String> errors = <String>[];

    // Check for minimum count
    if (values.isEmpty) {
      errors.add('List must have at least one element');
    }

    // Check for maximum count
    if (values.length > 3) {
      errors.add('List can have at most 3 elements');
    }

    // Check for empty values
    for (int i = 0; i < values.length; i++) {
      if (values[i].isEmpty) {
        errors.add('Value ${i + 1} cannot be empty');
      }
    }

    // Check for duplicate values using a Set
    // Set.add() returns false if the element was already in the set
    // This provides an efficient way to detect duplicates in a single pass
    Set<String> uniqueValues = <String>{};
    for (String value in values) {
      if (value.isNotEmpty && !uniqueValues.add(value)) {
        errors.add('Value "$value" is used more than once');
      }
    }

    // Return all errors as a newline-separated string
    return errors.join('\n');
  }

  /// Triggers validation on the switch and dropdown forms
  /// Since their validation is connected (they check each other's values),
  /// both need to be validated when either one changes
  void _triggerSwitchAndDropdownValidation() {
    // Validate both forms since they depend on each other
    _switchFormKey.currentState?.validate();
    _dropdownFormKey.currentState?.validate();

    // Update the UI to show any validation errors
    setState(() {});
  }

  // Form instance and key for boolean switch form
  late TFormSwitch _switchForm;
  final SwitchFormKey _switchFormKey = SwitchFormKey();

  // Form instance and key for standard dropdown form
  late TFormDropdown _dropdownForm;
  final DropdownFormKey _dropdownFormKey = DropdownFormKey();

  // Form instance and key for dropdown form with extra "Other" option
  late TFormDropdown _dropdownExtraForm;
  final DropdownFormKey _dropdownExtraFormKey = DropdownFormKey();

  // Form instance and key for basic string input form
  late TFormString _stringForm;
  final StringFormKey _stringFormKey = StringFormKey();

  // Form instance and key for list of strings input form
  late TFormListString _listStringForm;
  final ListStringFormKey _listStringFormKey = ListStringFormKey();

  // Form instance and key for integer input form
  late TFormInteger _integerForm;
  final IntegerFormKey _integerFormKey = IntegerFormKey();

  // Form instance and key for big integer input form
  late TFormBigInteger _bigIntegerForm;
  final BigIntegerFormKey _bigIntegerFormKey = BigIntegerFormKey();

  /// Initialize all form widgets
  ///
  /// Forms are initialized in initState() rather than build()
  /// for stateful widgets because:
  ///   1. We need to maintain form instances across rebuilds
  ///   2. Keys need to be consistent for form state access
  ///   3. Prevents recreation of forms on every build, which would reset state
  @override
  void initState() {
    super.initState();

    // Initialize switch form with boolean value
    // Note: This form's validation depends on _dropdownForm's value,
    // demonstrating cross-form validation
    _switchForm = TFormSwitch(
      enabled: true,
      title: 'TFormSwitch',
      subtitle: "Because it's just a boolean, validating its value is "
          'pointless by itself, should be combined with some other condition',
      onText: 'Value is currently TRUE', // Text shown when switch is on
      offText: 'Value is currently FALSE', // Text shown when switch is off
      initialValue: true,
      // Validation callback receives the form's value and returns error message
      validationCallback: _switchFormValidation,
      // When value changes, we need to validate both this form and the dropdown
      // since they have interdependent validation
      onValueChanged: (_) => _triggerSwitchAndDropdownValidation(),
      // Key is crucial for accessing form state later via
      // _switchFormKey.currentState
      key: _switchFormKey,
    );

    // Initialize standard dropdown form
    // This form has fixed options that the user selects from
    _dropdownForm = TFormDropdown(
      enabled: true,
      title: 'TFormDropdown',
      subtitle: 'Because the options are fixed, validating its value is '
          'pointless by itself, should be combined with some other condition',
      hintText: 'Pick something!', // Displayed when no value is selected
      initialValue: 'Option1',
      // Available dropdown options
      options: const <String>['Option1', 'Option2'],
      // This form's validation depends on switch value,
      // showing cross-form validation
      validationCallback: _dropdownFormValidation,
      onValueChanged: (_) => _triggerSwitchAndDropdownValidation(),
      // Key allows access to form state via _dropdownFormKey.currentState
      key: _dropdownFormKey,
    );

    // Initialize dropdown with "Other" option
    // This specialized dropdown allows users to enter custom values
    _dropdownExtraForm = TFormDropdown.withOtherOption(
      enabled: true,
      title: 'TFormDropdown.withOtherOption',
      subtitle: 'An extra "other" option is provided, which will prompt the '
          'user to type in a value not present in the dropdown. In this '
          'example, it also cannot contain numbers',
      hintText: 'Pick something!',
      initialValue: '',
      // ignore: prefer_const_literals_to_create_immutables
      regularOptions: <String>['Regular option'], // Standard dropdown options
      otherOptionText: 'Other', // Text for the "Other" option in dropdown
      otherOptionHintText: 'Other value...', // Hint for the "Other" text field
      // Validates both the dropdown selection and any custom "Other" value
      validationCallback: _dropdownExtraValidation,
      // Simple callback to refresh UI when value changes
      onValueChanged: (_) => setState(() {}),
      key: _dropdownExtraFormKey,
    );

    // Initialize basic string input form
    // Demonstrates simple text input with validation
    _stringForm = TFormString(
      enabled: true,
      title: 'TFormString',
      subtitle: 'A simple text input field with validation that the field '
          'cannot be empty',
      hintText: 'Enter some text...', // Displayed when field is empty
      initialValue: '', // Start with empty string
      // Validates that the string isn't empty
      validationCallback: _stringFormValidation,
      // Simple callback to refresh UI when value changes
      onValueChanged: (_) => setState(() {}),
      key: _stringFormKey,
    );

    // Initialize list of strings form
    // Demonstrates a dynamic list of inputs with complex validation rules
    _listStringForm = TFormListString(
      enabled: true,
      title: 'TFormListString',
      subtitle: 'A list of text input fields with multiple validation rules:\n'
          '- At least one element\n'
          '- Maximum of 3 elements\n'
          '- No empty values\n'
          '- No duplicate values',
      hintText: 'Enter text...', // Hint for each text field in the list
      newEntryText: 'Add new value', // Text for the "add new" button
      initialValue: const <String>['Default value'], // Start with one value
      // Complex validation that checks count, emptiness, and duplicates
      validationCallback: _listStringFormValidation,
      // Simple callback to refresh UI when list changes
      onValueChanged: (_) => setState(() {}),
      key: _listStringFormKey,
    );

    // Initialize integer form
    // Demonstrates a numeric input with min/max constraints
    _integerForm = TFormInteger(
      enabled: true,
      title: 'TFormInteger',
      subtitle: 'This form only accepts digits 0-9, and will automatically '
          'collapse to the min (1) and max (100000) values',
      initialValue: '1000',
      snapToMinOnEmpty: true,
      minValue: 1,
      maxValue: 100000,
      // Simple callback to refresh UI when value changes
      onValueChanged: (_) => setState(() {}),
      key: _integerFormKey,
    );

    // Initialize big integer form
    // Demonstrates a numeric input with negative min/max constraints and comma
    // separation
    _bigIntegerForm = TFormBigInteger(
      enabled: true,
      title: 'TFormBigInteger',
      subtitle: 'This form only accepts digits 0-9, and accepts very large '
          'integers, up to 1 trillion including negatives. It also showcases '
          'automatic comma separation, useful for large inputs',
      initialValue: '0',
      commaSeparate: true,
      minValue: BigInt.parse('-1000000000000'),
      maxValue: BigInt.parse('1000000000000'),
      // Simple callback to refresh UI when value changes
      onValueChanged: (_) => setState(() {}),
      key: _bigIntegerFormKey,
    );

    // Schedule validation after the first frame is rendered
    // This is necessary because the form states aren't fully initialized
    // until after the first build
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _triggerSwitchAndDropdownValidation(),
    );
  }

  /// Build the UI with all form widgets
  ///
  /// The PopScope prevents accidental navigation if there are unsaved changes
  /// Each form is wrapped in a TRoundedBorder for visual separation
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent navigating back if there are unsaved changes
      canPop: !hasChanges,
      // Called when user tries to navigate away
      onPopInvokedWithResult: onPopInvoked,
      child: CommonScaffold(
        title: 'TFields Demo - Form Showcase',
        // Save button provided by DiscardableChanges mixin
        floatingActionButton: saveButton,
        children: <Widget>[
          // Display all forms in a list, each with consistent styling
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _switchForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _dropdownForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _dropdownExtraForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _stringForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _listStringForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _integerForm,
          ),
          TRoundedBorder(
            color: TFormTitle.subtitleColor,
            childPadding: const EdgeInsets.only(right: 15),
            child: _bigIntegerForm,
          ),
        ],
      ),
    );
  }
}
