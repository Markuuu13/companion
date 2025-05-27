import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextfieldRegister extends StatelessWidget {
  final String labeltext;
  // final String? hintText;
  final TextEditingController controller;
  final bool? obscureText;
  const TextfieldRegister({
    super.key,
    required this.labeltext,
    required this.controller,
    this.obscureText,
    // this.hintText,
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          style: GoogleFonts.workSans(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            labelText: labeltext,
            // hintText: hintText,
            border: InputBorder.none,
            labelStyle: GoogleFonts.workSans(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
