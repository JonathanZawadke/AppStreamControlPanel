import 'dart:isolate';
import 'dart:io';
import 'dart:math';
import 'package:appstreamcontrolpanel/classes/program.dart';
import 'package:appstreamcontrolpanel/functions/get_group_list.dart';
import 'package:appstreamcontrolpanel/functions/get_translated_dropdown_text.dart';
import 'package:appstreamcontrolpanel/functions/load_json_file.dart';
import 'package:appstreamcontrolpanel/functions/write_log.dart';
import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:appstreamcontrolpanel/models/custom_title_bar.dart';
import 'package:appstreamcontrolpanel/models/start_button.dart';
import 'package:appstreamcontrolpanel/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:appstreamcontrolpanel/models/custom_text_field.dart';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:appstreamcontrolpanel/models/programm_button.dart';
import 'package:gif/gif.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Program> selectedPrograms = [];
  bool isLoading = false;
  bool allDeselected = true;

  late final GifController controller;
  bool isVisible = true;

  int countTrysToLoadJson = 0;

  @override
  void initState() {
    controller = GifController(vsync: this);
    controller.addListener(() {
      if (controller.isCompleted) {
        setState(() {
          isVisible = false;
        });
      }
    });
    super.initState();
    loadJsonData();
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: LIGHT_GRAY,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(BORDER_RADIUS)),
          ),
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.error),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                AppLocalizations.of(context)!.error,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
              "${AppLocalizations.of(context)!.the_program} $message ${AppLocalizations.of(context)!.cannot_be_started}."),
          actions: <Widget>[
            Material(
              color: BLUE,
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  height: 30,
                  width: 45,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: LIGHT_GRAY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BORDER_RADIUS),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text("${AppLocalizations.of(context)!.load}..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> startPrograms() async {
    for (Program program in selectedPrograms) {
      try {
        showLoadingDialog(context);
        List<String> parameters = program.parameter.split(' ');

        await Isolate.run(() async {
          await Process.start(program.path, parameters);
        });

        Navigator.of(context).pop();

        wirteLog(
            "${program.name} ${AppLocalizations.of(context)!.started_successfully}");
      } catch (e) {
        Navigator.of(context).pop();
        wirteLog(
            "${AppLocalizations.of(context)!.program_path_for_program}: ${program.name} ${AppLocalizations.of(context)!.could_not_be_found}");
        showErrorDialog(context, program.name);
      }
    }
  }

  Future<void> loadJsonData() async {
    final data = await loadJsonFile(jsonPath);
    setState(() {
      programs = data.map((item) => Program.fromJson(item)).toList();
      filterdPrograms = List.from(programs);
      getGroupList();
    });
  }

  void filterProgramsByGroop(String group) {
    filterdPrograms.clear();
    if (group == "Alle anzeigen") {
      filterdPrograms = List.from(programs);
    } else {
      for (Program p in programs) {
        if (p.group == group) {
          filterdPrograms.add(p);
        }
      }
    }
  }

  void filterProgramsByName(String searchString) {
    filterdPrograms.clear();

    for (Program p in programs) {
      if (p.name.toLowerCase().contains(searchString.toLowerCase())) {
        filterdPrograms.add(p);
      }
    }
  }

  String dropdownValue = groupList.first;
  @override
  Widget build(BuildContext context) {
    if (filterdPrograms.isEmpty) {
      if (countTrysToLoadJson <= 15) {
        Future.delayed(const Duration(seconds: 5), () {
          loadJsonData();
        });
        countTrysToLoadJson++;
      } else {
        wirteLog(AppLocalizations.of(context)!.filteredPrograms_is_empty);
      }
    }
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Popup_Background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: isVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 52.5, left: 22.8),
                  child: //Container(height: 30, width: 128, color: Colors.green),
                      Gif(
                    height: 29,
                    width: 125.5,
                    fit: BoxFit.fill,
                    placeholder: (context) {
                      return Container(
                          height: 30, width: 125.5, color: DARK_GRAY);
                    },
                    image: const AssetImage("assets/MENTZ_LOGO_GIF.gif"),
                    controller: controller,
                    autostart: Autostart.no,
                    onFetchCompleted: () {
                      controller.reset();
                      controller.forward();
                    },
                  ),
                ),
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 52, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomTextField(
                          onChanged: () {
                            setState(() {
                              filterProgramsByName(searchString);
                            });
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        // filter Programs Groop -----------------------------------------------
                        Container(
                          height: 35,
                          width: 175,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(BORDER_RADIUS),
                          ),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Transform.rotate(
                              angle: 90 * pi / 180,
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            borderRadius: BorderRadius.circular(BORDER_RADIUS),
                            isExpanded: true,
                            padding: const EdgeInsets.only(left: 15, right: 8),
                            underline: Container(
                              color: Colors.transparent,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                                filterProgramsByGroop(dropdownValue);
                              });
                            },
                            items: groupList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  getTranslatedDropdownText(value, context),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Programm Buttons ------------------------------------
                  SizedBox(
                    height: 364,
                    width: 745,
                    child: filterdPrograms.isEmpty
                        ? Center(
                            child: IntrinsicHeight(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                Text(AppLocalizations.of(context)!
                                    .cannot_load_configuration),
                              ],
                            ),
                          ))
                        : Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 364,
                              ),
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 15.0,
                                  runSpacing: 20.0,
                                  children:
                                      filterdPrograms.map((filterdPrograms) {
                                    return ProgrammButton(
                                      key: ValueKey(filterdPrograms.id),
                                      name: filterdPrograms.name,
                                      image: filterdPrograms.icon,
                                      initialIsSelected: allDeselected
                                          ? false
                                          : selectedPrograms
                                              .contains(filterdPrograms),
                                      onTap: () {
                                        setState(
                                          () {
                                            if (selectedPrograms
                                                .contains(filterdPrograms)) {
                                              selectedPrograms
                                                  .remove(filterdPrograms);
                                            } else {
                                              allDeselected = false;
                                              selectedPrograms
                                                  .add(filterdPrograms);
                                              wirteLog(
                                                  "${AppLocalizations.of(context)!.user_selected} ${filterdPrograms.name}");
                                            }
                                          },
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  // Start Button ---------------------------------------------------
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: StartButton(
                        selectedPrograms: selectedPrograms,
                        onTap: () {
                          startPrograms().then((_) {
                            setState(() {
                              allDeselected = true;
                              selectedPrograms.clear();
                            });
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              // Title Bar ----------------------------------------------------------
              CustomTitleBar(
                onSettingsTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        ),
                        child: SettingsPage(
                          onJsonPathChange: (String result) {
                            loadJsonData();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
