import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusContainer extends StatelessWidget {
  final Color color;
  final String text;
  const StatusContainer({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.workSans(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
