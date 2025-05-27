import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          color: mainColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          controller: controller,
          style: GoogleFonts.workSans(color: Colors.white, fontSize: 16),
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            labelText: labeltext,
            border: InputBorder.none,
            labelStyle: GoogleFonts.workSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
