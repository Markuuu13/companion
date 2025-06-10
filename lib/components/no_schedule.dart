import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoSchedule extends StatelessWidget {
  const NoSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/addsched.png', width: 140, height: 140),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Text(
              'No Schedule for today, to add a schedule, click the + button at the top right corner.',
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                fontSize: 14,
                color: Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
