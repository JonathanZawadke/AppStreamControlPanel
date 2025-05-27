import 'package:appstreamcontrolpanel/classes/language_change_provider.dart';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:appstreamcontrolpanel/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
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
  jsonPath = prefs.getString('json_path') ??
      'C:\\Mentz GmbH\\Com\\Scripts\\Programs.json';

  runApp(
    ChangeNotifierProvider<LanguageChangeProvider>.value(
      value: languageProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageChangeProvider>(context);

    return MaterialApp(
      title: 'AppStreamControlPanel',
      debugShowCheckedModeBanner: false,
      locale: languageProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('de')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: BLUE),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
