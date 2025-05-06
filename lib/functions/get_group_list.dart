import 'package:appstream_tool/classes/program.dart';
import 'package:appstream_tool/global_variable.dart';

void getGroupList() {
  for (Program program in programs) {
    if (!groupList.contains(program.group)) {
      groupList.add(program.group);
    }
  }
}
