import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class AddSchedTxtField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String txtLabel;
  const AddSchedTxtField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.txtLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 20),
          child: Text(
            txtLabel,
            style: GoogleFonts.workSans(
              color: mainColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 1,
                blurRadius: 1,
                color: Colors.black.withAlpha(50),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500])
            ),
          ),
        ),
      ],
    );
  }
}
