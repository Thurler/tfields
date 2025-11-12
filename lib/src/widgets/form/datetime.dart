import 'package:flutter/material.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/form/base.dart';
import 'package:tfields/src/widgets/icons.dart';
import 'package:tfields/src/widgets/input_decoration.dart';

typedef TDateTimeFormKey = GlobalKey<TFormDateTimeState>;

/// A specialization of the generic Form that allows the user to input a date
/// and/or a time. It provides three different factories for the possible
/// combinations of date/time that the user is expected to provide
abstract class TFormDateTime extends TForm<DateTime> {
  const TFormDateTime({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.onValueChanged,
    super.decoratorIcon,
    super.validationCallback,
    super.key,
  });

  /// Will prompt the user for only a date, forcing the time to be zero
  factory TFormDateTime.dateOnly({
    required bool enabled,
    required String title,
    required DateTime? initialValue,
    bool readonly = false,
    String subtitle = '',
    String errorMessage = '',
    ValueChanged<DateTime?>? onValueChanged,
    Widget? decoratorIcon,
    String Function(DateTime?)? validationCallback,
    TFormKey<DateTime>? key,
  }) {
    return _TFormDateOnly(
      enabled: enabled,
      title: title,
      initialValue: initialValue,
      readonly: readonly,
      subtitle: subtitle,
      errorMessage: errorMessage,
      onValueChanged: onValueChanged,
      decoratorIcon: decoratorIcon,
      validationCallback: validationCallback,
      key: key,
    );
  }

  /// Will prompt the user for only a time, forcing the date to the current day
  factory TFormDateTime.timeOnly({
    required bool enabled,
    required String title,
    required DateTime? initialValue,
    bool readonly = false,
    String subtitle = '',
    String errorMessage = '',
    ValueChanged<DateTime?>? onValueChanged,
    Widget? decoratorIcon,
    String Function(DateTime?)? validationCallback,
    TFormKey<DateTime>? key,
  }) {
    return _TFormTimeOnly(
      enabled: enabled,
      title: title,
      initialValue: initialValue,
      readonly: readonly,
      subtitle: subtitle,
      errorMessage: errorMessage,
      onValueChanged: onValueChanged,
      decoratorIcon: decoratorIcon,
      validationCallback: validationCallback,
      key: key,
    );
  }

  /// Will prompt the user for both a date and a time, combining them into a
  /// single DateTime instance
  factory TFormDateTime.dateAndTime({
    required bool enabled,
    required String title,
    required DateTime? initialValue,
    bool readonly = false,
    String subtitle = '',
    String errorMessage = '',
    ValueChanged<DateTime?>? onValueChanged,
    Widget? decoratorIcon,
    String Function(DateTime?)? validationCallback,
    TFormKey<DateTime>? key,
  }) {
    return _TFormDateAndTime(
      enabled: enabled,
      title: title,
      initialValue: initialValue,
      readonly: readonly,
      subtitle: subtitle,
      errorMessage: errorMessage,
      onValueChanged: onValueChanged,
      decoratorIcon: decoratorIcon,
      validationCallback: validationCallback,
      key: key,
    );
  }

  @override
  TFormDateTimeState createState() => TFormDateTimeState();

  /// The icon used as a clickable prefix in the form
  IconData get icon;

  /// The hint that is displayed when no date or time is chosen
  String get hintText;

  /// A converter for prettyfying the selected date/time into a readable string.
  /// For now is not aware of user locale, so will always display DD/MM/YY HH:MM
  String valueToString(DateTime value);

  /// The function that will actually show the user prompt for the date/time
  Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialValue,
  });
}

/// A specialization of TFormDateTime that only prompts for a date
class _TFormDateOnly extends TFormDateTime {
  const _TFormDateOnly({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.onValueChanged,
    super.decoratorIcon,
    super.validationCallback,
    super.key,
  });

  static String prettyDate(DateTime value) =>
      '${value.toLocal().day}/${value.toLocal().month}/${value.toLocal().year}';

  static Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialValue,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialValue ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
  }

  @override
  String valueToString(DateTime value) => prettyDate(value);

  @override
  Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialValue,
  }) {
    return pickDate(context: context, initialValue: initialValue);
  }

  @override
  String get hintText => 'Select a date';

  @override
  IconData get icon => Icons.calendar_month;
}

/// A specialization of TFormDateTime that only prompts for a time
class _TFormTimeOnly extends TFormDateTime {
  const _TFormTimeOnly({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.onValueChanged,
    super.decoratorIcon,
    super.validationCallback,
    super.key,
  });

  static String prettyTime(DateTime value) =>
      '${value.toLocal().hour.toString().padLeft(2, '0')}:'
      '${value.toLocal().minute.toString().padLeft(2, '0')}';

  @override
  String valueToString(DateTime value) => prettyTime(value);

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    DateTime? initialValue,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialValue != null
        ? TimeOfDay(hour: initialValue.hour, minute: initialValue.minute)
        : TimeOfDay.now(),
    );
  }

  @override
  Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialValue,
  }) async {
    TimeOfDay? time =
        await pickTime(context: context, initialValue: initialValue);
    DateTime now = DateTime.now();
    return time != null
      ? DateTime(now.year, now.month, now.day, time.hour, time.minute)
      : null;
  }

  @override
  String get hintText => 'Select the hour and minute';

  @override
  IconData get icon => Icons.watch_later;
}

/// A specialization of TFormDateTime that prompts for both a date and a
/// time
class _TFormDateAndTime extends TFormDateTime {
  const _TFormDateAndTime({
    required super.enabled,
    required super.title,
    required super.initialValue,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.onValueChanged,
    super.decoratorIcon,
    super.validationCallback,
    super.key,
  });

  @override
  String valueToString(DateTime value) => '${_TFormDateOnly.prettyDate(value)} '
      '${_TFormTimeOnly.prettyTime(value)}';

  @override
  Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialValue,
  }) async {
    DateTime? date = await _TFormDateOnly.pickDate(
      context: context,
      initialValue: initialValue,
    );
    if (date == null || !context.mounted) {
      return null;
    }
    TimeOfDay? time = await _TFormTimeOnly.pickTime(
      context: context,
      initialValue: initialValue,
    );
    if (time == null) {
      return null;
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  String get hintText => 'Select a date and time';

  @override
  IconData get icon => Icons.calendar_month;
}

/// The associated state with an TFormDateTime
class TFormDateTimeState extends TFormState<DateTime, TFormDateTime> {
  /// The controller that will store the string representation of the selected
  /// date and time
  final TextEditingController _controller = TextEditingController();

  @override
  set value(DateTime? newValue) {
    super.value = newValue;
    // We override the setter to make sure value changes propagate to the text
    // controller that is displayed
    setState(() {
      _controller.text = stringValue;
    });
  }

  /// Converts the current value to a prettyfied string before returning it
  String get stringValue => value != null ? widget.valueToString(value!) : '';

  /// Prompts the user for a date/time and updates the value accordingly
  Future<void> _pickDateTime() async {
    DateTime? newDate =
        await widget.pickDateTime(context: context, initialValue: value);
    if (newDate != null) {
      value = newDate;
    }
  }

  /// Removes the currently selected value
  void _removeValue() => value = null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: _controller,
      readOnly: true,
      decoration: TInputDecoration(
        enabled: enabled,
        labelText: title,
        helperText: subtitle,
        hintText: widget.hintText,
        icon: widget.decoratorIcon,
        prefixIcon: TButton.iconOnly(
          icon: TIcon(icon: widget.icon),
          text: widget.hintText,
          // Only allow changing the value when enabled and write allowed
          onPressed: enabled && !readonly ? _pickDateTime : null,
        ),
        suffixIcon: TButton.iconOnly.close(
          forceDefaultIconColor: true,
          textOverride: 'Clear value',
          // Only allow changing the value when enabled and write allowed
          onPressed: enabled && !readonly ? _removeValue : null,
        ),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (_) => errorMessage.isNotEmpty ? errorMessage : null,
    );
  }
}
