import 'package:flutter/material.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/discardable_changes.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/dropdown.dart';
import 'package:tfields/widgets/form/switch.dart';
import 'package:tfields/widgets/rounded_border.dart';

class FormShowcase extends StatefulWidget {
  const FormShowcase({super.key});

  @override
  State<FormShowcase> createState() => FormShowcaseState();
}

class FormShowcaseState extends State<FormShowcase>
    with
        Loggable,
        AlertHandler<FormShowcase>,
        DiscardableChanges<FormShowcase> {
  @override
  bool get hasChanges => false;

  @override
  Future<void> saveChanges() async {}

  String _switchFormValidation(bool value) =>
      (value && _dropdownFormKey.currentState?.value == 'Option1')
    ? 'TFormDropdown option 1 and TFormSwitch true are incompatible'
    : '';

  String _dropdownFormValidation(String? value) =>
      (value == 'Option1' && (_switchFormKey.currentState?.value ?? false))
    ? 'TFormDropdown option 1 and TFormSwitch true are incompatible'
    : '';

  String _dropdownExtraValidation(String? value) {
    if (value == 'Other') {
      String? userInput = _dropdownExtraFormKey.currentState?.otherOptionValue;
      if (userInput == null || userInput.isEmpty) {
        return 'Please fill in the "Other" value';
      }
      if (RegExp(r'\d+').hasMatch(userInput)) {
        return 'The "Other" value must not have numbers';
      }
    }
    return '';
  }

  void _triggerSwitchAndDropdownValidation() {
    _switchFormKey.currentState?.validate();
    _dropdownFormKey.currentState?.validate();
    setState(() {});
  }

  late TFormSwitch _switchForm;
  final SwitchFormKey _switchFormKey = SwitchFormKey();

  late TFormDropdown _dropdownForm;
  final DropdownFormKey _dropdownFormKey = DropdownFormKey();

  late TFormDropdown _dropdownExtraForm;
  final DropdownFormKey _dropdownExtraFormKey = DropdownFormKey();

  @override
  void initState() {
    super.initState();
    _switchForm = TFormSwitch(
      enabled: true,
      title: 'TFormSwitch',
      subtitle: "Because it's just a boolean, validating its value is "
          'pointless by itself, should be combined with some other condition',
      onText: 'Value is currently TRUE',
      offText: 'Value is currently FALSE',
      initialValue: true,
      validationCallback: _switchFormValidation,
      onValueChanged: (_) => _triggerSwitchAndDropdownValidation(),
      key: _switchFormKey,
    );
    _dropdownForm = TFormDropdown(
      enabled: true,
      title: 'TFormDropdown',
      subtitle: 'Because the options are fixed, validating its value is '
          'pointless by itself, should be combined with some other condition',
      hintText: 'Pick something!',
      initialValue: 'Option1',
      options: const <String>['Option1', 'Option2'],
      validationCallback: _dropdownFormValidation,
      onValueChanged: (_) => _triggerSwitchAndDropdownValidation(),
      key: _dropdownFormKey,
    );
    _dropdownExtraForm = TFormDropdown.withOtherOption(
      enabled: true,
      title: 'TFormDropdown.withOtherOption',
      subtitle: 'An extra "other" option is provided, which will prompt the '
          'user to type in a value not present in the dropdown. In this '
          'example, it also cannot contain numbers',
      hintText: 'Pick something!',
      initialValue: '',
      // ignore: prefer_const_literals_to_create_immutables
      regularOptions: <String>['Regular option'],
      otherOptionText: 'Other',
      otherOptionHintText: 'Other value...',
      validationCallback: _dropdownExtraValidation,
      onValueChanged: (_) => setState(() {}),
      key: _dropdownExtraFormKey,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _triggerSwitchAndDropdownValidation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: CommonScaffold(
        title: 'TFields Demo - Form Showcase',
        floatingActionButton: saveButton,
        children: <Widget>[
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
        ],
      ),
    );
  }
}
