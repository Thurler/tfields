import 'package:flutter/material.dart';
import 'package:tfields/extensions/iterable.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/expansion_tile.dart';
import 'package:tfields/widgets/form/group.dart';

/// An interface for T Form subgroups, a collection of fields that will be
/// displayed together
abstract interface class TFormSubgroup<Field extends TFormField>
    implements Enum {
  /// The title for the expansion tile that groups the fields together
  String get title;

  /// Whether the expansion tile should be initially expanded or not
  bool get initiallyExpanded;

  /// The fields that will be rendered in this subgroup
  List<Field> get fields;
}

typedef TGenericSubgroup = TFormSubgroup<TFormField>;

/// A mixin that adds subgroup functionality to an TFormGroup
mixin TSubgroups<Value, Data, Field extends TFormField,
    Subgroup extends TFormSubgroup<Field>> on TFormGroup<Value, Data, Field> {
  /// The subgroup division that will be applied to the fields - if null, no
  /// subgroup division occurs
  List<Subgroup> get subgroups;

  /// Whether a subgroup has changes or not
  bool subgroupHasChanges(Subgroup subgroup) => subgroup.fields.any(
    (Field field) => this[field].genericKey.currentState?.hasChanges ?? false,
  );

  /// Whether a subgroup has validation errors or not
  bool subgroupHasErrors(Subgroup subgroup) => subgroup.fields.any(
    (Field field) => this[field].genericKey.currentState?.hasErrors ?? false,
  );
}

/// This is the visual representation of the subgroups, rendered as a column of
/// TExpansionTiles with an optional submit button. The implementation of
/// how to render each subgroup is left for the derived class. The overall
/// representation of the subgroups can also be customized by overriding the
/// entire build method
abstract class TFormSubgroupListWidget<Subgroup extends TGenericSubgroup,
        T extends TSubgroups<dynamic, dynamic, TFormField, Subgroup>>
    extends TFormGroupWidget<T> {
  /// A custom validation text to display when a subgroup has validation errors
  final String validationErrorText;

  /// The text to display on the submit button when the submit operation is
  /// ongoing
  final String savingText;

  /// The text to display on the submit button
  final String saveText;

  const TFormSubgroupListWidget({
    required super.form,
    required super.saving,
    required this.savingText,
    required this.saveText,
    this.validationErrorText = '',
    super.onSubmit,
    super.key,
  });

  /// A version of this class that doesn't render a submit button
  const TFormSubgroupListWidget.noSubmit({
    required super.form,
    this.validationErrorText = '',
    super.key,
  }) : savingText = '', saveText = '', super.noSubmit();

  /// The function responsible for providing the content of each
  /// TExpansionTile - the subgroup and build context are both provided
  List<Widget> buildSubgroup(Subgroup subgroup, BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // First we draw each subgroup
        ...form.subgroups.map<Widget>(
          (Subgroup subgroup) => TExpansionTile.withValidationErrorChip(
            // These properties are read straight from the subgroup
            title: subgroup.title,
            initiallyExpanded: subgroup.initiallyExpanded,
            // We fallback to a default string if no custom text is provided
            validationErrorText: form.subgroupHasErrors(subgroup)
              ? validationErrorText.isNotEmpty
                ? validationErrorText
                : 'Has errors'
              : '',
            children: buildSubgroup(subgroup, context),
          ),
        ),
        // And then the optional submit button
        if (showSubmit)
          TButton.elevated.formSubmit(
            saving: saving,
            savingText: savingText,
            saveText: saveText,
            onSubmit: onSubmit,
          ),
      ].separateWith(const SizedBox(height: 20)),
    );
  }
}
