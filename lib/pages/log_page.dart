import 'dart:io';
import 'dart:math';
import 'package:appstreamcontrolpanel/constants/app_colors.dart';
import 'package:appstreamcontrolpanel/state/app_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:appstreamcontrolpanel/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogPage extends StatefulWidget {
  LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  late AppState appState;

  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
    getLogFromSharedPreferences();
  }

  void getLogFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appState.logList = prefs.getStringList('log_list') ?? [];
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
      dialogTitle: AppLocalizations.of(context)!.save_as,
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
              Text(
                AppLocalizations.of(context)!.protocols,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(borderRadius)),
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
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          width: 135,
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context)!.time),
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
                      Text(AppLocalizations.of(context)!.text),
                      const Expanded(child: SizedBox()),
                      Material(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            logPath = await pickFilePath() ?? '';
                            if (logPath == '') {
                              return;
                            }
                            await writeStringsToFile(appState.logList, logPath);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.lightGray,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                  ),
                                  title: Row(children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Icon(Icons.download),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.download,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                          '${AppLocalizations.of(context)!.file_saved_as}:'),
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
                                              borderRadius),
                                          child: InkWell(
                                            hoverColor: AppColors.yellowHover,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              final directory =
                                                  logPath.substring(
                                                      0,
                                                      logPath
                                                          .lastIndexOf('\\'));
                                              OpenFile.open(directory);
                                            },
                                            child: IntrinsicWidth(
                                              child: SizedBox(
                                                height: 30,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .open_file_in_explorer,
                                                      style: const TextStyle(
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
                                          color: AppColors.blue,
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: SizedBox(
                                              height: 30,
                                              width: 100,
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .close,
                                                  style: const TextStyle(
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
                    color: AppColors.divider,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.82,
                    height: MediaQuery.of(context).size.height * 0.54,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: AppColors.divider,
                        );
                      },
                      itemCount: appState.logList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int displayIndex = isReversed
                            ? appState.logList.length - 1 - index
                            : index;
                        return Text(appState.logList[displayIndex]);
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
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(borderRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppColors.lightGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        title:
                            Text(AppLocalizations.of(context)!.really_delete),
                        content: Text(
                            AppLocalizations.of(context)!.cannot_be_undone),
                        actions: <Widget>[
                          Material(
                            //color: Colors.red,
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: () {
                                Navigator.of(context).pop(false);
                              },
                              child: SizedBox(
                                height: 30,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(borderRadius),
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: SizedBox(
                                height: 30,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: const TextStyle(
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
                        appState.logList.clear();
                      });
                    } else {
                      // The user canceled the deletion
                    }
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.clear_log,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.delete),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
