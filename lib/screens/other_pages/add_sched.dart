import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/add_sched_txt.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController subjController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  bool isManualSched = true;
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    subjController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  Future<void> pickDate() async {
    final DateTime picked =
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();

    if (picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month}-${picked.day}-${picked.hour}:${picked.minute}";
      setState(() {
        dateController.text = formattedDate;
      });
    }
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      String formattedTime = picked.format(context);
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Schedule",
                    style: GoogleFonts.workSans(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.cancel, color: Colors.red),
                  ),
                ],
              ),
              Text(
                "What's your plan?",
                style: GoogleFonts.workSans(
                  color: Colors.grey[500],
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 50),
              // Title
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "Title",
                  style: GoogleFonts.workSans(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AddSchedTxtField(
                txtLabel: "Title",
                hintText: 'Enter the title',
                controller: titleController,
              ),
              //Description
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "Description",
                  style: GoogleFonts.workSans(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AddSchedTxtField(
                txtLabel: "Description",
                hintText: 'Description about your plan',
                controller: descController,
              ),
              //Subject-Course
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "Subject/Course",
                  style: GoogleFonts.workSans(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AddSchedTxtField(
                txtLabel: "Subject/Course",
                hintText: 'On what subject/course?',
                controller: subjController,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  "Deadline of the Task",
                  style: GoogleFonts.workSans(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(FontAwesomeIcons.calendar, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: AddSchedTxtField(
                      txtLabel: "Deadline of the Task",
                      isReadOnly: true,
                      onTap: () => pickDate(),
                      hintText: 'Choose the date...',
                      controller: dateController,
                    ),
                  ),

                  SizedBox(width: 20),
                  Expanded(
                    child: AddSchedTxtField(
                      isReadOnly: true,
                      onTap: () => pickTime(),
                      hintText: 'Choose the time...',
                      controller: timeController,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Row(
                  children: [
                    Text(
                      "Date Schedule",
                      style: GoogleFonts.workSans(
                        color: mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message:
                          'Auto-scheduling is not available right now.\nYou can use manual mode to plan your schedule.',
                      padding: EdgeInsets.all(10),

                      textStyle: GoogleFonts.workSans(color: Colors.black),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        FontAwesomeIcons.solidCircleQuestion,
                        color: mainColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "(Long press to view)",
                      style: GoogleFonts.workSans(
                        color: mainColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(FontAwesomeIcons.calendar, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: AddSchedTxtField(
                      txtLabel: "Deadline of the Task",
                      isReadOnly: true,
                      onTap: () => pickDate(),
                      hintText: 'Choose the date...',
                      controller: dateController,
                    ),
                  ),

                  SizedBox(width: 20),
                  Expanded(
                    child: AddSchedTxtField(
                      isReadOnly: true,
                      onTap: () => pickTime(),
                      hintText: 'Choose the time...',
                      controller: timeController,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Add Schedule",
                        style: GoogleFonts.workSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    isManualSched
                        ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: autoSchedNotAvail,
                          ),
                          onPressed: () {
                            setState(() {
                              isManualSched = false;
                            });
                          },
                          child: Text(
                            "Auto Schedule",
                            style: GoogleFonts.workSans(
                              color: autoSchedNotAvailTxt,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                          ),
                          onPressed: () {
                            setState(() {
                              isManualSched = true;
                            });
                          },
                          child: Text(
                            "Auto Schedule",
                            style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
