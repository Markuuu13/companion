import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
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

  bool isManualSched = true;
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    subjController.dispose();
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
                      color: mainColor,
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
              AddSchedTxtField(
                txtLabel: "Title",
                hintText: 'Enter the title',
                controller: titleController,
              ),
              //Description
              AddSchedTxtField(
                txtLabel: "Description",
                hintText: 'Description about your plan',
                controller: descController,
              ),
              //Subject-Course
              AddSchedTxtField(
                txtLabel: "Subject/Course",
                hintText: 'On what subject/course?',
                controller: subjController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
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
