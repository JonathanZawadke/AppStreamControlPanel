import 'dart:math';
import 'package:appstreamcontrolpanel/constant.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

// ignore: must_be_immutable
class CustomTitleBar extends StatelessWidget {
  CustomTitleBar({super.key, required this.onSettingsTap});

  VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: DARK_GRAY,
      child: WindowTitleBarBox(
        child: Row(
          children: [
            Expanded(
              child: MoveWindow(),
            ),
            WindowButtons(onSettingsTap: onSettingsTap)
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WindowButtons extends StatelessWidget {
  WindowButtons({super.key, required this.onSettingsTap});

  VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const MinimizeWindowButton(),
        SettingsButton(
          onSettingsTap: onSettingsTap,
        ),
        const CloseWindowButton(),
      ],
    );
  }
}

class MinimizeWindowButton extends StatelessWidget {
  const MinimizeWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 30,
      child: MaterialButton(
        hoverColor: BLUE,
        onPressed: () {
          appWindow.minimize();
        },
        child: const Padding(
          padding: EdgeInsets.only(bottom: 7),
          child: Icon(
            Icons.minimize,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SettingsButton extends StatelessWidget {
  SettingsButton({super.key, required this.onSettingsTap});

  VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 30,
      child: MaterialButton(
        hoverColor: BLUE,
        onPressed: () {
          onSettingsTap();
        },
        child: Transform.rotate(
          angle: 90 * pi / 180,
          child: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

class CloseWindowButton extends StatelessWidget {
  const CloseWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 30,
      child: MaterialButton(
        hoverColor: BLUE,
        onPressed: () {
          appWindow.close();
        },
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
