import 'package:flutter/material.dart';

/// A wrapper around CircularProgressIndicator to scale it to the same size as
/// an Icon would normally
class TCircularProgressIcon extends StatelessWidget {
  /// The stroke width for the CircularProgressIndicator
  final double? strokeWidth;

  const TCircularProgressIcon({this.strokeWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox.square(
        dimension: Theme.of(context).iconTheme.size ?? kDefaultFontSize,
        child: CircularProgressIndicator(strokeWidth: strokeWidth),
      ),
    );
  }
}
