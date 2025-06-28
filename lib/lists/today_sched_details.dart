import 'dart:async';

import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final ScheduleService scheduleService = ScheduleService();
  bool isDoingTask = false;
  Timer? countdownTimer;
  Duration remainingTime = Duration.zero;
  bool showCountdown = false;
  bool missedDeadline = false;
  void startCountdownToDeadline() {
    final deadline = DateFormat("yyyy-MM-dd HH:mm").parse(
      "${widget.scheduleDetails!['deadlineDate']} ${widget.scheduleDetails!['deadlineTime']}",
    );
    final now = DateTime.now();
    final diff = deadline.difference(now);

    setState(() {
      remainingTime = diff;
      showCountdown = true;
    });

    countdownTimer?.cancel(); // Stop any previous timer
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds <= 0) {
        timer.cancel();
        updateSchedMissed();
        setState(() {
          remainingTime = Duration.zero;
          missedDeadline = true; // Show message flag
        });
      } else {
        setState(() {
          remainingTime = remainingTime - Duration(seconds: 1);
        });
      }
    });
  }

  void updateSchedPending(String message) async {
    final id = widget.scheduleDetails!['schedule_id'];

    if (id == null) {
      showErrorToast(context, "Invalid schedule ID");
      return;
    }

    await scheduleService.updateScheduleStatus(
      context: context,
      scheduleId: id,
      status: 2,
      message: message,
    );

    setState(() {
      widget.scheduleDetails!['status_id'] = 2;
    });
  }

  void updateSchedCompleted(String message) async {
    final id = widget.scheduleDetails!['schedule_id'];

    if (id == null) {
      showErrorToast(context, "Invalid schedule ID");
      return;
    }

    await scheduleService.updateScheduleStatus(
      context: context,
      scheduleId: id,
      status: 3,
      message: message,
    );

    countdownTimer?.cancel();
    final box = GetStorage();
    box.remove("task_$id");

    setState(() {
      widget.scheduleDetails!['status_id'] = 3;
      showCountdown = false;
      remainingTime = Duration.zero;
    });
  }

  void updateSchedMissed() async {
    final id = widget.scheduleDetails!['schedule_id'];

    if (id == null) {
      showErrorToast(context, "Invalid schedule ID");
      return;
    }

    await scheduleService.updateScheduleStatus(
      context: context,
      scheduleId: id,
      status: 4,
    );

    setState(() {
      widget.scheduleDetails!['status_id'] = 4;
    });
  }

  void confirmationDelete() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Task"),
            content: Text("Are you sure you want to delete this task?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // close dialog
                  await scheduleService.deleteTask(
                    context,
                    scheduleId: widget.scheduleDetails!['schedule_id'],
                  );
                  Get.back(); // close detail page
                  showSuccessToast(context, "Task deleted successfully");
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  String formatDateTime(String date, String time) {
    try {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm").parse("$date $time");
      return DateFormat("MMMM d yyyy · hh:mm a").format(dateTime);
      // Example output: June 25 2025 · 12:00 PM
    } catch (e) {
      return "$date $time"; // fallback if parsing fails
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    final taskId = widget.scheduleDetails!['schedule_id'];
    final startTimeString = box.read("task_$taskId");

    final deadline = DateFormat("yyyy-MM-dd HH:mm").parse(
      "${widget.scheduleDetails!['deadlineDate']} ${widget.scheduleDetails!['deadlineTime']}",
    );
    final now = DateTime.now();

    if (now.isAfter(deadline) && widget.scheduleDetails!['status_id'] == 2) {
      missedDeadline = true;
      showCountdown = false;
    } else if (startTimeString != null &&
        widget.scheduleDetails!['status_id'] == 2) {
      // Only start countdown if still valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startCountdownToDeadline();
      });
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
              onPressed: confirmationDelete,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${widget.scheduleDetails!['title']}",
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize:
                          widget.scheduleDetails!['title'].length > 20
                              ? 24
                              : 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        missedDeadline
                            ? mainColor
                            : widget.scheduleDetails!['status_id'] == 1
                            ? red
                            : widget.scheduleDetails!['status_id'] == 2
                            ? orange
                            : widget.scheduleDetails!['status_id'] == 3
                            ? green
                            : widget.scheduleDetails!['status_id'] == 4
                            ? mainColor
                            : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    missedDeadline
                        ? "Missed"
                        : widget.scheduleDetails!['status_id'] == 1
                        ? "Not Started"
                        : widget.scheduleDetails!['status_id'] == 2
                        ? "In Progress"
                        : widget.scheduleDetails!['status_id'] == 3
                        ? "Completed"
                        : widget.scheduleDetails!['status_id'] == 4
                        ? "Missed"
                        : "Unknown",
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
            Row(
              children: [
                Icon(FontAwesomeIcons.calendar, color: red),
                SizedBox(width: 10),
                Text(
                  formatDateTime(
                    widget.scheduleDetails!['deadlineDate'],
                    widget.scheduleDetails!['deadlineTime'],
                  ),
                  style: GoogleFonts.workSans(
                    color: red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
            Row(
              children: [
                Icon(FontAwesomeIcons.calendarCheck, color: green),
                SizedBox(width: 10),
                Text(
                  formatDateTime(
                    widget.scheduleDetails!['dateScheduled'],
                    widget.scheduleDetails!['dateScheduledTime'],
                  ),
                  style: GoogleFonts.workSans(
                    color: green,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Spacer(),
            Column(
              children: [
                if (showCountdown && !missedDeadline)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Time Remaining: ${formatDuration(remainingTime)}",
                        style: GoogleFonts.workSans(
                          color: red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.scheduleDetails!['status_id'] == 1)
                      ElevatedButton(
                        onPressed: () {
                          updateSchedPending(
                            "You started to do the task! Stay focused and be mindful of the deadline.",
                          );
                          final box = GetStorage();
                          final taskId = widget.scheduleDetails!['schedule_id'];
                          box.write(
                            "task_$taskId",
                            DateTime.now().toIso8601String(),
                          );

                          startCountdownToDeadline();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: Text(
                          'Do this Task',
                          style: GoogleFonts.workSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (!missedDeadline &&
                        widget.scheduleDetails!['status_id'] == 2)
                      ElevatedButton(
                        onPressed: () {
                          updateSchedCompleted(
                            "Great Job! You completed your task.",
                          );
                        },
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
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "$hours hrs $minutes min $seconds sec";
  }
}
