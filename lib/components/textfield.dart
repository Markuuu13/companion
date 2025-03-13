import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  const CustomTextField({
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
        decoration: InputDecoration(labelText: labeltext),
      ),
    );
  }
}
