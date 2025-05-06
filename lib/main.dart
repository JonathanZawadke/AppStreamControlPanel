import 'package:appstream_tool/constant.dart';
import 'package:appstream_tool/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:appstream_tool/pages/home_page.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  doWhenWindowReady(() {
    const initialSize = Size(800, 580);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
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
