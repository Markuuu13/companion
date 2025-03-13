import 'package:flutter/material.dart';

class TextfieldRegister extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  const TextfieldRegister({
    super.key,
    required this.labeltext,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            // Normal state (not focused)
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            // When the TextField is clicked
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
