import 'dart:io';

import 'package:appstreamcontrolpanel/classes/program.dart';
import 'package:appstreamcontrolpanel/functions/formate_date_time.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';

class AppState extends ChangeNotifier {
  List<String> groupList = <String>['Alle anzeigen'];
  List<Program> programs = [];
  List<Program> filterdPrograms = [];
  String searchString = "";
  String jsonPath = "";
  List<String> logList = [];

  void wirteLog(String logString) async {
    DateTime date = DateTime.now();
    String log = '${formatDateTime(date)}   ${logString}';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    logList = prefs.getStringList('log_list') ?? [];
    add(log);
    await prefs.setStringList('log_list', logList);
  }

  void add(String log) {
    if (logList.length >= 500) {
      logList.removeAt(0);
    }
    logList.add(log);
  }

  void getGroupList() {
    for (Program program in programs) {
      if (!groupList.contains(program.group)) {
        groupList.add(program.group);
      }
    }
  }

  Future<List<Map<String, dynamic>>> loadJsonFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final dynamic jsonData = loadYaml(jsonString);

        if (jsonData is YamlList) {
          // Convert each item in the list to a Map<String, dynamic>
          return jsonData
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        } else {
          throw Exception("json has the wrong structure");
        }
      } else {
        throw Exception("File not found");
      }
    } on Exception catch (e) {
      wirteLog('Error loading json file: $e');
      return [];
    }
  }
}
