import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/src/widgets/chip_list.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/form/checkbox.dart';
import 'package:tfields/src/widgets/form/datetime.dart';
import 'package:tfields/src/widgets/form/dropdown.dart';
import 'package:tfields/src/widgets/form/list/dropdown_chip.dart';
import 'package:tfields/src/widgets/form/list/string_chip.dart';
import 'package:tfields/src/widgets/form/number.dart';
import 'package:tfields/src/widgets/form/string.dart';

/// An interface for TForm fields, which for now provides nothing but strictly
/// limit the fields to belong to an enum of fields
abstract interface class TFormField {}

/// A wrapper around an instance of TForm and its key, providing convenience
/// methods to interfact with the state, as well as being a proxy Widget for the
/// form itself
class TFormWrapper extends StatelessWidget {
  /// The form instance
  final TGenericForm form;

  /// The form's key, which allows us to access its state
  final TGenericFormKey _key;

  const TFormWrapper({
    required this.form,
    required TGenericFormKey formKey,
    super.key,
  }) : _key = formKey;

  /// Get the GenericFormKey
  TGenericFormKey get genericKey => _key;

  /// Cast the key to a CheckboxFormKey and return it
  TCheckboxFormKey get checkboxKey => _key as TCheckboxFormKey;

  /// Cast the key to a StringFormKey and return it
  TStringFormKey get stringKey => _key as TStringFormKey;

  /// Cast the key to a IntegerFormKey and return it
  TIntegerFormKey get integerKey => _key as TIntegerFormKey;

  /// Cast the key to a BigIntegerFormKey and return it
  TBigIntegerFormKey get bigIntegerKey => _key as TBigIntegerFormKey;

  /// Cast the key to a DoubleFormKey and return it
  TDoubleFormKey get doubleKey => _key as TDoubleFormKey;

  /// Cast the key to a DateTimeFormKey and return it
  TDateTimeFormKey get dateTimeKey => _key as TDateTimeFormKey;

  /// Cast the key to a DropdownFormKey and return it
  TDropdownFormKey<T> dropdownKey<T>() => _key as TDropdownFormKey<T>;

  /// Cast the key to a StringListChipFormKey and return it
  TStringListChipFormKey get stringListChipKey =>
      _key as TStringListChipFormKey;

  /// Cast the key to a DropdownListChipFormKey and return it
  TDropdownListChipFormKey<T> dropdownListChipKey<T>() =>
      _key as TDropdownListChipFormKey<T>;

  /// Cast the key to a CheckboxFormKey and returns its value
  bool? get checkboxValue => checkboxKey.currentState?.value;

  /// Cast the key to a StringFormKey and return its value
  String get stringValue => stringKey.currentState?.value ?? '';

  /// Cast the key to a IntegerFormKey and return its value
  int? get integerValue => integerKey.currentState?.value;

  /// Cast the key to a BigIntegerFormKey and return its value
  BigInt? get bigIntegerValue => bigIntegerKey.currentState?.value;

  /// Cast the key to a DoubleFormKey and return its value
  double? get doubleValue => doubleKey.currentState?.value;

  /// Cast the key to a DateTimeFormKey and return its value
  DateTime? get dateTimeValue => dateTimeKey.currentState?.value;

  /// Cast the key to a DropdownFormKey and return its value
  T? dropdownValue<T>() => dropdownKey<T>().currentState?.value;

  /// Cast the key to a StringListChipFormKey and return its value
  List<String>? get stringListChipValue =>
      stringListChipKey.currentState?.value;

  /// Cast the key to a DropdownListChipFormKey and return its value
  List<T>? dropdownListChipValue<T>() =>
      dropdownListChipKey<T>().currentState?.value;

  @override
  Widget build(BuildContext context) => form;
}

typedef GroupSetState = void Function(void Function());

/// A collection of Forms that the user can interact with as a group, to avoid
/// having to handle the instances and keys by themselves. Usually used to
/// represent an entity's attributes, and then use the form values to build an
/// instance of that entity.
///
/// In that example, we would build an instance of class Value based on the
/// forms available in the enumeration of Field and the additional data Data
abstract class TFormGroup<Value, Data, Field extends TFormField> {
  /// The internal mapping of Fields to their keys
  final Map<Field, TGenericFormKey> _formKeys = <Field, TGenericFormKey>{};

  /// The internal mapping of Fields to their forms
  final Map<Field, TFormWrapper> _forms = <Field, TFormWrapper>{};

  /// A reference to the caller's setState function, if they are Stateful and
  /// want to update their state whenever the form's state updates
  final GroupSetState? _setState;

  /// Whether this group is enabled or not - will propagate this to the inner
  /// forms so they are all enabled/disabled together
  bool _enabled;

  /// Whether this group is enabled or not - will propagate this to the inner
  /// forms so they are all enabled/disabled together
  bool get enabled => _enabled;
  set enabled(bool newValue) {
    _enabled = newValue;
    for (TGenericFormKey key in _formKeys.values) {
      key.currentState?.enabled = newValue;
    }
  }

  /// Whether validation was checked manually for this group or not
  bool hasRequestedValidation = false;

  TFormGroup({
    required bool enabled,
    required GroupSetState? setState,
  }) : _enabled = enabled, _setState = setState;

  /// The function that makes an entity out of the current forms' states
  Value makeEntity(Data additionalData);

  /// The inner callback for when a form's value changes - responsible for
  /// calling the provided setState
  void Function() get onGroupValueChanged => () => _setState?.call(() {});

  /// Adds a generic form to the group - the user is responsible for making sure
  /// everything has been initialized and bound correctly
  void addGenericForm({
    required Field formName,
    required TGenericFormKey key,
    required TGenericForm form,
  }) {
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(formKey: key, form: form);
  }

  /// Adds a TFormString to the group - this is merely a mirror to the
  /// constructor of that class
  void addStringForm({
    required Field formName,
    required String title,
    required String initialValue,
    String subtitle = '',
    String hintText = '',
    bool isMultiline = false,
    bool readonly = false,
    String Function(String?)? validationCallback,
    ValueChanged<String?>? onValueChanged,
    VoidCallback? submitCallback,
    List<TextInputFormatter> formatters = const <TextInputFormatter>[],
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TStringFormKey key = TStringFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormString(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        isMultiline: isMultiline,
        initialValue: initialValue,
        hintText: hintText,
        formatters: formatters,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        submitCallback: submitCallback,
        validationCallback: validationCallback,
        onValueChanged: (String? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormString.searchBar to the group - this is merely a mirror to
  /// that constructor of the class
  void addSearchBarForm({
    required Field formName,
    required String title,
    required String initialValue,
    String subtitle = '',
    String hintText = '',
    bool readonly = false,
    String Function(String?)? validationCallback,
    ValueChanged<String?>? onValueChanged,
    VoidCallback? submitCallback,
    List<TextInputFormatter> formatters = const <TextInputFormatter>[],
    Widget? decoratorIcon,
    bool? enabledOverride,
  }) {
    TStringFormKey key = TStringFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormString.searchBar(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        hintText: hintText,
        formatters: formatters,
        decoratorIcon: decoratorIcon,
        submitCallback: submitCallback,
        validationCallback: validationCallback,
        onValueChanged: (String? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormStringListChip to the group - this is merely a mirror to
  /// the constructor of that class
  void addStringListChip({
    required Field formName,
    required String title,
    required List<String>? initialValue,
    String subtitle = '',
    bool readonly = false,
    String Function(List<String>?)? validationCallback,
    ValueChanged<List<String>?>? onValueChanged,
    void Function(String)? onValueAdded,
    void Function(String)? onValueDeleted,
    VoidCallback? submitCallback,
    List<TextInputFormatter> formatters = const <TextInputFormatter>[],
    Widget? decoratorIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TStringListChipFormKey key = TStringListChipFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormStringListChip(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        formatters: formatters,
        decoratorIcon: decoratorIcon,
        suffixIcon: suffixIcon,
        submitCallback: submitCallback,
        validationCallback: validationCallback,
        onValueAdded: onValueAdded,
        onValueDeleted: onValueDeleted,
        onValueChanged: (List<String>? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormInteger to the group - this is merely a mirror to the
  /// constructor of that class
  void addIntegerForm({
    required Field formName,
    required String title,
    required int? initialValue,
    String subtitle = '',
    bool readonly = false,
    bool unsigned = true,
    bool snapToMinOnEmpty = false,
    bool snapToMaxWhenOver = false,
    bool commaSeparate = false,
    String Function(int?)? validationCallback,
    ValueChanged<int?>? onValueChanged,
    VoidCallback? submitCallback,
    int? minValue,
    int? maxValue,
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TIntegerFormKey key = TIntegerFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormInteger(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        commaSeparate: commaSeparate,
        unsigned: unsigned,
        snapToMinOnEmpty: snapToMinOnEmpty,
        snapToMaxWhenOver: snapToMaxWhenOver,
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        submitCallback: submitCallback,
        validationCallback: validationCallback,
        onValueChanged: (int? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormBigInteger to the group - this is merely a mirror to the
  /// constructor of that class
  void addBigIntegerForm({
    required Field formName,
    required String title,
    required BigInt? initialValue,
    String subtitle = '',
    bool readonly = false,
    bool unsigned = true,
    bool snapToMinOnEmpty = false,
    bool snapToMaxWhenOver = false,
    bool commaSeparate = false,
    String Function(BigInt?)? validationCallback,
    ValueChanged<BigInt?>? onValueChanged,
    VoidCallback? submitCallback,
    BigInt? minValue,
    BigInt? maxValue,
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TBigIntegerFormKey key = TBigIntegerFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormBigInteger(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        commaSeparate: commaSeparate,
        unsigned: unsigned,
        snapToMinOnEmpty: snapToMinOnEmpty,
        snapToMaxWhenOver: snapToMaxWhenOver,
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        submitCallback: submitCallback,
        validationCallback: validationCallback,
        onValueChanged: (BigInt? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDouble to the group - this is merely a mirror to the
  /// constructor of that class
  void addDoubleForm({
    required Field formName,
    required String title,
    required double? initialValue,
    String subtitle = '',
    bool readonly = false,
    bool unsigned = true,
    bool snapToMinOnEmpty = false,
    bool snapToMaxWhenOver = false,
    bool commaSeparate = false,
    String Function(double?)? validationCallback,
    ValueChanged<double?>? onValueChanged,
    VoidCallback? submitCallback,
    double? minValue,
    double? maxValue,
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TDoubleFormKey key = TDoubleFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDouble(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        commaSeparate: commaSeparate,
        unsigned: unsigned,
        snapToMinOnEmpty: snapToMinOnEmpty,
        snapToMaxWhenOver: snapToMaxWhenOver,
        initialValue: initialValue,
        minValue: minValue,
        maxValue: maxValue,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        submitCallback: submitCallback,
        validationCallback: validationCallback,
        onValueChanged: (double? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDropdown of type V to the group - this is merely a mirror
  /// to the constructor of that class
  void addDropdownForm<V>({
    required Field formName,
    required String title,
    required String hintText,
    required V? initialValue,
    required List<V> options,
    required String Function(V) toDropdownText,
    bool readonly = false,
    TDropdownSortLogic sortLogic = TDropdownSortLogic.text,
    String Function(V?)? validationCallback,
    ValueChanged<V?>? onValueChanged,
    String subtitle = '',
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TDropdownFormKey<V> key = TDropdownFormKey<V>();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDropdown<V>(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        toDropdownText: toDropdownText,
        sortLogic: sortLogic,
        hintText: hintText,
        options: options,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        validationCallback: validationCallback,
        onValueChanged: (V? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDropdown of type V to the group, along with a "other"
  /// option - this is merely a mirror to the constructor of that class
  void addDropdownFormWithOtherOption<V>({
    required Field formName,
    required String title,
    required String hintText,
    required V? initialValue,
    required List<V> options,
    required TForm<V> otherOptionForm,
    required V otherOptionPlaceholder,
    required Axis? otherOptionAxis,
    required String Function(V) toDropdownText,
    bool readonly = false,
    TDropdownSortLogic sortLogic = TDropdownSortLogic.text,
    String Function(V?)? validationCallback,
    ValueChanged<V?>? onValueChanged,
    String otherOptionText = '',
    String subtitle = '',
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TDropdownFormKey<V> key = TDropdownFormKey<V>();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDropdown<V>.withOtherOption(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        toDropdownText: toDropdownText,
        sortLogic: sortLogic,
        hintText: hintText,
        options: options,
        otherOptionForm: otherOptionForm,
        otherOptionText: otherOptionText,
        otherOptionAxis: otherOptionAxis,
        otherOptionPlaceholder: otherOptionPlaceholder,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        validationCallback: validationCallback,
        onValueChanged: (V? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDropdownListChip of type V to the group - this is merely a
  /// mirror to the constructor of that class
  void addDropdownListChipForm<V>({
    required Field formName,
    required String selectedValuesText,
    required String noElementText,
    required String title,
    required String hintText,
    required List<V>? initialValue,
    required List<V> options,
    required String Function(V) toDropdownText,
    bool readonly = false,
    TDropdownSortLogic sortLogic = TDropdownSortLogic.text,
    TChipSortLogic chipSortLogic = TChipSortLogic.text,
    String Function(List<V>?)? validationCallback,
    void Function(V)? onValueAdded,
    void Function(V)? onValueDeleted,
    ValueChanged<List<V>?>? onValueChanged,
    String subtitle = '',
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TDropdownListChipFormKey<V> key = TDropdownListChipFormKey<V>();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDropdownListChip<V>(
        key: key,
        enabled: enabledOverride ?? enabled,
        selectedValuesText: selectedValuesText,
        noElementText: noElementText,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        toDropdownText: toDropdownText,
        sortLogic: sortLogic,
        chipSortLogic: chipSortLogic,
        hintText: hintText,
        options: options,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        validationCallback: validationCallback,
        onValueAdded: onValueAdded,
        onValueDeleted: onValueDeleted,
        onValueChanged: (List<V>? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDropdownListChip of type V to the group, along with an
  /// "other" option - this is merely a mirror to the constructor of that class
  void addDropdownListChipFormWithOtherOption<V>({
    required Field formName,
    required String selectedValuesText,
    required String noElementText,
    required String title,
    required String hintText,
    required List<V>? initialValue,
    required List<V> options,
    required TForm<V> otherOptionForm,
    required V otherOptionPlaceholder,
    required Axis? otherOptionAxis,
    required String Function(V) toDropdownText,
    bool readonly = false,
    TDropdownSortLogic sortLogic = TDropdownSortLogic.text,
    TChipSortLogic chipSortLogic = TChipSortLogic.text,
    String Function(List<V>?)? validationCallback,
    void Function(V)? onValueAdded,
    void Function(V)? onValueDeleted,
    ValueChanged<List<V>?>? onValueChanged,
    String subtitle = '',
    String otherOptionText = '',
    Widget? decoratorIcon,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TDropdownListChipFormKey<V> key = TDropdownListChipFormKey<V>();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDropdownListChip<V>.withOtherOption(
        key: key,
        enabled: enabledOverride ?? enabled,
        selectedValuesText: selectedValuesText,
        noElementText: noElementText,
        otherOptionText: otherOptionText,
        otherOptionForm: otherOptionForm,
        otherOptionPlaceholder: otherOptionPlaceholder,
        otherOptionAxis: otherOptionAxis,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        toDropdownText: toDropdownText,
        sortLogic: sortLogic,
        chipSortLogic: chipSortLogic,
        hintText: hintText,
        options: options,
        decoratorIcon: decoratorIcon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        validationCallback: validationCallback,
        onValueAdded: onValueAdded,
        onValueDeleted: onValueDeleted,
        onValueChanged: (List<V>? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormCheckbox to the group - this is merely a mirror to the
  /// constructor of that class
  void addCheckboxForm({
    required Field formName,
    required String text,
    required String title,
    required bool initialValue,
    String subtitle = '',
    bool readonly = false,
    // ignore: avoid_positional_boolean_parameters
    String Function(bool?)? validationCallback,
    ValueChanged<bool?>? onValueChanged,
    Widget? decoratorIcon,
    Widget? suffixIcon,
    bool? enabledOverride,
  }) {
    TCheckboxFormKey key = TCheckboxFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormCheckbox(
        key: key,
        enabled: enabledOverride ?? enabled,
        text: text,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        decoratorIcon: decoratorIcon,
        suffixIcon: suffixIcon,
        validationCallback: validationCallback,
        onValueChanged: (bool? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDateTime to the group, using the date only constructor -
  /// this is merely a mirror to the constructor of that class
  void addDateOnlyForm({
    required Field formName,
    required String title,
    required DateTime? initialValue,
    bool readonly = false,
    String subtitle = '',
    Widget? decoratorIcon,
    ValueChanged<DateTime?>? onValueChanged,
    String Function(DateTime?)? validationCallback,
    bool? enabledOverride,
  }) {
    TDateTimeFormKey key = TDateTimeFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDateTime.dateOnly(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        decoratorIcon: decoratorIcon,
        validationCallback: validationCallback,
        onValueChanged: (DateTime? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDateTime to the group, using the time only constructor -
  /// this is merely a mirror to the constructor of that class
  void addTimeOnlyForm({
    required Field formName,
    required String title,
    required DateTime? initialValue,
    bool readonly = false,
    String subtitle = '',
    Widget? decoratorIcon,
    ValueChanged<DateTime?>? onValueChanged,
    String Function(DateTime?)? validationCallback,
    bool? enabledOverride,
  }) {
    TDateTimeFormKey key = TDateTimeFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDateTime.timeOnly(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        decoratorIcon: decoratorIcon,
        validationCallback: validationCallback,
        onValueChanged: (DateTime? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// Adds a TFormDateTime to the group, using the date and time constructor
  /// - this is merely a mirror to the constructor of that class
  void addDateAndTimeForm({
    required Field formName,
    required String title,
    required DateTime? initialValue,
    bool readonly = false,
    String subtitle = '',
    Widget? decoratorIcon,
    ValueChanged<DateTime?>? onValueChanged,
    String Function(DateTime?)? validationCallback,
    bool? enabledOverride,
  }) {
    TDateTimeFormKey key = TDateTimeFormKey();
    _formKeys[formName] = key;
    _forms[formName] = TFormWrapper(
      formKey: key,
      form: TFormDateTime.dateAndTime(
        key: key,
        enabled: enabledOverride ?? enabled,
        title: title,
        subtitle: subtitle,
        readonly: readonly,
        initialValue: initialValue,
        decoratorIcon: decoratorIcon,
        validationCallback: validationCallback,
        onValueChanged: (DateTime? v) {
          onValueChanged?.call(v);
          onGroupValueChanged();
        },
      ),
    );
  }

  /// A logical OR for each form's individual hasChanges flag
  bool get hasChanges => _formKeys.values.any(
    (TGenericFormKey key) => key.currentState?.hasChanges ?? false,
  );

  /// A logical OR for each form's individual hasErrors flag
  bool get hasErrors => _formKeys.values.any(
    (TGenericFormKey key) => key.currentState?.hasErrors ?? false,
  );

  /// Resets all form's initial values, effectively saving the new values
  void saveValues() {
    for (TGenericFormKey key in _formKeys.values) {
      key.currentState?.saveValue();
    }
  }

  /// Forces a validation refresh on all forms, returns if form is valid
  bool validate() {
    hasRequestedValidation = true;
    for (TGenericFormKey key in _formKeys.values) {
      if (key is TGroupFormKey) {
        key.currentState?.manualValidate();
      } else {
        key.currentState?.validate();
      }
    }
    return !hasErrors;
  }

  TFormWrapper operator [](Field formName) => _forms[formName]!;
}

/// A visual representation of an TFormGroup
abstract class TFormGroupWidget<
        T extends TFormGroup<dynamic, dynamic, TFormField>>
    extends StatelessWidget {
  /// The form to be rendered
  final T form;

  /// Whether the submit button should be rendered
  final bool showSubmit;

  /// Whether the information is being saved or not
  final bool saving;

  /// The callback for the submit button
  final void Function()? onSubmit;

  const TFormGroupWidget({
    required this.form,
    required this.saving,
    this.onSubmit,
    super.key,
  }) : showSubmit = true;

  const TFormGroupWidget.noSubmit({
    required this.form,
    super.key,
  }) : onSubmit = null, showSubmit = false, saving = false;
}

typedef TFormCompatibleGroup<Value> = TFormGroup<Value, Object?, TFormField>;

typedef TFormCompatibleGroupBuilder<Value> = TFormCompatibleGroup<Value>
    Function({
  required bool enabled,
  required GroupSetState? setState,
  Value? initialData,
});

typedef TFormCompatibleGroupWidget<Value>
    = TFormGroupWidget<TFormCompatibleGroup<Value>>;

typedef TFormCompatibleGroupWidgetBuilder<Value>
    = TFormCompatibleGroupWidget<Value> Function(
  TFormCompatibleGroup<Value> form,
);

/// A key type for the standalone form that encapsulates the Group when it's
/// being handled as a regular TForm
typedef TGroupFormKey<Value> = GlobalKey<TGroupFormState<Value>>;

/// A version of this group that acts as its own standalone form, for when we
/// need it to act as a single entity in a another form, for example
class TGroupForm<Value> extends TForm<Value> {
  /// The group instance
  final TFormCompatibleGroup<Value> group;

  /// A builder that returns the Widget associated with the Group
  final TFormCompatibleGroupWidgetBuilder<Value> groupWidgetBuilder;

  TGroupForm({
    required TFormCompatibleGroupBuilder<Value> groupBuilder,
    required GroupSetState? setState,
    required this.groupWidgetBuilder,
    required super.enabled,
    required super.initialValue,
    super.key,
  }) :
    group = groupBuilder(
      enabled: enabled,
      setState: setState,
      initialData: initialValue,
    ),
    super(title: '');

  @override
  TGroupFormState<Value> createState() => TGroupFormState<Value>();
}

/// And the state associated with the GroupForm above
class TGroupFormState<Value> extends TFormState<Value, TGroupForm<Value>> {
  /// A copy of validation function that must be manually called
  void manualValidate() => widget.group.validate();

  @override
  set enabled(bool newValue) {
    super.enabled = newValue;
    widget.group.enabled = newValue;
  }

  @override
  set readonly(bool newValue) {
    super.readonly = newValue;
    widget.group.enabled = newValue;
  }

  @override
  bool get hasChanges => widget.group.hasChanges;

  @override
  bool get hasErrors => widget.group.hasErrors;

  @override
  Value? get value {
    try {
      return widget.group.makeEntity(null);
    } catch (err) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => widget.groupWidgetBuilder(widget.group);
}
