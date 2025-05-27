import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labeltext;
  final Icon icon;
  final TextEditingController controller;
  final bool isObscure;
  const CustomTextField({
    super.key,
    required this.labeltext,
    required this.controller,
    required this.icon,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          icon: icon,
          labelText: labeltext,
          contentPadding: EdgeInsets.only(left: 5, bottom: 10),
        ),
      ),
    );
  }
}
