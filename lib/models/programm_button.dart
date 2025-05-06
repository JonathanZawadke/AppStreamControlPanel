import 'dart:typed_data';
import 'package:appstream_tool/functions/write_log.dart';
import 'package:flutter/material.dart';
import 'package:appstream_tool/constant.dart';
import 'package:http/http.dart' as http;

class ProgrammButton extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  final String image;
  final bool initialIsSelected;

  const ProgrammButton({
    super.key,
    required this.name,
    required this.onTap,
    required this.image,
    required this.initialIsSelected,
  });

  @override
  State<ProgrammButton> createState() => _ProgrammButtonState();
}

class _ProgrammButtonState extends State<ProgrammButton> {
  late bool isSelected;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialIsSelected;
    loadImage();
  }

  @override
  void didUpdateWidget(ProgrammButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsSelected != widget.initialIsSelected) {
      setState(() {
        isSelected = widget.initialIsSelected;
      });
    }
  }

  Future<void> loadImage() async {
    try {
      final response = await http.get(Uri.parse(
          "https://download.mentz-services.net/appstream_tool/icons/${widget.image}"));
      if (response.statusCode == 200) {
        setState(() {
          imageBytes = response.bodyBytes;
        });
      } else {
        wirteLog('[Error] Failed to load image ${widget.image}');
      }
    } catch (e) {
      wirteLog('[Error] Failed to load image ${widget.image} ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(BORDER_RADIUS),
      child: InkWell(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
        hoverColor: YELLOW_HOVER,
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
          widget.onTap();
        },
        child: Container(
          height: 76,
          width: 175,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BORDER_RADIUS),
            border: isSelected
                ? Border.all(width: 3, color: BLUE)
                : Border.all(width: 3, color: Colors.transparent),
            gradient: isSelected
                ? const LinearGradient(
                    stops: [.5, .5],
                    begin: Alignment(1.5, 0),
                    end: Alignment(1.1, 1),
                    colors: [
                      BLUE,
                      Colors.transparent,
                    ],
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: imageBytes == null
                            ? const CircularProgressIndicator()
                            : Image.memory(imageBytes!),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 110,
                        child: Text(
                          widget.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                isSelected
                    ? const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
