import 'package:appstreamcontrolpanel/app.dart';
import 'package:appstreamcontrolpanel/classes/language_change_provider.dart';
import 'package:appstreamcontrolpanel/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final appState = AppState();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(815, 588),
    minimumSize: Size(852, 632),
    maximumSize: Size(852, 632),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  LanguageChangeProvider languageProvider = LanguageChangeProvider();
  await languageProvider.loadSavedLocale();

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    Platform.isWindows ? await windowManager.setResizable(false) : Null;
  });

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  appState.jsonPath = prefs.getString('json_path') ??
      (Platform.isWindows
          ? 'C:\\Mentz GmbH\\Com\\Scripts\\Programs.json'
          : '/scripts/programs.json');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageChangeProvider>.value(
          value: languageProvider,
        ),
        ChangeNotifierProvider<AppState>.value(value: appState),
      ],
      child: const AppStreamControlPanelApp(),
    ),
  );
}
