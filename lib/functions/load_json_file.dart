import 'dart:io';
import 'dart:async';
import 'package:appstreamcontrolpanel/functions/write_log.dart';
import 'package:yaml/yaml.dart';

Future<List<Map<String, dynamic>>> loadJsonFile(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final dynamic jsonData = loadYaml(jsonString);

      if (jsonData is YamlList) {
        // Convert each item in the list to a Map<String, dynamic>
        return jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
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
