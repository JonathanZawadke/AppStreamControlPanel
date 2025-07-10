import 'dart:io';

import 'package:appstreamcontrolpanel/classes/program.dart';
import 'package:appstreamcontrolpanel/constants/app_colors.dart';
import 'package:appstreamcontrolpanel/constants/ui_constants.dart';
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
      color: widget.selectedPrograms.isNotEmpty
          ? AppColors.yellow
          : AppColors.lightGray,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          height: 40,
          width: 159,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: Platform.isWindows ? 5 : 0),
              child: Text(
                AppLocalizations.of(context)!.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1.0,
                    leadingDistribution: TextLeadingDistribution.even,
                    color: widget.selectedPrograms.isNotEmpty
                        ? Colors.black
                        : AppColors.startText),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
