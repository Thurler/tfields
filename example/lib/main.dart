import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tfields/logger.dart';
import 'package:tfields/mixins/alert.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/mixins/time_tracker.dart';
import 'package:tfields/mixins/update_checker.dart';
import 'package:tfields/update_checker.dart';
import 'package:tfields/widgets/appbar_button.dart';
import 'package:tfields/widgets/button.dart';
import 'package:tfields/widgets/clickable.dart';
import 'package:tfields/widgets/common_scaffold.dart';
import 'package:tfields/widgets/dialog.dart';
import 'package:tfields/widgets/form/dropdown.dart';
import 'package:tfields/widgets/form/string.dart';
import 'package:tfields/widgets/rounded_border.dart';
import 'package:tfields/widgets/spaced_row.dart';
import 'package:tfields/widgets/switch.dart';
import 'package:tfields/widgets/title_divider.dart';
import 'package:tfields/widgets/update_status.dart';
import 'package:tfields_example/custom_settings.dart';
import 'package:tfields_example/form_showcase.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFields Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        // This will make the scrollbar always visible
        scrollbarTheme: ScrollbarThemeData(
          trackColor: WidgetStateProperty.all(Colors.white.withOpacity(0.5)),
          thumbColor: WidgetStateProperty.all(Colors.green),
          trackVisibility: WidgetStateProperty.all(true),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainWidget(),
    );
  }
}

/// Extend the basic UpdateCheck with the latest github releases endpoint
class MainUpdateCheck extends UpdateCheck {
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
        Loggable, // This state can write to the logs
        SettingsReader<CustomSettings>, // This state can read the settings
        CustomSettingsReader, // Specifies it's the custom settings in our app
        AlertHandler<MainWidget>, // This state can generate alerts
        TimeTracker<MainWidget>, // This state can keep track of elapsed time
        UpdateChecker<MainUpdateCheck> // This state will check for updates
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
    loadSettings();
    setState(() {
      _selectedLogLevelTest = settings.logLevel.name;
    });
  }

  /// Navigate away to the form showcase widget
  Future<void> _navigateToFormShowcase() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const FormShowcase(),
      ),
    );
  }

  /// Simple callback to update switch value
  void _toggleSwitch({required bool newValue}) => setState(() {
    _currentSwitchValue = newValue;
  });

  /// Keep track of the switch's current state
  bool _currentSwitchValue = true;

  /// Keep track of whether the tclickable text is being hovered over or not
  bool _hoveringOverText = false;

  /// Simple text editing controller for log test
  final TextEditingController _logTestController = TextEditingController();

  /// Simple dropdown option tracker for log test
  String _selectedLogLevelTest = '';

  @override
  void initState() {
    super.initState();
    // Calling loadSettings on initState is MANDATORY for SettingsReader, so
    // that we guarantee the late settings variable is initialized for all
    // logic
    loadSettings();
    // After loading the settings, we can confidently call on the settings
    // variable, which will be loaded with the user's settings
    _selectedLogLevelTest = settings.logLevel.name;
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
    return CommonScaffold(
      title: 'TFields Demo',
      // Because settings are standardized, the CommonScaffold already provides
      // a a convenient way to link to settings in the top right corner, just
      // pass in a function to actually Navigate to it
      settingsLink: _navigateToSettings,
      // Additional TAppBarButtons can also be provided to sit next to the
      // settings button, though there's nothing protecting them from
      // overflowing if the window's width becomes too small
      additionalAppBarButtons: <TAppBarButton>[
        TAppBarButton(
          text: 'Something',
          icon: Icons.question_mark,
          onTap: () async => showCommonDialog(
            TDialog.success(titleText: 'Wow!'),
          ),
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
        const Text('Version ${MainWidget.version}'),
        // Only display the update status if we actually have checkUpdates
        // enabled in the settings
        if (settings.checkUpdates)
          UpdateStatus(
            hasCheckedForUpdates: updateChecker.hasCheckedForUpdates,
            updateCheckSucceeded: updateChecker.updateCheckSucceeded,
            hasUpdate: updateChecker.hasUpdate,
            latestVersion: updateChecker.latestVersion,
            onUpdateTap: updateChecker.openLatestVersion,
          ),
        const TTitleDivider(titleText: 'Time Tracker / TSpacedRow / TButton'),
        // The intrinsic height here caps the double.infinity height of the
        // vertical dividers, limiting to the height of the associated butons
        IntrinsicHeight(
          // The TSpacedRow will wrap every child in a Expanded/Flexible to make
          // sure everything stays responsive, but it's smart enough to not
          // double wrap them if the child is already a Flex. If you need fine
          // control over a TSpacedRow's children's flex, you can just wrap them
          // yourself and have everything work the same
          child: TSpacedRow(
            // A TSpacedRow's spacer widget can be as complex as necessary, it
            // will be replicated between each child widget, so it's perfect
            // for blank spaces or dividers
            spacer: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 1,
                height: double.infinity,
                child: ColoredBox(color: Colors.grey),
              ),
            ),
            // By setting MainAxisSize to min, we effectively wrap the row in a
            // IntrinsicWidth, preventing it from expanding to fill the entire
            // available width. This does not matter if the children are set to
            // expand to fill the available width, though - then each child must
            // be wrapped in its own IntrinsicWidth
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  'The demo has been up for $elapsedSeconds seconds',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Flexible(
                // A flex of zero means this widget will only take up as much
                // space as necessary, leaving the non-zero flex widgets to
                // share the remainder width
                flex: 0,
                child: TButton(
                  // Setting usesMaxWidth to false has the same effect as
                  // wrapping the button in a IntrinsicWidth widget, similar to
                  // what was mentioned above for the whole TSpacedRow
                  usesMaxWidth: false,
                  text: timerIsActive ? 'Pause' : 'Resume',
                  icon: timerIsActive ? Icons.pause : Icons.play_arrow,
                  // We can stop and resume the timer freely without resetting
                  // it by calling stopTimer / resumeTimer
                  onPressed: timerIsActive ? stopTimer : resumeTimer,
                ),
              ),
              Flexible(
                flex: 0,
                child: TButton(
                  usesMaxWidth: false,
                  text: 'Restart',
                  icon: Icons.refresh,
                  // Calling startTimer, however, will reset the number of
                  // elapsed seconds the state has been keeping track of
                  onPressed: startTimer,
                ),
              ),
            ],
          ),
        ),
        const TTitleDivider(titleText: 'Alert Handler / TDialog'),
        TSpacedRow(
          // Calling TSpacedRow with expanded true will make sure every child
          // takes up as much space as possible, evenly distributing the width
          // between them - every one of them has the same flex
          expanded: true,
          spacer: const SizedBox(width: 20),
          children: <Widget>[
            TButton(
              text: 'Success dialog',
              // A call to showCommonDialog completes when the user dismisses
              // the alert, though the return can also be ignored to just
              // display the message and move on with execution
              onPressed: () async => showCommonDialog(
                // These named constructors provide pre-built common dialogs,
                // but the nameless constructor is also available if you need
                // to fine tune the behavior
                TDialog.success(titleText: 'A success message!'),
              ),
            ),
            TButton(
              text: 'Warning dialog',
              onPressed: () async => showCommonDialog(
                TDialog.warning(
                  titleText: 'A warning message!',
                  bodyText: "The warning's body",
                  confirmText: 'OK',
                ),
              ),
            ),
            TButton(
              text: 'Bool warning dialog',
              // A showBoolDialog completes when the user dismisses the alert,
              // but it also returns whether the user clicked on the OK or the
              // CANCEL button - if neither was clicked, it will collapse the
              // value to false
              onPressed: () async => showBoolDialog(
                TDialog.boolWarning(
                  titleText: 'A warning message with options!',
                  bodyText: 'A warning body',
                  confirmText: 'Confirm text',
                  cancelText: 'Cancel text',
                ),
              ),
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
        ),
        TSpacedRow(
          spacer: const SizedBox(width: 20),
          children: <Widget>[
            // The form fields can be used independently from the stateful TForm
            // if you need to manage the form state yourself - these are just
            // stateless widgets of the "right side" of a TForm
            TFormDropdownField(
              enabled: true,
              hintText: 'Select a log level...',
              value: _selectedLogLevelTest,
              // We omit the "none" option here as it's not a valid LogLevel
              // for a message - the whole point of it is that no message can
              // have that LogLevel
              options: LogLevel.values.sublist(
                0,
                LogLevel.values.length - 1,
              ).map(
                (LogLevel l) => l.name,
              ).toList(),
              updateValue: (String? value) => setState(() {
                if (value != null) {
                  _selectedLogLevelTest = value;
                }
              }),
            ),
            TFormStringField(
              enabled: true,
              hintText: 'Type in a message...',
              controller: _logTestController,
            ),
            TButton(
              text: 'Log the message',
              icon: Icons.edit,
              // Logging a message is as simple as calling the log function with
              // a LogLevel and the string to be logged - the mixin will already
              // handle writing to disk and whether the message should be logged
              // or not according to the user's settings. Other functions like
              // logBuffer and logFlush can also be used to finely control when
              // log messages are flushed to disk
              onPressed: () async => log(
                LogLevel.fromName(_selectedLogLevelTest),
                _logTestController.text,
              ),
            ),
          ],
        ),
        const TTitleDivider(titleText: 'TRoundedBorder / TClickable / TSwitch'),
        TSpacedRow(
          mainAxisSize: MainAxisSize.min,
          spacer: const SizedBox(width: 20),
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
              value: _currentSwitchValue,
              onChanged: (bool value) => _toggleSwitch(newValue: value),
              title: 'Switches can have titles',
              onText: 'Value is TRUE',
              offText: 'Value is FALSE',
            ),
            // A TRoundedBorder is just a simple standardized way to wrap a
            // Widget in a rounded border, to minimize boilerplate and
            // indentation
            TRoundedBorder(
              childPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              // By piggybacking on a TClickable's onEnter and onExit events,
              // you can also highlight the border whenever the user's mouse
              // enters and leaves the TRoundedBorder's region
              color: _hoveringOverText ? Colors.green : Colors.grey,
              width: _hoveringOverText ? 3 : 1,
              child: TClickable(
                // These callbacks are only really useful for web and desktop
                // environments, since mobile users have no mouse cursor to
                // enter and leave the Widget's region
                onEnter: (_) => setState(() {
                  _hoveringOverText = true;
                }),
                onExit: (_) => setState(() {
                  _hoveringOverText = false;
                }),
                onTap: () => _toggleSwitch(newValue: !_currentSwitchValue),
                child: const Text(
                  'This text is also clickable, but has a fancy border!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        const TTitleDivider(titleText: 'Discardable Changes / TForm'),
        TButton(
          text: 'Open form showcase',
          icon: Icons.open_in_new,
          onPressed: _navigateToFormShowcase,
        ),
      ],
    );
  }
}
