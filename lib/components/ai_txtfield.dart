import 'package:flutter/material.dart';

class AiTxtfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AiTxtfield({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText, border: InputBorder.none),
      ),
    );
  }
}
