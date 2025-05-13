import 'package:appstream_tool/constant.dart';
import 'package:appstream_tool/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:appstream_tool/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 580),
    minimumSize: Size(800, 580),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await Future.delayed(const Duration(milliseconds: 100));
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: BLUE),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
