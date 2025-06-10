import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSchedTxtField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? isReadOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLines;
  const AddSchedTxtField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isReadOnly = false,
    this.onTap,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: double.infinity,
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
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ),
    );
  }
}
