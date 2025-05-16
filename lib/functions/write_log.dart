import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

String formatDateTime(DateTime dateTime) {
  return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
      "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
