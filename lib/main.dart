import 'package:appstreamcontrolpanel/constant.dart';
import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:appstreamcontrolpanel/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 580),
    minimumSize: Size(852, 632),
    maximumSize: Size(852, 632),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  jsonPath = prefs.getString('json_path') ??
      'C:\\Mentz GmbH\\Com\\Scripts\\Programs.json';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppStreamControlPanel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: BLUE),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
