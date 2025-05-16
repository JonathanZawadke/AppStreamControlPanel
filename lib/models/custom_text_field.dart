import 'package:appstreamcontrolpanel/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:appstreamcontrolpanel/constant.dart';

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
          hintText: "Suche...",
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
          searchString = value;
          widget.onChanged();
        },
      ),
    );
  }
}
