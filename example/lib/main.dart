import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfields/extensions/datetime.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/dialog_displayer.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/mixins/settings.dart';
import 'package:tfields/mixins/time_tracker.dart';
import 'package:tfields/mixins/update_checker.dart';
import 'package:tfields/theme_provider.dart';
import 'package:tfields/update_checker.dart';
import 'package:tfields/widgets/appbar_button.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/clickable.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/form/dropdown.dart';
import 'package:tfields/widgets/form/string.dart';
import 'package:tfields/widgets/grid/item.dart';
import 'package:tfields/widgets/grid/row.dart';
import 'package:tfields/widgets/grid/size.dart';
import 'package:tfields/widgets/icons.dart';
import 'package:tfields/widgets/rounded_border.dart';
import 'package:tfields/widgets/switch.dart';
import 'package:tfields/widgets/title_divider.dart';
import 'package:tfields/widgets/update_status.dart';
import 'package:tfields_example/custom_settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // If settings file doesn't exist, create one from defaults
  File settingsFile = File('./settings.json');
  try {
    if (!settingsFile.existsSync()) {
      CustomSettings settings = CustomSettings.fromDefault();
      settingsFile.writeAsStringSync('${settings.toJson()}\n');
    }
  } catch (e) {
    // Failed to create a default settings file, keep going as is
  }
  // We're using a ThemedApp here to quickly add functionality to toggle between
  // light and dark modes - we provide the seed color and a theme builder. This
  // builder is required since we want to save the current mode to the settings,
  // therefore we'll need the CustomSettingsThemeProvider with our settings
  // overrides and additions
  runApp(
    TThemedApp(
      themeBuilder: (Color color, _) => CustomSettingsThemeProvider(color),
      title: 'TFields Demo',
      seedColor: Colors.green,
      home: const MainWidget(),
    ),
  );
}

/// Extend the basic UpdateCheck with the latest github releases endpoint
class MainUpdateCheck extends TUpdateCheck {
  @override
  String get githubEndpoint =>
      'https://api.github.com/repos/thurler/thlaby2-save-editor/releases/latest';
}

class MainWidget extends StatefulWidget {
  // This could be read from anywhere, just putting it here for simplicity
  static const String version = '1.0.0';

  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainState();
}

class MainState extends State<MainWidget>
    with
        TLoggable, // This state can write to the logs
        TSettingsJsonReader<CustomSettings>, // This state can read the settings
        CustomSettingsDeserializer, // Needed to read the app-specific settings
        TDialogDisplayer<MainWidget>, // This state can show dialogs
        TTimeTracker<MainWidget>, // This state can keep track of elapsed time
        TUpdateChecker<MainUpdateCheck> // This state will check for updates
{
  /// Trigger the update check
  Future<void> _callUpdateCheck() async {
    // A small delay so you can see the in-progress loading widget
    await Future<void>.delayed(const Duration(seconds: 3));
    // Simply call this and the magic happens
    await checkForUpdates(MainWidget.version);
  }

  /// Simply redraw the screen when the update checking finishes
  @override
  void updateCheckCallback() => setState(() {});

  // Make sure we use our concrete update checker
  @override
  MainUpdateCheck updateChecker = MainUpdateCheck();

  /// Navigate away to the settings widget
  Future<void> _navigateToSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CustomSettingsWidget(title: 'Demo settings'),
      ),
    );
    // After we pop from it, make sure we reload the settings
    readSettings();
    setState(() {
      _selectedLogLevelTest = settings.logLevel;
    });
  }

  /// Navigate away to the form showcase widget
  Future<void> _navigateToFormShowcase() async {
    //await Navigator.of(context).push(
    //  MaterialPageRoute<void>(
    //    builder: (_) => const FormShowcase(),
    //  ),
    //);
  }

  /// Navigate away to the grid row showcase widget
  Future<void> _navigateToGridRowShowcase() async {}

  /// Keep track of the switch's current state
  bool _currentSwitchValue = true;

  /// Simple callback to update switch value
  void _toggleSwitch({required bool newValue}) => setState(() {
    _currentSwitchValue = newValue;
  });

  /// The date the reset button was last pressed
  DateTime? _lastReset;

  /// Simple text editing controller for log test
  final TStringFormKey _logTestKey = TStringFormKey();

  /// Simple dropdown option tracker for log test
  TLogLevel _selectedLogLevelTest = TLogLevel.info;

  @override
  void initState() {
    super.initState();
    // Calling readSettings on initState is MANDATORY for SettingsReader, so
    // that we guarantee the late settings variable is initialized for all
    // logic
    readSettings();
    // After loading the settings, we can confidently call on the settings
    // variable, which will be loaded with the user's settings
    _selectedLogLevelTest = settings.logLevel;
    // Asynchronous calls in initState should either make sure they're done
    // after the first frame is rendered (like this) or make sure they take
    // long enough to not call setState before the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Calling start timer makes the state begin keeping track of the elapsed
      // seconds, updating itself every second with the new value
      startTimer();
      await _callUpdateCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The CommonScaffold standardizes the way widgets are presented to the
    // user, while conveniently wrapping the children in a ListView for easy
    // scrolling
    return TCommonScaffold(
      title: 'TFields Demo',
      // Because we want this app to be able to toggle between light/dark modes,
      // we must provide a themeToggleCallback to redraw it wherever the user is
      // allowed to toggle between the modes
      themeToggleCallback: Provider.of<TThemeProvider>(context).changeTheme,
      // Because settings are standardized, the CommonScaffold already provides
      // a convenient way to link to settings in the top right corner, just pass
      // in a function to actually Navigate to it
      settingsLink: _navigateToSettings,
      // Additional TAppBarButtons can also be provided to sit next to the
      // settings button, though there's nothing protecting them from
      // overflowing if the window's width becomes too small
      additionalAppBarButtons: <TAppBarButton>[
        TAppBarButton(
          text: 'Something',
          icon: Icons.question_mark,
          onTap: () => showSuccess('Wow!'),
        ),
      ],
      // A footer that acts separate from the ListView, and will always be
      // visible - because of that, we need to know the height upfront, to
      // reserve the screen space for it
      footer: (
        height: 50,
        widget: const Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "This is a footer! Did you notice how it doesn't scroll with "
                'the rest of the screen?',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      children: <Widget>[
        const TTitleDivider(titleText: 'Update Checker'),
        Text(
          'Version ${MainWidget.version}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        // Only display the update status if we actually have checkUpdates
        // enabled in the settings
        if (settings.checkUpdates)
          TUpdateStatus(
            hasCheckedForUpdates: updateChecker.hasCheckedForUpdates,
            updateCheckSucceeded: updateChecker.updateCheckSucceeded,
            hasUpdate: updateChecker.hasUpdate,
            latestVersion: updateChecker.latestVersion,
            onUpdateTap: updateChecker.openLatestVersion,
          ),
        const TTitleDivider(
          titleText: 'TButton.iconOnly / TButton.iconAndLabel',
        ),
        // The iconOnly constructors will display the icon by itself, with a
        // tooltip text on hover. Shortcuts are available for all preset icons
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
            TButton.iconOnly(
              icon: const TIcon(icon: Icons.dashboard_customize),
              text: 'Customizable text',
              onPressed: () {},
            ),
            TButton.iconOnly.download(onPressed: () {}),
            TButton.iconOnly.upload(onPressed: () {}),
            TButton.iconOnly.filter(onPressed: () {}),
            TButton.iconOnly.add(onPressed: () {}),
            TButton.iconOnly.edit(onPressed: () {}),
            TButton.iconOnly.close(onPressed: () {}),
            TButton.iconOnly.cancel(onPressed: () {}),
            TButton.iconOnly.save(onPressed: () {}),
            TButton.iconOnly.refresh(onPressed: () {}),
            TButton.iconOnly.delete(onPressed: () {}),
          ],
        ),
        // The iconOnly constructors also have a showBorder argument, to add a
        // circular border around the icon
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
            TButton.iconOnly(
              icon: const TIcon(icon: Icons.dashboard_customize),
              text: 'Customizable text',
              showBorder: true,
              onPressed: () {},
            ),
            TButton.iconOnly.download(onPressed: () {}, showBorder: true),
            TButton.iconOnly.upload(onPressed: () {}, showBorder: true),
            TButton.iconOnly.filter(onPressed: () {}, showBorder: true),
            TButton.iconOnly.add(onPressed: () {}, showBorder: true),
            TButton.iconOnly.edit(onPressed: () {}, showBorder: true),
            TButton.iconOnly.close(onPressed: () {}, showBorder: true),
            TButton.iconOnly.cancel(onPressed: () {}, showBorder: true),
            TButton.iconOnly.save(onPressed: () {}, showBorder: true),
            TButton.iconOnly.refresh(onPressed: () {}, showBorder: true),
            TButton.iconOnly.delete(onPressed: () {}, showBorder: true),
          ],
        ),
        // The iconAndLabel constructors will display the icon next to the text,
        // making the whole area clickable. Shortcuts are available for all
        // preset icons
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: <Widget>[
            TButton.iconAndLabel(
              icon: const TIcon(icon: Icons.dashboard_customize),
              text: 'Customizable text',
              onPressed: () {},
            ),
            TButton.iconAndLabel.download(onPressed: () {}),
            TButton.iconAndLabel.upload(onPressed: () {}),
            TButton.iconAndLabel.filter(onPressed: () {}),
            TButton.iconAndLabel.add(onPressed: () {}),
            TButton.iconAndLabel.edit(onPressed: () {}),
            TButton.iconAndLabel.close(onPressed: () {}),
            TButton.iconAndLabel.cancel(onPressed: () {}),
            TButton.iconAndLabel.save(onPressed: () {}),
            TButton.iconAndLabel.refresh(onPressed: () {}),
            TButton.iconAndLabel.delete(onPressed: () {}),
          ],
        ),
        const TTitleDivider(
          titleText: 'Time Tracker / TGridRow / TButton.elevated',
        ),
        // The intrinsic height here caps the double.infinity height of the
        // vertical dividers, limiting to the height of the associated butons
        IntrinsicHeight(
          // The TGridRow will force you to wrap the row's children in a
          // TGridItem class, that tells the row how that item behaves in a
          // responsive screen environment. More details in the appropriate
          // section
          child: TGridRow(
            smFlexLimit: 1,
            mainAxisAlignment: MainAxisAlignment.center,
            // A TSpacedRow's spacer widget can be as complex as necessary, it
            // will be replicated between each child widget, so it's perfect
            // for blank spaces or dividers
            horizontalSpacer: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 1,
                height: double.infinity,
                child: ColoredBox(color: Colors.grey),
              ),
            ),
            // Here since we have a child with infinite height (the divider), we
            // must set this flag to true so that each row is set to its
            // intrinsic height
            forceIntrinsicHeight: true,
            children: <TGridItem>[
              TGridItem(
                child: Text(
                  _lastReset != null
                    ? 'The timer was reset '
                        '${_lastReset!.relativeTimestamp()}'
                    : 'The demo has been up for $elapsedSeconds seconds',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              TGridItem(
                child: TButton.elevated(
                  // Setting usesMaxWidth to false has the same effect as
                  // wrapping the button in a IntrinsicWidth widget. This is
                  // already the default behavior
                  // ignore: avoid_redundant_argument_values
                  usesMaxWidth: false,
                  text: timerIsActive ? 'Pause' : 'Resume',
                  icon: TIcon(
                    icon: timerIsActive ? Icons.pause : Icons.play_arrow,
                  ),
                  // We can stop and resume the timer freely without resetting
                  // it by calling stopTimer / resumeTimer
                  onPressed: timerIsActive ? stopTimer : resumeTimer,
                ),
              ),
              TGridItem.fixedSize(
                // A flex of zero means this widget will only take up as much
                // space as necessary, leaving the non-zero flex widgets to
                // share the remainder width
                size: const TGridSize.zero(),
                child: TButton.elevated(
                  text: 'Restart',
                  icon: const TIcon(icon: Icons.refresh),
                  // Calling startTimer, however, will reset the number of
                  // elapsed seconds the state has been keeping track of
                  onPressed: () {
                    _lastReset = DateTime.now();
                    startTimer();
                  },
                ),
              ),
              TGridItem.fixedSize(
                // A size of fill means the widget will always occupy its own
                // row in the final rendering, isolating it from the other
                // children. This can also be achieved by passing a negative
                // flex value
                size: const TGridSize.fill(),
                child: TButton.elevated(
                  text: 'Open TGridRow showcase',
                  icon: const TIcon(icon: Icons.open_in_new),
                  onPressed: _navigateToGridRowShowcase,
                ),
              ),
            ],
          ),
        ),
        const TTitleDivider(titleText: 'Alert Handler / TDialog'),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: <Widget>[
            TButton.elevated(
              text: 'Success dialog',
              // A call to showCommonDialog completes when the user dismisses
              // the alert, though the return can also be ignored to just
              // display the message and move on with execution
              onPressed: () => showSuccess('A success message!'),
            ),
            TButton.elevated(
              text: 'Warning dialog',
              onPressed: () =>
                  showWarning('A warning message!', body: "The warning's body"),
            ),
            TButton.elevated(
              text: 'Bool warning dialog',
              // A showBoolDialog completes when the user dismisses the alert,
              // but it also returns whether the user clicked on the OK or the
              // CANCEL button - if neither was clicked, it will collapse the
              // value to false
              onPressed: () =>
                  showConfirmation('A warning message with options!'),
            ),
          ],
        ),
        const TTitleDivider(titleText: 'Settings Reader / Loggable / Logger'),
        // Reading information from settings is straightforward after it was
        // initialized in loadSettings - trying any of this without calling it
        // will result in a Late Initialization Error
        Text(
          'The current log level is: "${settings.logLevel.name}" | Automatic '
          'update checking is currently '
          '${settings.checkUpdates ? 'enabled' : 'disabled'} | The current '
          'custom value in settings is: "${settings.customValue}"',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        TGridRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          smFlexLimit: 1,
          lgFlexLimit: 2,
          children: <TGridItem>[
            // The form fields can be used independently from the stateful TForm
            // if you need to manage the form state yourself
            TGridItem(
              child: TFormDropdown<TLogLevel>(
                enabled: true,
                title: 'Log level to test',
                hintText: 'Select a log level',
                initialValue: null,
                options:
                    TLogLevel.values.sublist(0, TLogLevel.values.length - 1),
                sortLogic: TDropdownSortLogic.object,
                toDropdownText: (TLogLevel level) => level.dropdownText,
                onValueChanged: (TLogLevel? value) => setState(() {
                  if (value != null) {
                    _selectedLogLevelTest = value;
                  }
                }),
              ),
            ),
            // But if you want to access the state directly, just pass in a key
            // of the appropriate type so you can access it later
            TGridItem(
              child: TFormString(
                key: _logTestKey,
                enabled: true,
                title: 'Message to log',
                hintText: 'Type in a message',
                initialValue: '',
              ),
            ),
            TGridItem(
              child: TButton.elevated(
                usesMaxWidth: true,
                text: 'Log the message',
                icon: const TIcon(icon: Icons.edit),
                // Logging a message is as simple as calling the log function
                // with a LogLevel and the string to be logged - the mixin will
                // already handle writing to disk and whether the message should
                // be logged or not according to the user's settings. Other
                // functions like logBuffer and logFlush can also be used to
                // finely control when log messages are flushed to disk
                onPressed: () async => log(
                  _selectedLogLevelTest,
                  _logTestKey.currentState?.value ?? '',
                ),
              ),
            ),
          ],
        ),
        const TTitleDivider(titleText: 'TRoundedBorder / TClickable / TSwitch'),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            // A TClickable is simply an easy way to make any widget clickable
            // to trigger a specific function. It will already handle the mouse
            // events and swap the type of cursor automatically
            TClickable(
              onTap: () => _toggleSwitch(newValue: !_currentSwitchValue),
              child: const Text(
                'This text is clickable and toggles the switch!',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TSwitch(
              expanded: false,
              value: _currentSwitchValue,
              onChanged: (bool value) => _toggleSwitch(newValue: value),
              title: 'Switches can have titles',
              onText: 'Value is TRUE',
              offText: 'Value is FALSE',
            ),
            // A TRoundedBorder is just a simple standardized way to wrap a
            // Widget in a rounded border, to minimize boilerplate and
            // indentation - we use a specialized version here that keeps track
            // of whether the mouse is inside its region or not, to highlight
            // when the user is interacting with it
            TClickableRoundedBorder(
              onTap: () => _toggleSwitch(newValue: !_currentSwitchValue),
              stateUpdateCallback: () => setState(() {}),
              childPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: const Text(
                'This text is also clickable, but has a "fancy" border!',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        const TTitleDivider(titleText: 'Discardable Changes / TForm'),
        TButton.elevated(
          text: 'Open form showcase',
          icon: const TIcon(icon: Icons.open_in_new),
          onPressed: _navigateToFormShowcase,
        ),
      ],
    );
  }
}
