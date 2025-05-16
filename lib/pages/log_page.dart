import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogPage extends StatefulWidget {
  LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  void initState() {
    super.initState();
    getLogFromSharedPreferences();
  }

  void getLogFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      logList = prefs.getStringList('log_list') ?? [];
    });
  }

  Future<void> writeStringsToFile(List<String> strings, String logPath) async {
    final file = File(logPath);

    // Die Strings in die Datei schreiben
    await file.writeAsString(strings.join('\n'));
  }

  // Funktion zum Öffnen des Datei-Explorers und zum Auswählen des Speicherorts
  Future<String?> pickFilePath() async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Speichern unter',
      fileName: 'log.txt',
    );
    return result;
  }

  String logPath = "";
  bool isReversed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Protokolle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(color: DIVIDER),
                  borderRadius: BorderRadius.circular(BORDER_RADIUS)),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isReversed = !isReversed;
                          });
                        },
                        borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          width: 135,
                          child: Row(
                            children: [
                              const Text("Time"),
                              const Expanded(child: SizedBox()),
                              isReversed
                                  ? Transform.rotate(
                                      angle: -90 * pi / 180,
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    )
                                  : Transform.rotate(
                                      angle: 90 * pi / 180,
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("Text"),
                      const Expanded(child: SizedBox()),
                      Material(
                        color: LIGHT_GRAY,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            logPath = await pickFilePath() ?? '';
                            if (logPath == '') {
                              return;
                            }
                            await writeStringsToFile(logList, logPath);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: LIGHT_GRAY,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(BORDER_RADIUS),
                                  ),
                                  title: const Row(children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Icon(Icons.download),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text('Datei gespeichert unter:'),
                                      Text(logPath),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        Material(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              BORDER_RADIUS),
                                          child: InkWell(
                                            hoverColor: YELLOW_HOVER,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              final directory =
                                                  logPath.substring(
                                                      0,
                                                      logPath
                                                          .lastIndexOf('\\'));
                                              OpenFile.open(directory);
                                            },
                                            child: const IntrinsicWidth(
                                              child: SizedBox(
                                                height: 30,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15),
                                                    child: Text(
                                                      "Datei im Explorer öffnen",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Material(
                                          color: BLUE,
                                          borderRadius: BorderRadius.circular(
                                              BORDER_RADIUS),
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
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const SizedBox(
                            width: 26,
                            height: 26,
                            child: Center(
                              child: Icon(Icons.download),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: DIVIDER,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    height: MediaQuery.of(context).size.height * 0.54,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: DIVIDER,
                        );
                      },
                      itemCount: logList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int displayIndex =
                            isReversed ? logList.length - 1 - index : index;
                        return Text(logList[displayIndex]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              color: LIGHT_GRAY,
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
              child: InkWell(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: LIGHT_GRAY,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        ),
                        title: const Text('Möchtest du wirklich löschen?'),
                        content: const Text(
                            'Diese Aktion kann nicht rückgängig gemacht werden.'),
                        actions: <Widget>[
                          Material(
                            //color: Colors.red,
                            borderRadius: BorderRadius.circular(BORDER_RADIUS),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS),
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const SizedBox(
                                height: 30,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    "Abbrechen",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(BORDER_RADIUS),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS),
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const SizedBox(
                                height: 30,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    "Löschen",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).then((result) async {
                    if (result == true) {
                      // The user confirmed the deletion
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setStringList('log_list', []);
                      setState(() {
                        logList.clear();
                      });
                    } else {
                      // The user canceled the deletion
                    }
                  });
                },
                child: const SizedBox(
                  width: 110,
                  height: 26,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Clear Log",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.delete),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
