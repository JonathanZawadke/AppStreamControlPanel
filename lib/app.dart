import 'package:appstreamcontrolpanel/classes/language_change_provider.dart';
import 'package:appstreamcontrolpanel/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:appstreamcontrolpanel/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppStreamControlPanelApp extends StatelessWidget {
  const AppStreamControlPanelApp({super.key});

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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
