import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiSuggestion extends StatelessWidget {
  // final String title;
  // final String description;
  // final String subject;
  const AiSuggestion({
    super.key,
    // required this.title,
    // required this.description,
    // required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                    "Try to break down the research into smaller, manageable chunks.  Focus on one or two emerging technologies per day to avoid feeling overwhelmed!",
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
              date: '03-14-25',
              time: '11:59 PM',
            ),
            SizedBox(height: 40),
            buildDeadlineOrScheduled(
              colorOfTitle: green,
              titleOfSection: "Suggested Schedule to do the Task",
              date: '03-13-25',
              time: '10:00 AM',
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
            Text(
              "Title: Assignment #1",
              overflow: TextOverflow.clip,
              style: GoogleFonts.workSans(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Description: This is my assignment",
              overflow: TextOverflow.clip,
              style: GoogleFonts.workSans(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Subject/Course: ADET",
              overflow: TextOverflow.clip,
              style: GoogleFonts.workSans(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
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
}
