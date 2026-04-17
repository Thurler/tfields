import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/widgets.dart';

// This example demonstrates the TForm interface using TFormString as
// the concrete implementation. All TForm implementations (String, Int,
// Double, Date, etc.) share the same properties and methods showcased here.
//
// KEY CONCEPT: TForm widgets use a typed GlobalKey pattern to allow
// external access to their state and methods. This enables you to interact
// with the form field programmatically from parent widgets.
class FormsExampleView extends StatefulWidget {
  const FormsExampleView({super.key});

  @override
  State<FormsExampleView> createState() => _FormsExampleViewState();
}

class _FormsExampleViewState extends State<FormsExampleView>
    with TDialogDisplayer<FormsExampleView> {
  // Create a typed GlobalKey to access the TFormString's state
  // This key provides type-safe access to TFormStringState methods and
  // properties. Each TForm type has its own typed key (TStringFormKey,
  // TIntFormKey, TDoubleFormKey, etc.)
  final TStringFormKey _stringKey = TStringFormKey();

  // Make one for the dropdown that has the "other" option too, to showcase
  // changes to its state, along with one for the "other" option form
  final TDropdownFormKey<String> _dropdownKey = TDropdownFormKey<String>();
  final TStringFormKey _otherOptionKey = TStringFormKey();

  bool _dropdownHasBlue = true;

  bool _hasToggledRebuildDemo = false;

  // Create keys for the StringListChip examples
  final TStringListChipFormKey _stringListChipKey = TStringListChipFormKey();

  // Create keys for the DropdownListChip examples
  final TStringFormKey _dropdownListChipOtherOptionKey = TStringFormKey();

  // Helper function to display empty strings as '<empty>' for clarity
  String formatString(String value) => value.isNotEmpty ? value : '<empty>';

  @override
  Widget build(BuildContext context) {
    return TCommonScaffold(
      title: 'Forms showcase',
      children: <Widget>[
        SelectableText(
          'TForm (properties that are common for all kinds of forms)',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        // ====================================================================
        // TFORM WIDGET CONFIGURATION
        // ====================================================================
        //
        // All TForm implementations share these common properties:
        TFormString(
          // Attach the typed key to access state externally
          key: _stringKey,

          // enabled: Controls whether the form field accepts user input, and
          // shows with a grayed out palette or not
          // When false, the field is grayed out and non-interactive
          enabled: !_hasToggledRebuildDemo,

          // readonly: Controls whether the form field accepts user input when
          // enabled
          readonly: _hasToggledRebuildDemo,

          // title: Required label displayed above the field
          title: 'Forms require a title'
              '${_hasToggledRebuildDemo ? ' (Rebuild)' : ''}',

          // subtitle: Optional secondary text below the title
          // Useful for providing additional context or instructions
          subtitle: 'Forms may have a subtitle'
              '${_hasToggledRebuildDemo ? ' (Rebuild)' : ''}',

          // hintText: Placeholder text shown when the field is empty
          // This one is actually string form specific, but we're using it to
          // contextualize the validation
          hintText: 'In this example, only strings with even length are valid'
              '${_hasToggledRebuildDemo ? ' (Rebuild)' : ''}',

          // initialValue: The starting value for the field
          // This is used to track whether the field has changes (hasChanges)
          initialValue:
              _hasToggledRebuildDemo ? _stringKey.currentState?.value : '',

          // decoratorIcon: Icon displayed at the far left of the field
          // Visually identifies the field type or purpose
          decoratorIcon: _hasToggledRebuildDemo
            ? const Icon(Icons.refresh)
            : const Icon(Icons.abc),

          // prefixIcon: Icon displayed inside the input area on the left
          prefixIcon: _hasToggledRebuildDemo
            ? const Icon(Icons.refresh)
            : const Icon(Icons.arrow_left),

          // suffixIcon: Icon displayed inside the input area on the right
          suffixIcon: _hasToggledRebuildDemo
            ? const Icon(Icons.refresh)
            : const Icon(Icons.arrow_right),

          // validationCallback: Function that returns an error message string
          // Return empty string for valid input, error message for invalid
          // This is called when validate() is invoked on the form state, and
          // whenever the value is changed for any reason
          validationCallback: (String? value) => (value ?? '').length.isOdd
            ? 'String must have an even number of characters'
            : '',

          // onValueChanged: Callback fired whenever the field value changes
          // Useful for triggering UI updates or validation logic
          onValueChanged: (_) => setState(() {}),
        ),

        // ====================================================================
        // INTERACTIVE STATE DEMONSTRATION
        // ====================================================================
        //
        // The widgets below demonstrate how to read and modify TForm
        // state using the typed key (_stringKey.currentState). While properties
        // can be changed by simply rebuilding the widget (as demonstrated by
        // the first button)
        //
        // IMPORTANT: setting a property through the state typed key prevents
        // further updates from happening through widget rebuilds. Be careful
        // when managing the same state between the typed key and widget rebuild
        //
        // This can be observed in this demo by toggling the enabled property
        // manually through the switch - the rebuild button will stop updating
        // the enabled property on rebuilds
        //
        // IMPORTANT: the initial value and current value CANNOT be changed
        // through rebuilds, as they are integral to the form state. Any changes
        // to them should be done through the state's typed key
        TButton.elevated.refresh(
          textOverride: 'Change attributes through rebuild',
          onPressed: () => setState(() {
            _hasToggledRebuildDemo = !_hasToggledRebuildDemo;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => setState(() {}),
            );
          }),
        ),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
            // PROPERTY: enabled (read/write)
            // Controls whether the field accepts input
            // This is a settable property that can be toggled at runtime
            _TitledSwitch(
              title: 'enabled',
              value: _stringKey.currentState?.enabled ?? true,
              onChanged: (bool newValue) => setState(() {
                _stringKey.currentState?.enabled = newValue;
              }),
            ),

            // PROPERTY: readonly (read/write)
            // When true, the field displays its value but doesn't allow
            // editing. Unlike disabled, readonly fields are still visually
            // "active"
            _TitledSwitch(
              title: 'readonly',
              value: _stringKey.currentState?.readonly ?? false,
              onChanged: (bool newValue) => setState(() {
                _stringKey.currentState?.readonly = newValue;
              }),
            ),

            // PROPERTY: hasChanges (read-only)
            // Returns true when the current value differs from initialValue
            // Automatically tracks whether the user has modified the field
            _TitledSwitch(
              title: 'hasChanges',
              value: _stringKey.currentState?.hasChanges ?? false,
            ),

            // PROPERTY: hasErrors (read-only)
            // Returns true when validate() has been called and validation
            // failed. The error message from validationCallback is shown in
            // the UI
            _TitledSwitch(
              title: 'hasErrors',
              value: _stringKey.currentState?.hasErrors ?? false,
            ),

            // PROPERTY: value (read-only)
            // The current value in the field as the user types
            Column(
              children: <Widget>[
                const Text('Current value'),
                Text(formatString(_stringKey.currentState?.value ?? '')),
              ],
            ),

            // PROPERTY: initialValue (read-only)
            // The baseline value used to determine hasChanges
            // Can be reset using resetInitialValue()
            Column(
              children: <Widget>[
                const Text('Initial value'),
                Text(formatString(_stringKey.currentState?.initialValue ?? '')),
              ],
            ),

            // METHOD: validate()
            // Runs the validationCallback and updates hasErrors accordingly
            // If validation fails, the error message is displayed in the UI
            // Returns true if valid, false otherwise
            //
            // TYPICAL USE CASE: Call this before submitting a form to ensure
            // all fields meet their validation requirements
            TButton.elevated(
              text: 'validate',
              onPressed: () {
                TFormStringState? state = _stringKey.currentState;
                if (state == null) {
                  return;
                }
                state.validate();
                if (state.hasErrors) {
                  unawaited(showWarning('Form has errors!'));
                } else {
                  unawaited(showSuccess('Form is valid!'));
                }
              },
            ),

            // METHOD: resetInitialValue()
            // Sets initialValue to the current value
            // This resets hasChanges to false, treating the current state as
            // the new baseline
            //
            // TYPICAL USE CASE: Call this after successfully saving data to
            // the backend, so the form no longer shows "unsaved changes"
            TButton.elevated(
              text: 'resetInitialValue',
              onPressed: () => setState(() {
                _stringKey.currentState?.resetInitialValue();
              }),
            ),

            // METHOD: saveValue()
            // Combines resetInitialValue() and get value in one operation:
            TButton.elevated(
              text: 'saveValue',
              onPressed: () {
                TFormStringState? state = _stringKey.currentState;
                if (state == null) {
                  return;
                }
                String? value = state.saveValue();
                unawaited(showSuccess('Saved value: $value'));
                setState(() {});
              },
            ),
          ],
        ),

        // ====================================================================
        // TFORM STRING SPECIFIC PROPERTIES
        // ====================================================================
        //
        // TFormString extends the base TForm with string-specific
        // features that are demonstrated below:
        SelectableText(
          'TFormString',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          children: <TGridItem>[
            TGridColumn(
              children: <Widget>[
                TFormString(
                  enabled: true,
                  title: 'TFormString',
                  initialValue: '',

                  // hintText: Placeholder text shown when the field is empty
                  // Already demonstrated in the first example - guides users
                  // on expected input format
                  hintText: 'Type a message...',

                  // submitCallback: Called when user presses Enter
                  // (single-line only). In multi-line mode, Enter creates a
                  // new line instead
                  submitCallback: () => showSuccess(
                    'Submit callback fired! (only works on single-line)',
                  ),
                ),

                // searchBar automatically adds standardized icons to prefix
                // and suffix, as well as mapping the submitCallback property
                // to the suffix icon
                TFormString.searchBar(
                  enabled: true,
                  title: 'TFormString.searchBar',
                  initialValue: '',
                  submitCallback: () =>
                      showSuccess('Search submit callback fired!'),
                ),
              ],
            ),
            TGridItem(
              child: const TFormString(
                enabled: true,
                title: 'TFormString (multiline)',
                initialValue: '',

                // isMultiline: Controls single-line vs multi-line behavior
                // When false (default): Single line, Enter triggers
                // submitCallback
                // When true: Multi-line, Enter creates new line
                isMultiline: true,
              ),
            ),
          ],
        ),

        // ====================================================================
        // TFORM STRING LIST CHIP
        // ====================================================================
        //
        // TFormStringListChip is a specialized form for collecting a list
        // of strings. It displays the entered strings as chips and allows the
        // user to add new ones via a text input field. It inherits from
        // TFormList<String>, which provides list-specific functionality.
        SelectableText(
          'TFormStringListChip',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          children: <TGridItem>[
            TGridColumn(
              children: <Widget>[
                TFormStringListChip(
                  key: _stringListChipKey,
                  enabled: true,
                  title: 'TFormStringListChip',
                  initialValue: const <String>['Tag 1', 'Tag 2'],
                  subtitle: 'Type a string and hit Enter to add it',
                  onValueChanged: (_) => setState(() {}),

                  // submitCallback: Called when the user presses Enter with an
                  // empty input field. This is useful for submitting forms
                  // when the user is done entering values
                  submitCallback: () => showSuccess(
                    'Submit callback fired! (press Enter with no text)',
                  ),
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),
            TGridColumn(
              children: <Widget>[
                // The following widgets demonstrate the list-specific state
                // properties and methods available through the typed key
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: <Widget>[
                    // PROPERTY: inputText (read-only)
                    // Returns the current text in the input field (not yet
                    // submitted as a chip)
                    Column(
                      children: <Widget>[
                        TClickable(
                          onTap: () => setState(() {}),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(Icons.refresh),
                              const Text('Text on the input'),
                            ].separateWith(const SizedBox(width: 5)),
                          ),
                        ),
                        Text(
                          formatString(
                            _stringListChipKey.currentState?.inputText ?? '',
                          ),
                        ),
                      ],
                    ),

                    // METHOD: addElement(String)
                    // Programmatically adds a new string to the list
                    // The string will appear as a new chip
                    TButton.elevated(
                      text: 'addElement',
                      onPressed: () => setState(() {
                        _stringListChipKey.currentState?.addElement(
                          'New item ${DateTime.now().second}',
                        );
                      }),
                    ),

                    // METHOD: deleteElement(int index)
                    // Removes the chip at the specified index
                    // Index is zero-based
                    TButton.elevated(
                      text: 'deleteElement(0)',
                      onPressed: () => setState(() {
                        _stringListChipKey.currentState?.deleteElement(0);
                      }),
                    ),

                    // METHOD: forceSubmit()
                    // Forces the submit callback to be called, even if there
                    // is text in the input field. This bypasses the normal
                    // check that only calls submit when the input is empty
                    TButton.elevated(
                      text: 'forceSubmit',
                      onPressed: () => setState(() {
                        _stringListChipKey.currentState?.forceSubmit();
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ====================================================================
        // TFORM NUMBER SPECIFIC PROPERTIES
        // ====================================================================
        //
        // TFormNumber is the base class for all numeric form fields:
        // - TFormInteger: For int values
        // - TFormBigInteger: For BigInt values
        // - TFormDouble: For double values
        //
        // All numeric forms share these number-specific features:
        SelectableText(
          'TFormNumber (Integer, Double, BigInteger)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          children: <TGridItem>[
            // ================================================================
            // INTEGER EXAMPLES
            // ================================================================
            TGridColumn(
              children: <Widget>[
                const TFormInteger(
                  enabled: true,
                  title: 'TFormInteger (unsigned)',
                  initialValue: 0,

                  // unsigned: When true (default), only positive numbers are
                  // allowed. The minus sign cannot be entered.
                  // ignore: avoid_redundant_argument_values
                  unsigned: true,
                ),
                const TFormInteger(
                  enabled: true,
                  title: 'TFormInteger (signed)',
                  initialValue: -10,

                  // unsigned: When false, both positive and negative numbers
                  // are allowed
                  unsigned: false,
                ),
                const TFormInteger(
                  enabled: true,
                  title: 'TFormInteger (min/max validation)',
                  initialValue: 50,

                  // minValue: The minimum value accepted by this input
                  // When validate() is called, values below this will show an
                  // error message automatically
                  minValue: 1,

                  // maxValue: The maximum value accepted by this input
                  // When validate() is called, values above this will show an
                  // error message automatically
                  maxValue: 100,

                  // Note: The user can still type values outside the min/max
                  // range, but validation will fail. Use snap behavior below
                  // to automatically clamp values to the range.
                ),
                const TFormInteger(
                  enabled: true,
                  title: 'TFormInteger (comma separated)',
                  initialValue: 1234567,

                  // commaSeparate: When true, large numbers are displayed with
                  // thousand separators for better readability
                  // Example: 1234567 becomes 1,234,567
                  commaSeparate: true,
                ),
                const TFormInteger(
                  enabled: true,
                  title: 'TFormInteger (snap to min when empty)',
                  initialValue: 10,
                  minValue: 10,
                  maxValue: 100,

                  // snapToMinOnEmpty: When true, if the user clears the field,
                  // it will automatically snap to the minValue
                  // This is useful for fields that must always have a value
                  snapToMinOnEmpty: true,
                ),
                const TFormInteger(
                  enabled: true,
                  title: 'TFormInteger (snap to max when over)',
                  initialValue: 50,
                  minValue: 0,
                  maxValue: 100,

                  // snapToMaxWhenOver: When true, if the user enters a value
                  // larger than maxValue, it will automatically snap to
                  // maxValue. This prevents values from exceeding the maximum
                  snapToMaxWhenOver: true,
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),

            // ================================================================
            // DOUBLE EXAMPLES
            // ================================================================
            TGridColumn(
              children: <Widget>[
                const TFormDouble(
                  enabled: true,
                  title: 'TFormDouble (unsigned)',
                  initialValue: 0,
                  // ignore: avoid_redundant_argument_values
                  unsigned: true,
                ),
                const TFormDouble(
                  enabled: true,
                  title: 'TFormDouble (signed)',
                  initialValue: -3.14,
                  unsigned: false,
                ),
                const TFormDouble(
                  enabled: true,
                  title: 'TFormDouble (min/max validation)',
                  initialValue: 0.5,
                  minValue: 0,
                  maxValue: 1,
                ),
                const TFormDouble(
                  enabled: true,
                  title: 'TFormDouble (comma separated)',
                  initialValue: 123456.789,
                  commaSeparate: true,
                ),
                const TFormDouble(
                  enabled: true,
                  title: 'TFormDouble (snap behaviors)',
                  initialValue: 50,
                  minValue: 10.5,
                  maxValue: 100.75,
                  snapToMinOnEmpty: true,
                  snapToMaxWhenOver: true,
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),

            // ================================================================
            // BIGINTEGER EXAMPLES
            // ================================================================
            TGridColumn(
              children: <Widget>[
                TFormBigInteger(
                  enabled: true,
                  title: 'TFormBigInteger (unsigned)',
                  initialValue: BigInt.zero,
                ),
                TFormBigInteger(
                  enabled: true,
                  title: 'TFormBigInteger (signed)',
                  initialValue: BigInt.from(-999999999999),
                  unsigned: false,
                ),
                TFormBigInteger(
                  enabled: true,
                  title: 'TFormBigInteger (min/max validation)',
                  initialValue: BigInt.from(500),
                  minValue: BigInt.zero,
                  maxValue: BigInt.from(1000),
                ),
                TFormBigInteger(
                  enabled: true,
                  title: 'TFormBigInteger (comma separated)',
                  initialValue: BigInt.parse('123456789012345'),
                  commaSeparate: true,
                ),
                TFormBigInteger(
                  enabled: true,
                  title: 'TFormBigInteger (snap behaviors)',
                  initialValue: BigInt.from(100),
                  minValue: BigInt.from(100),
                  maxValue: BigInt.from(999999999999999),
                  snapToMinOnEmpty: true,
                  snapToMaxWhenOver: true,
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),
          ],
        ),

        // ====================================================================
        // TFORM CHECKBOX
        // ====================================================================
        //
        // TFormCheckbox is a specialized form for boolean values that
        // displays a checkbox alongside text. Perfect for confirmations,
        // toggles, or any true/false selections.
        SelectableText(
          'TFormCheckbox',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const TFormCheckbox(
          enabled: true,
          title: 'TFormCheckbox',
          initialValue: false,

          // text: The text displayed alongside the checkbox
          // This is shown in the input field itself, not the title
          text: 'I agree to the terms and conditions',
        ),

        // ====================================================================
        // TFORM DROPDOWN
        // ====================================================================
        //
        // TFormDropdown allows users to select from a list of options.
        // It's type-safe and can work with any object type T, not just
        // strings.
        SelectableText(
          'TFormDropdown',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          children: <TGridItem>[
            TGridColumn(
              children: <Widget>[
                TFormDropdown<String>(
                  enabled: true,
                  title: 'TFormDropdown (String)',
                  initialValue: null,

                  // options: The list of values the user can choose from
                  options: const <String>['Option 1', 'Option 2', 'Option 3'],

                  // hintText: Placeholder text shown when no option is
                  // selected
                  hintText: 'Select an option',

                  // toDropdownText: Function to convert the option to a
                  // display string. For strings, we can just return the value
                  toDropdownText: (String option) => option,
                ),
                TFormDropdown<int>(
                  enabled: true,
                  title: 'TFormDropdown (int)',
                  initialValue: null,

                  // Type-safe: Can work with any type, not just strings
                  // Here we use int, but could be enum, custom class, etc.
                  options: const <int>[1, 2, 3, 4, 5],
                  hintText: 'Select a rating',

                  // toDropdownText: Converts the int to a display string
                  toDropdownText: (int rating) => '$rating stars',
                ),
                TFormDropdown<String>(
                  enabled: true,
                  title: 'TFormDropdown (no ordering)',
                  initialValue: null,
                  options: const <String>['Zebra', 'Apple', 'Mango', 'Banana'],
                  hintText: 'Select a fruit',
                  toDropdownText: (String option) => option,

                  // sortLogic: Controls how items are sorted in the dropdown
                  // - TDropdownSortLogic.none: Keep original order
                  // - TDropdownSortLogic.text: Sort by display text (default)
                  // - TDropdownSortLogic.object: Sort by object's Comparable
                  sortLogic: TDropdownSortLogic.none,
                ),
                TFormDropdown<int>(
                  enabled: true,
                  title: 'TFormDropdown (ordering by value)',
                  initialValue: null,
                  hintText: 'Select a value',
                  toDropdownText: (int value) => '$value',
                  options: const <int>[51, 10, 9],
                  sortLogic: TDropdownSortLogic.object,
                ),
                TFormDropdown<int>(
                  enabled: true,
                  title: 'TFormDropdown (ordering by text)',
                  initialValue: null,
                  hintText: 'Select a value',
                  toDropdownText: (int value) => '$value',
                  options: const <int>[51, 10, 9],
                  // ignore: avoid_redundant_argument_values
                  sortLogic: TDropdownSortLogic.text,
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),
            TGridColumn(
              children: <Widget>[
                TFormDropdown<String>.withOtherOption(
                  key: _dropdownKey,
                  enabled: true,
                  title: 'TFormDropdown (with "other" option)',
                  initialValue: null,
                  options: const <String>['Red', 'Green', 'Blue'],
                  hintText: 'Select color',
                  toDropdownText: (String option) => option,
                  onValueChanged: (_) => setState(() {}),

                  // otherOptionPlaceholder: A special value that represents
                  // the "other" option. When this is selected, a secondary
                  // form is shown for custom input
                  otherOptionPlaceholder: 'other',

                  // otherOptionText: The text to be used when displaying the
                  // "other" option in the dropdown
                  otherOptionText: 'Custom color',

                  // otherOptionForm: The form that appears when "other" is
                  // selected. Must have a key for value access
                  otherOptionForm: TFormString(
                    key: _otherOptionKey,
                    enabled: true,
                    title: 'Custom color',
                    initialValue: '',
                    hintText: "Type the custom color's name",
                    onValueChanged: (_) => setState(() {}),
                  ),

                  // otherOptionAxis: Controls layout of the secondary form
                  // - Axis.horizontal: Side by side
                  // - Axis.vertical: Stacked
                  // - null: Hide the secondary form
                  otherOptionAxis: Axis.vertical,
                ),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: <Widget>[
                    // METHOD: updateOptions
                    // Can be called to change the dropdown options after it is
                    // initialized. In this example, we can add/remove the
                    // "Blue" value from the options
                    _TitledSwitch(
                      title: 'updateOptions - has Blue?',
                      value: _dropdownHasBlue,
                      onChanged: (bool newValue) => setState(() {
                        _dropdownHasBlue = newValue;
                        _dropdownKey.currentState?.updateOptions(
                          <String>{'Red', 'Green', if (newValue) 'Blue'},
                        );
                      }),
                    ),

                    // PROPERTY: otherOptionSelected (read-only)
                    // Returns true when the current value matches the "other"
                    // option provided. Will only ever be true if the "other"
                    // option constructor was used
                    _TitledSwitch(
                      title: 'otherOptionSelected',
                      value: _dropdownKey.currentState?.otherOptionSelected ??
                          false,
                    ),

                    // PROPERTY: value (read-only)
                    // The current value updates with the value provided in the
                    // "other" option
                    Column(
                      children: <Widget>[
                        const Text('Current value'),
                        Text(
                          formatString(_dropdownKey.currentState?.value ?? ''),
                        ),
                      ],
                    ),
                  ],
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),
          ],
        ),

        // ====================================================================
        // TFORM DROPDOWN LIST CHIP
        // ====================================================================
        //
        // TFormDropdownListChip is a specialized form for collecting a
        // list of values from a dropdown. It displays the selected values as
        // chips and automatically removes selected options from the dropdown.
        // It inherits from TFormList<T>, which provides list-specific
        // functionality, and is type-safe like TFormDropdown.
        SelectableText(
          'TFormDropdownListChip',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          children: <TGridItem>[
            TGridColumn(
              children: <Widget>[
                TFormDropdownListChip<String>(
                  enabled: true,
                  title: 'TFormDropdownListChip',
                  hintText: 'Select a color',
                  initialValue: const <String>['Red'],
                  toDropdownText: (String color) => color,
                  onValueChanged: (_) => setState(() {}),

                  // selectedValuesText: Text displayed above the chip list
                  // Helps label the selected items
                  selectedValuesText: 'Selected colors:',

                  // noElementText: Text shown when no items are selected
                  noElementText: 'No color selected',

                  // options: The full list of options available in the
                  // dropdown. Options that are selected become chips and are
                  // removed from the dropdown
                  options: const <String>[
                    'Red',
                    'Green',
                    'Blue',
                    'Yellow',
                    'Orange',
                  ],

                  // chipSortLogic: Controls sorting of the chips display
                  // - TChipSortLogic.none: Order chips as they were added
                  // - TChipSortLogic.text: Sort chips alphabetically (default)
                  // - TChipSortLogic.object: Sort by object's Comparable
                  chipSortLogic: TChipSortLogic.object,
                ),
                TFormDropdownListChip<int>(
                  enabled: true,
                  title: 'TFormDropdownListChip (int, no sorting)',
                  initialValue: const <int>[3],
                  selectedValuesText: 'Numbers selected:',
                  noElementText: 'No number selected',
                  hintText: 'Select a number',

                  // Type-safe: Can work with any type, just like
                  // TFormDropdown
                  options: const <int>[1, 2, 3, 4, 5],
                  toDropdownText: (int num) => 'Number $num',

                  // Use ChipSortLogic.none to preserve insertion order
                  chipSortLogic: TChipSortLogic.none,
                ),
              ].separateWith(const SizedBox(height: 10)),
            ),
            TGridColumn(
              children: <Widget>[
                TFormDropdownListChip<String>.withOtherOption(
                  enabled: true,
                  title: 'TFormDropdownListChip (with "other" option)',
                  initialValue: const <String>[],
                  selectedValuesText: 'Selected tags:',
                  noElementText: 'No tag selected',
                  hintText: 'Select a tag',
                  options: const <String>['Bug', 'Feature', 'Docs'],
                  toDropdownText: (String tag) => tag,
                  onValueChanged: (_) => setState(() {}),

                  // otherOptionPlaceholder: The value representing "other"
                  // This value should be in the options list
                  otherOptionPlaceholder: 'other',

                  // otherOptionText: Display text for the "other" option
                  otherOptionText: 'Customized tag',

                  // otherOptionForm: The form shown when "other" is selected
                  // Must have a key for value access
                  otherOptionForm: TFormString(
                    key: _dropdownListChipOtherOptionKey,
                    enabled: true,
                    title: 'Customized tag',
                    initialValue: '',
                    hintText: "Type the custom tag's name",
                  ),

                  // otherOptionAxis: Controls layout of secondary form
                  // - Axis.horizontal: Side by side
                  // - Axis.vertical: Stacked
                  otherOptionAxis: Axis.vertical,
                ),
              ],
            ),
          ],
        ),

        // ====================================================================
        // TFORM DATETIME
        // ====================================================================
        //
        // TFormDateTime provides date and/or time selection with three
        // factory constructors for different use cases:
        // - dateOnly: Select only a date
        // - timeOnly: Select only a time
        // - dateAndTime: Select both date and time
        SelectableText(
          'TFormDateTime',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          children: <TGridItem>[
            // dateOnly: Opens a calendar picker for date selection
            // The time component is forced to zero
            // Displays as: DD/MM/YYYY
            TGridItem(
              child: TFormDateTime.dateOnly(
                enabled: true,
                title: 'TFormDateTime.dateOnly',
                initialValue: null,
              ),
            ),

            // timeOnly: Opens a time picker for time selection
            // The date component is forced to the current day
            // Displays as: HH:MM (24-hour format)
            TGridItem(
              child: TFormDateTime.timeOnly(
                enabled: true,
                title: 'TFormDateTime.timeOnly',
                initialValue: null,
              ),
            ),

            // dateAndTime: Opens both date and time pickers
            // sequentially First selects date, then selects time
            // Displays as: DD/MM/YYYY HH:MM
            TGridItem(
              child: TFormDateTime.dateAndTime(
                enabled: true,
                title: 'TFormDateTime.dateAndTime',
                initialValue: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// HELPER WIDGET: _TitledSwitch
// ============================================================================
//
// Simple widget that displays a label with a switch control below it
// Used throughout the example to demonstrate boolean properties and methods

class _TitledSwitch extends StatelessWidget {
  final String title;
  final bool value;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool)? onChanged;

  const _TitledSwitch({
    required this.title,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
