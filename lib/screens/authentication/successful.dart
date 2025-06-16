import 'package:companion/splash/splash_screen_logged.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants.dart';
import '../../splash/splash_screen.dart';

class SuccessfullyVerified extends StatefulWidget {
  const SuccessfullyVerified({super.key});

  @override
  State<SuccessfullyVerified> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SuccessfullyVerified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/success_animations.json',
                repeat: true,
                width: 150,
                height: 150,
              ),
              Text(
                "Account Created Successfully",
                style: GoogleFonts.workSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Get.offAll(SplashScreen()),
                child: Text(
                  "Go back to Login",
                  style: GoogleFonts.workSans(
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    decorationColor: mainColor,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
