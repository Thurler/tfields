import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tfields/mixins/loggable.dart';
import 'package:tfields/mixins/settings_reader.dart';
import 'package:tfields/mixins/update_checker.dart';
import 'package:tfields/tfields.dart';
import 'package:tfields/update_checker.dart';
import 'package:tfields/widgets/common_scaffold.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touhou Labyrinth 2 Save Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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

class MainUpdateCheck extends UpdateCheck {
  @override
  String get githubEndpoint =>
      'https://api.github.com/repos/thurler/thlaby2-save-editor/releases/latest';
}

class MainWidget extends StatefulWidget {
  static const String version = '0.0.1';

  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainState();
}

class MainState extends State<MainWidget>
    with
        Loggable,
        SettingsReader<CustomSettings>,
        CustomSettingsReader,
        AlertHandler<MainWidget>,
        TimeTracker<MainWidget>,
        UpdateChecker<MainUpdateCheck> {
  Future<void> _callUpdateCheck() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    await checkForUpdates(MainWidget.version);
  }

  Future<void> _navigateToSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CustomSettingsWidget(title: 'Demo settings'),
      ),
    );
  }

  @override
  void updateCheckCallback() => setState(() {});

  @override
  MainUpdateCheck updateChecker = MainUpdateCheck();

  @override
  void initState() {
    super.initState();
    loadSettings();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startTimer();
      await _callUpdateCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'TFields Example',
      settingsLink: _navigateToSettings,
      children: <Widget>[
        const Text('Version ${MainWidget.version}'),
        if (settings.checkUpdates)
          UpdateStatus(
            hasCheckedForUpdates: updateChecker.hasCheckedForUpdates,
            updateCheckSucceeded: updateChecker.updateCheckSucceeded,
            hasUpdate: updateChecker.hasUpdate,
            latestVersion: updateChecker.latestVersion,
            onUpdateTap: updateChecker.openLatestVersion,
          ),
        IntrinsicHeight(
          child: TSpacedRow(
            spacer: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 1,
                height: double.infinity,
                child: ColoredBox(color: Colors.grey),
              ),
            ),
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  'The demo has been up for $elapsedSeconds seconds',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: TButton(
                  usesMaxWidth: false,
                  text: timerIsActive ? 'Pause' : 'Resume',
                  icon: timerIsActive ? Icons.pause : Icons.play_arrow,
                  onPressed: timerIsActive ? stopTimer : resumeTimer,
                ),
              ),
              Flexible(
                flex: 0,
                child: TButton(
                  usesMaxWidth: false,
                  text: 'Restart',
                  icon: Icons.refresh,
                  onPressed: startTimer,
                ),
              ),
            ],
          ),
        ),
        TSpacedRow(
          expanded: true,
          spacer: const SizedBox(width: 20),
          children: <Widget>[
            TButton(
              text: 'Success dialog',
              onPressed: () async => showCommonDialog(
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
      ],
    );
  }
}
