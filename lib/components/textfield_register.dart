import 'package:flutter/material.dart';

class TextfieldRegister extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final bool? obscureText;
  const TextfieldRegister({
    super.key,
    required this.labeltext,
    required this.controller,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            labelText: labeltext,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
