import 'package:appstreamcontrolpanel/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showPasswordDialog(BuildContext context, VoidCallback onCorrectPassword) {
  TextEditingController passwordController = TextEditingController();
  bool isError = false;
  const String correctPassword = "lop54y";

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void submitAction() {
            if (passwordController.text == correctPassword) {
              Navigator.of(context).pop(); // Close the password dialog
              onCorrectPassword();
            } else {
              setState(() {
                isError = true;
              });
            }
          }

          return AlertDialog(
            backgroundColor: LIGHT_GRAY,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
            ),
            title: Text(AppLocalizations.of(context)!.enter_password),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.password,
                errorText: isError
                    ? AppLocalizations.of(context)!.incorrect_password
                    : null,
                border: const UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.blue,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.grey,
                  ),
                ),
              ),
              onSubmitted: (value) => submitAction(),
            ),
            actions: [
              Material(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                child: InkWell(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    height: 30,
                    width: 100,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.close,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: BLUE,
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                child: InkWell(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  onTap: () => submitAction(),
                  child: SizedBox(
                    height: 30,
                    width: 100,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
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
    },
  );
}
