import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class AddSchedTxtField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? txtLabel;
  final bool? isReadOnly;
  final VoidCallback? onTap;
  const AddSchedTxtField({
    super.key,
    required this.hintText,
    required this.controller,
    this.txtLabel = " ",
    this.isReadOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        readOnly: isReadOnly!,
        onTap: isReadOnly! ? onTap : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
