import 'dart:async';
import 'package:companion/screens/other_pages/ai_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; 

class AiAnalyzeLoading extends StatefulWidget {
  const AiAnalyzeLoading({super.key});

  @override
  State<AiAnalyzeLoading> createState() => _AiAnalyzeLoadingState();
}

class _AiAnalyzeLoadingState extends State<AiAnalyzeLoading> {
  final List<String> messages = [
    "AI Analyzing...",
    "Gathering data...",
    "Evaluating priorities...",
    "Matching time slots...",
    "Optimizing schedule...",
    "Learning your habits...",
    "Almost done...",
  ];

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % messages.length;
      });
    });

    Future.delayed(const Duration(seconds: 8), () {
      _timer?.cancel();
      if (mounted) {
        Get.off(() => const AiSuggestion(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.deepPurple,
              strokeWidth: 4,
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder:
                  (Widget child, Animation<double> animation) =>
                      FadeTransition(opacity: animation, child: child),
              child: Text(
                messages[currentIndex],
                key: ValueKey(messages[currentIndex]),
                style: GoogleFonts.workSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
