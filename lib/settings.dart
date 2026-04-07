/// The framework for storing and accessing app settings in a standardized way
///
/// Applications sometimes require user customization that is stored locally,
/// and the software needs to interact with this external source of data. This
/// library provides a strict way to read/write to that external source, as well
/// as standardize how Widgets and other classes should interact with the state
/// of those settings
library settings;

export 'src/mixins/settings.dart';
export 'src/settings.dart';
export 'src/theme_provider.dart' show TSettingsThemeProvider;
export 'src/views/settings.dart';
export 'src/widgets/form/group/common_settings.dart';
