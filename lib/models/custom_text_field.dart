import 'package:appstreamcontrolpanel/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    required this.onChanged,
    super.key,
  });

  VoidCallback onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late AppState appState;

  @override
  void initState() {
    appState = Provider.of<AppState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 227,
      height: 35,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
          hintText: "${AppLocalizations.of(context)!.search}...",
          hintStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: const Icon(
            Icons.search,
            size: 26,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(BORDER_RADIUS),
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        onChanged: (value) {
          appState.searchString = value;
          widget.onChanged();
        },
      ),
    );
  }
}
