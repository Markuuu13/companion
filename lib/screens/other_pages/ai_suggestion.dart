import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../service/ai_service.dart';

class AiSuggestion extends StatefulWidget {
  final String title;
  final String? description;
  final String subject;
  final String deadlineDate;
  final String deadlineTime;
  final String priorityLevel;
  final String selectedTileColor;
  const AiSuggestion({
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
  State<AiSuggestion> createState() => _AiSuggestionState();
}

class _AiSuggestionState extends State<AiSuggestion> {
  final AIService aiService = AIService();
  final box = GetStorage();

  Map<String, dynamic>? suggestedSchedule;

  void getSuggestedSchedule() async {
    final userId = box.read('userid');

    final response = await aiService.getSuggestedSchedule(
      userId: userId, // Replace with actual user ID
      title: widget.title,
      description: widget.description,
      subject: widget.subject,
      deadlineDate: widget.deadlineDate,
      deadlineTime: widget.deadlineTime,
      priorityLevel: widget.priorityLevel,
    );

    setState(() {
      suggestedSchedule = response;
    });
    if (response != null) {
      print('Suggested Schedule: $response');
    } else {
      print('Failed to get suggested schedule');
    }
  }

  @override
  void initState() {
    super.initState();
    getSuggestedSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb,
                  color: const Color.fromARGB(255, 222, 200, 1),
                  size: 35,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    suggestedSchedule!['message'],
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.workSans(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            buildDeadlineOrScheduled(
              colorOfTitle: red,
              titleOfSection: "Your Task's Deadline",
              date: widget.deadlineDate,
              time: widget.deadlineTime,
            ),
            SizedBox(height: 40),
            buildDeadlineOrScheduled(
              colorOfTitle: green,
              titleOfSection: "Suggested Schedule to do the Task",
              date: formatDate(suggestedSchedule?['dateScheduled']),
              time: formatTime(suggestedSchedule?['dateScheduledTime']),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Icon(Icons.task, size: 30, color: Colors.black87),
                SizedBox(width: 10),
                Text(
                  "Task's Details",
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Title:",
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  widget.title,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Description:",
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  widget.description ?? "No description",
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Subject/Course:",
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  widget.subject,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.workSans(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: green),
                onPressed: () {},
                child: Text(
                  "Add this Schedule",
                  style: GoogleFonts.workSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget buildDeadlineOrScheduled({
    required Color colorOfTitle,
    required String titleOfSection,
    required String date,
    required String time,
  }) {
    return Column(
      children: [
        Text(
          titleOfSection,
          overflow: TextOverflow.clip,
          style: GoogleFonts.workSans(
            color: colorOfTitle,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, size: 30, color: colorOfTitle),
              SizedBox(width: 10),
              Text(
                date,
                overflow: TextOverflow.clip,
                style: GoogleFonts.workSans(
                  color: colorOfTitle,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_clock, size: 30, color: colorOfTitle),
              SizedBox(width: 10),
              Text(
                time,
                overflow: TextOverflow.clip,
                style: GoogleFonts.workSans(
                  color: colorOfTitle,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'Invalid date';
    try {
      final parsed = DateTime.parse(dateString); // Handles YYYY-MM-DD
      return DateFormat('MM-dd-yy').format(parsed); // e.g. 06-20-25
    } catch (e) {
      return 'Invalid date';
    }
  }

  String formatTime(String? timeString) {
    if (timeString == null) return 'Invalid time';
    try {
      final parsedTime = DateFormat(
        'HH:mm:ss',
      ).parse(timeString); // 24-hour input
      return DateFormat(
        'h:mma',
      ).format(parsedTime).toLowerCase(); // e.g. 5:00pm
    } catch (e) {
      return 'Invalid time';
    }
  }
}
