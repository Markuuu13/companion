import 'package:companion/constants.dart';
import 'package:companion/service/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IncomingSchedDetails extends StatefulWidget {
  final Map<String, dynamic>? scheduleDetails;
  const IncomingSchedDetails({super.key, required this.scheduleDetails});

  @override
  State<IncomingSchedDetails> createState() => _IncomingSchedDetailsState();
}

class _IncomingSchedDetailsState extends State<IncomingSchedDetails> {
  final ScheduleService scheduleService = ScheduleService();
  bool isDoingTask = false;

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

    setState(() {
      widget.scheduleDetails!['status_id'] = 3;
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
                          widget.scheduleDetails!['title'].length < 10 ? 25 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        widget.scheduleDetails!['status_id'] == 1
                            ? red
                            : widget.scheduleDetails!['status_id'] == 2
                            ? orange
                            : green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.scheduleDetails!['status_id'] == 1
                        ? "Not Started"
                        : widget.scheduleDetails!['status_id'] == 2
                        ? "In Progress"
                        : "Completed",
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
            //
          ],
        ),
      ),
    );
  }
}
