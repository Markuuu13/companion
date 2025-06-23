import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NoSchedule extends StatelessWidget {
  const NoSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/calendar.json',
              repeat: true,
              width: 200,
              height: 200,
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
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
      ),
    );
  }
}
