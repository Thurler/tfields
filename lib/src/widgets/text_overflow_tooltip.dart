import 'package:flutter/material.dart';

/// A [Text] that wraps itself around a [Tooltip] when it overflows the
/// available width in the render tree, making sure ellipsis overflow is used
/// and a tooltip with the whole text is displayed when overflowing
class TTextOverflowTooltip extends StatefulWidget {
  /// The text to be displayed
  final String text;

  /// The optional text style to use
  final TextStyle? style;

  const TTextOverflowTooltip(this.text, {this.style, super.key});

  @override
  State<StatefulWidget> createState() => _TTextOverflowTooltipState();
}

class _TTextOverflowTooltipState extends State<TTextOverflowTooltip>
    with WidgetsBindingObserver {
  final GlobalKey _textKey = GlobalKey();
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Schedule the overflow check after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkOverflow() {
    RenderObject? renderBox = _textKey.currentContext?.findRenderObject();
    if (renderBox == null) {
      return;
    }
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (renderBox as RenderBox).size.width);
    if (textPainter.didExceedMaxLines != _isOverflowing) {
      setState(() {
        _isOverflowing = textPainter.didExceedMaxLines;
      });
    }
  }

  @override
  void didChangeMetrics() => _checkOverflow();

  @override
  Widget build(BuildContext context) {
    Widget text = Text(
      widget.text,
      style: widget.style,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      key: _textKey,
    );
    return _isOverflowing ? Tooltip(message: widget.text, child: text) : text;
  }
}
