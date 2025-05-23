import 'package:appstreamcontrolpanel/classes/program.dart';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartButton extends StatefulWidget {
  const StartButton({
    super.key,
    required this.selectedPrograms,
    required this.onTap,
  });

  final VoidCallback onTap;
  final List<Program> selectedPrograms;

  @override
  State<StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.selectedPrograms.isNotEmpty ? YELLOW : LIGHT_GRAY,
      borderRadius: BorderRadius.circular(BORDER_RADIUS),
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        child: SizedBox(
          height: 40,
          width: 159,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: widget.selectedPrograms.isNotEmpty
                      ? Colors.black
                      : START_TEXT),
            ),
          ),
        ),
      ),
    );
  }
}
