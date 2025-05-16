import 'package:appstreamcontrolpanel/classes/program.dart';
import 'package:appstreamcontrolpanel/global_variable.dart';

void getGroupList() {
  for (Program program in programs) {
    if (!groupList.contains(program.group)) {
      groupList.add(program.group);
    }
  }
}
