import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/src/extensions/iterable.dart';
import 'package:tfields/src/mixins/icon_updateable_form.dart';
import 'package:tfields/src/widgets/button.dart';
import 'package:tfields/src/widgets/form/list/list.dart';
import 'package:tfields/src/widgets/input_decoration.dart';

typedef TStringListChipFormKey = GlobalKey<TFormStringListChipState>;

/// A specialization of the generic List Form that allows the user to input a
/// series of Strings, and displays them as chips next to the input
class TFormStringListChip extends TFormList<String> {
  /// The formatters that will be applied to the TextEditingController
  final List<TextInputFormatter> formatters;

  /// A callback that will be called whenever the user hits the "Enter" key with
  /// no text inputted
  final void Function()? submitCallback;

  const TFormStringListChip({
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.formatters = const <TextInputFormatter>[],
    this.submitCallback,
    super.subtitle = '',
    super.errorMessage = '',
    super.onValueAdded,
    super.onValueDeleted,
    super.readonly,
    super.suffixIcon,
    super.decoratorIcon,
    super.validationCallback,
    super.onValueChanged,
    super.saveWithErrorOptions,
    super.key,
  });

  @override
  TFormStringListChipState createState() => TFormStringListChipState();
}

class TFormStringListChipState
    extends TFormListState<String, TFormStringListChip>
    with
        DecoratorIconUpdateableForm<List<String>, TFormStringListChip>,
        SuffixIconUpdateableForm<List<String>, TFormStringListChip> {
  /// The controller that the user will interact with
  final TextEditingController _controller = TextEditingController();

  /// The scroll controller for the chips and text input
  final ScrollController _scrollController = ScrollController();

  /// The focus node associated with the text form
  late final FocusNode _textFormFocus;

  /// The text that has currently been input, but not submitted as a chip
  String get inputText => _controller.text;

  /// Handle the submit feedback of the user hitting "enter" on the keyboard,
  /// which should either add a new chip or call the widget's submit callback
  void _handleSubmit({bool forced = false}) {
    // If no text has been input, then we assume this is a form submit
    // If this action was forced, ignore this check to avoid recursive calls
    if (_controller.text.isEmpty && !forced) {
      return widget.submitCallback?.call();
    }
    // Otherwise, we add the currently typed text as a new chip
    if (_controller.text.isNotEmpty) {
      addElement(_controller.text);
    }
    // And then reset the controller text, so the user can type a new string
    _controller.text = '';
  }

  /// Captures keyboard events to check for backspace presses
  KeyEventResult _captureKeyEvent(KeyEvent event) {
    if (
      event is KeyDownEvent &&
      event.logicalKey == LogicalKeyboardKey.backspace &&
      _controller.text.isEmpty &&
      (value?.isNotEmpty ?? false)
    ) {
      deleteElement(value!.length - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Calls a submit handling forcefully, which bypasses the empty controller
  /// check to call submit
  void forceSubmit() => _handleSubmit(forced: true);

  /// Whether the form has chips submitted or not
  bool get hasChips => value?.isNotEmpty ?? false;

  /// Whether the scrollbar is currently visible or not
  bool get _scrollIsVisible =>
      _scrollController.hasClients &&
      _scrollController.position.maxScrollExtent > 0;

  @override
  void addElement(String newValue) {
    // This will make sure the scrollbar height is auto-adjusted after insertion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.addElement(newValue);
  }

  @override
  void deleteElement(int index) {
    // This will make sure the scrollbar height is auto-adjusted after deletion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.deleteElement(index);
  }

  @override
  void initState() {
    super.initState();
    _textFormFocus = FocusNode(
      onKeyEvent: (_, KeyEvent event) => _captureKeyEvent(event),
    );
    _textFormFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textFormFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We handle the decoration manually to set up the horizontal scroll
    return InputDecorator(
      decoration: TInputDecoration(
        enabled: enabled,
        isDense: true,
        labelText: title,
        helperText: subtitle,
        errorText: errorMessage.isNotEmpty ? errorMessage : null,
        icon: decoratorIcon,
        suffixIcon: suffixIcon,
      ),
      isEmpty:
          !hasChips && _controller.text.isEmpty && !_textFormFocus.hasFocus,
      child: GestureDetector(
        // Whenever we clip inside the decorator, send focus to text form
        onTap: () => setState(_textFormFocus.requestFocus),
        child: MouseRegion(
          // Make sure we change cursor type too
          cursor: SystemMouseCursors.text,
          // Horizontal scrolls needs a manual scrollbar
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: _scrollIsVisible
                ? const EdgeInsets.fromLTRB(0, 5, 0, 15)
                : const EdgeInsets.symmetric(vertical: 5),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  // Draw the chips for the current list of values
                  if (hasChips)
                    ...value!.indexed.map(
                      ((int, String) data) => Chip(
                        label: SelectableText(data.$2),
                        // If we set the callback on the "onDeleted" instead of
                        // the button's "onPressed", there will be no cursor
                        // change
                        onDeleted: () {},
                        deleteIcon: TButton.iconOnly.close(
                          onPressed: enabled && !readonly
                            ? () => deleteElement(data.$1)
                            : null,
                          textOverride: 'Remove',
                        ),
                      ),
                    ),
                  // And then the actual text form, constrained to at least a
                  // small width
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 200),
                      child: TextFormField(
                        focusNode: _textFormFocus,
                        decoration: const InputDecoration(
                          // Avoids a border inside the current decorator
                          border: InputBorder.none,
                          // Avoids extra padding inside the current decorator
                          isDense: true,
                        ),
                        enabled: enabled,
                        controller: _controller,
                        inputFormatters: widget.formatters,
                        onFieldSubmitted: enabled && !readonly
                          ? (_) => _handleSubmit()
                          : null,
                        readOnly: readonly,
                        textInputAction: TextInputAction.none,
                      ),
                    ),
                  ),
                ].separateWith(const SizedBox(width: 10)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
