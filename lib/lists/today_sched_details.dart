import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../service/schedule_service.dart';

class TodayScheduleDetails extends StatefulWidget {
  final Map<String, dynamic>? scheduleDetails;
  const TodayScheduleDetails({super.key, required this.scheduleDetails});

  @override
  State<TodayScheduleDetails> createState() => _TodayScheduleDetailsState();
}

class _TodayScheduleDetailsState extends State<TodayScheduleDetails> {
  final ScheduleService updateScheduleStatus = ScheduleService();

  void updateSched() async {
    final id = widget.scheduleDetails?['schedule_id'];
    print("Attempting to update schedule with ID: $id");

    if (id == null) {
      showErrorToast(context, "Invalid schedule ID");
      return;
    }

    await updateScheduleStatus.updateScheduleStatus(
      context: context,
      scheduleId: id,
      status: 2,
    );
  }

  String formatDateTime(String date, String time) {
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse("$date $time");
      return DateFormat("MM-dd-yyyy hh:mm a").format(dateTime);
    } catch (e) {
      return "$date $time"; // fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete, color: red),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.scheduleDetails!['title']}",
              style: GoogleFonts.workSans(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Description",
              style: GoogleFonts.workSans(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.scheduleDetails!['description'].isNotEmpty
                  ? "${widget.scheduleDetails!['description']}"
                  : "No description",
              style: GoogleFonts.workSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Subject/Course",
              style: GoogleFonts.workSans(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${widget.scheduleDetails!['subject']}",
              style: GoogleFonts.workSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Deadline of the Task/s",
              style: GoogleFonts.workSans(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatDateTime(
                widget.scheduleDetails!['deadlineDate'],
                widget.scheduleDetails!['deadlineTime'],
              ),
              style: GoogleFonts.workSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "When to do the task/s?",
              style: GoogleFonts.workSans(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatDateTime(
                widget.scheduleDetails!['deadlineDate'],
                widget.scheduleDetails!['deadlineTime'],
              ),
              style: GoogleFonts.workSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: updateSched,
                  style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                  child: Text(
                    'Do this Task',
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: Text(
                    'Mark as done',
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
