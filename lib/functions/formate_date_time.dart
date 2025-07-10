String formatDateTime(DateTime dateTime) {
  return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} "
      "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
