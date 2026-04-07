import 'package:flutter/material.dart';

/// An interface that specifies how T widgets will handle standardized icons
abstract class TIconInterface {
  /// The IconData that will be displayed
  IconData get icon;

  /// The base color for widgets using this icon (light mode)
  Color? get colorLight;

  /// The base color for widgets using this icon (dark mode)
  Color? get colorDark;
}

/// An enumeration of pre-made icons that are ready for use for standardized
/// functions like adding, deleting, saving, etc.
enum TPresetIcon implements TIconInterface {
  download(Icons.download, 'Download', null, null),
  upload(Icons.upload, 'Upload', null, null),
  filter(Icons.filter_list, 'Filter', null, null),
  add(Icons.add, 'Add', null, null),
  edit(Icons.edit, 'Edit', null, null),
  close(Icons.close, 'Close', null, null),
  cancel(Icons.clear, 'Cancel', null, null),
  save(Icons.save, 'Save', null, null),
  refresh(Icons.refresh, 'Refresh', null, null),
  delete(Icons.delete_forever, 'Delete', Colors.red, Colors.red);

  @override
  final IconData icon;

  final String text;

  @override
  final Color? colorLight;

  @override
  final Color? colorDark;

  const TPresetIcon(this.icon, this.text, this.colorLight, this.colorDark);
}

/// A concrete implementation of the interface for cases that need customization
class TIcon implements TIconInterface {
  @override
  final IconData icon;

  @override
  final Color? colorLight;

  @override
  final Color? colorDark;

  const TIcon({
    required this.icon,
    Color? colorLight,
    Color? colorDark,
    Color? color,
  }) : colorLight = colorLight ?? color, colorDark = colorDark ?? color;

  const TIcon.splitColor({
    required this.icon,
    this.colorLight,
    this.colorDark,
  });
}
