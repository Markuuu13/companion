import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoSchedule extends StatelessWidget {
  const NoSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("assets/addsched.png"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'To add schedule, click the',
                style: GoogleFonts.workSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.add, color: completeColor, size: 35),
              Text('button to add schedule'),
            ],
          ),
        ],
      ),
    );
  }
}
