import 'package:appstream_tool/constant.dart';
import 'package:appstream_tool/global_variable.dart';
import 'package:appstream_tool/models/show_password_dialog.dart';
import 'package:appstream_tool/pages/log_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.onJsonPathChange});

  final Function(String) onJsonPathChange;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool adminSettingsVisible = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        jsonPath = result.files.single.path!;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('json_path', jsonPath);
      widget.onJsonPathChange(jsonPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LIGHT_GRAY,
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20.0),
            child: Row(
              children: [
                const Icon(Icons.settings),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Einstellungen',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(BORDER_RADIUS),
                      child: InkWell(
                        hoverColor: YELLOW_HOVER,
                        onTap: () {
                          showPasswordDialog(context, () {
                            setState(() {
                              adminSettingsVisible = true;
                            });
                          });
                        },
                        borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS)),
                          child: const Center(
                            child: Text('Admin Einstellungen'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(BORDER_RADIUS),
                      child: InkWell(
                        hoverColor: YELLOW_HOVER,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: LIGHT_GRAY,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(BORDER_RADIUS),
                                ),
                                child: LogPage(),
                              );
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS)),
                          child: const Center(
                            child: Text('Protokolle anzeigen'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 160,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Container(
                    width: 2,
                    height: 260,
                    color: DIVIDER,
                  ),
                ),
                Visibility(
                  visible: adminSettingsVisible,
                  child: Expanded(
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Selected file path:',
                          ),
                          Text(
                            jsonPath,
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: Material(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS),
                              child: InkWell(
                                hoverColor: YELLOW_HOVER,
                                onTap: () {
                                  pickFile();
                                },
                                borderRadius:
                                    BorderRadius.circular(BORDER_RADIUS),
                                child: Container(
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            BORDER_RADIUS)),
                                    child: const Center(
                                        child: Text('Pick json File'))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: DARK_GRAY,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(BORDER_RADIUS),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  child: Image.asset(
                    'assets/MENTZ_LOGO.png',
                  ),
                ),
                const Expanded(child: SizedBox()),
                Material(
                  color: BLUE,
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const SizedBox(
                      height: 30,
                      width: 100,
                      child: Center(
                        child: Text(
                          "Schließen",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
