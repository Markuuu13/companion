import 'dart:async';
import 'package:companion/screens/other_pages/ai_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AiAnalyzeLoading extends StatefulWidget {
  final String title;
  final String? description;
  final String subject;
  final String deadlineDate;
  final String deadlineTime;
  final String priorityLevel;
  final String selectedTileColor;
  const AiAnalyzeLoading({
    super.key,
    required this.title,
    this.description,
    required this.subject,
    required this.deadlineDate,
    required this.deadlineTime,
    required this.priorityLevel,
    required this.selectedTileColor,
  });

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

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % messages.length;
      });
    });

    Future.delayed(const Duration(seconds: 8), () {
      _timer?.cancel();
      if (mounted) {
        Get.off(
          () => AiSuggestion(
            title: widget.title,
            description: widget.description,
            subject: widget.subject,
            deadlineDate: widget.deadlineDate,
            deadlineTime: widget.deadlineTime,
            priorityLevel: widget.priorityLevel,
            selectedTileColor: widget.selectedTileColor,
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('📦 AI Analyze Loading Received:');
    print('Title: ${widget.title}');
    print('Description: ${widget.description}');
    print('Subject: ${widget.subject}');
    print('Deadline Date: ${widget.deadlineDate}');
    print('Deadline Time: ${widget.deadlineTime}');
    print('Priority Level: ${widget.priorityLevel}');
    print('Selected Tile Color: ${widget.selectedTileColor}');
    startTimer();
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
            Lottie.asset(
              'assets/animations/analyzing.json',
              repeat: true,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
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
