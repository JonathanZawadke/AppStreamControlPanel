import 'package:appstreamcontrolpanel/classes/languages_map_entry.dart';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:appstreamcontrolpanel/models/show_password_dialog.dart';
import 'package:appstreamcontrolpanel/pages/log_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:appstreamcontrolpanel/classes/language_change_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.onJsonPathChange});

  final Function(String) onJsonPathChange;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum SettingsView { none, language, admin }

class _SettingsPageState extends State<SettingsPage> {
  var currentView = SettingsView.none;

  int selectedLanguageIndex = 0;
  String selectedLanguageString = 'en';

  static List<LanguagesMapEntry> LANGUAGES = [
    LanguagesMapEntry('de', 'Deutsch'),
    LanguagesMapEntry('en', 'English'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedLanguageString =
        Provider.of<LanguageChangeProvider>(context, listen: true)
            .currentLocale
            .toString();
    selectedLanguageIndex = LANGUAGES
        .indexWhere((element) => element.key == selectedLanguageString);
  }

  void changeLanguage() {
    context.read<LanguageChangeProvider>().changeLocale(selectedLanguageString);
  }

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
                Text(
                  AppLocalizations.of(context)!.settings,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (selectedLanguageString !=
                        Provider.of<LanguageChangeProvider>(context,
                                listen: false)
                            .currentLocale
                            .toString()) {
                      changeLanguage();
                    }
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
                              currentView = SettingsView.admin;
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
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.admin_settings),
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
                          child: Center(
                            child:
                                Text(AppLocalizations.of(context)!.view_logs),
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
                          setState(() {
                            currentView = SettingsView.language;
                          });
                        },
                        borderRadius: BorderRadius.circular(BORDER_RADIUS),
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS)),
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.language),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 115,
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
                  visible: currentView == SettingsView.admin,
                  child: Expanded(
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.selected_file_path,
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
                                    child: Center(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .pick_json_file))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: currentView == SettingsView.language,
                  child: Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            itemCount: LANGUAGES.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(
                                  LANGUAGES[index].value,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                value: index == selectedLanguageIndex
                                    ? true
                                    : false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedLanguageIndex = index;
                                  });
                                  selectedLanguageString = LANGUAGES[index].key;
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
                      if (selectedLanguageString !=
                          Provider.of<LanguageChangeProvider>(context,
                                  listen: false)
                              .currentLocale
                              .toString()) {
                        changeLanguage();
                      }
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      height: 30,
                      width: 100,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.close,
                          style: const TextStyle(
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
