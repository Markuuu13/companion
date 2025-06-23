import 'dart:async';

import 'package:companion/screens/other_pages/add_sched.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuggestedSchedSucess extends StatefulWidget {
  const SuggestedSchedSucess({super.key});

  @override
  State<SuggestedSchedSucess> createState() => _SuggestedSchedSucessState();
}

class _SuggestedSchedSucessState extends State<SuggestedSchedSucess> {
  void startTimer() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Get.off(
          () => AddSchedule(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/analyzing.json',
              repeat: true,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
            Text(
              'Suggested Schedule Created Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
