import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../components/add_sched_txt.dart';
import '../../service/schedule_service.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController subjController = TextEditingController();
  final TextEditingController deadlineDateController = TextEditingController();
  final TextEditingController deadlineTimeController = TextEditingController();
  final TextEditingController scheduleDateController = TextEditingController();
  final TextEditingController scheduleTimeController = TextEditingController();

  final showtooltip = SuperTooltipController();
  final box = GetStorage();
  String? selectedPriorityLevel;

  Future<void> _onAddSchedule() async {
    var userId = box.read('userid');

    // Check if userId is null
    if (userId == null) {
      print("Error: User is not logged in. User ID is null.");
      // You can display a snackbar or a dialog here to notify the user
      Get.snackbar("Error", "User not logged in. Please login to proceed.");
      return;
    }

    if (titleController.text.isEmpty &&
        subjController.text.isEmpty &&
        deadlineDateController.text.isEmpty &&
        deadlineTimeController.text.isEmpty &&
        scheduleDateController.text.isEmpty &&
        scheduleTimeController.text.isEmpty &&
        selectedPriorityLevel == null) {
      showErrorToast(context, "Please fill in all fields.");
      return;
    }
    try {
      // Call the service to add the schedule
      await ScheduleService().addScheduleManual(
        userId: userId,
        title: titleController.text.trim(),
        description: descController.text.trim(),
        subject: subjController.text.trim(),
        deadlineDate: deadlineDateController.text.trim(),
        deadlineTime: deadlineTimeController.text.trim(),
        scheduleDate: scheduleDateController.text.trim(),
        scheduleTime: scheduleTimeController.text.trim(),
        priorityLevel: selectedPriorityLevel!,
      );

      // Clear the selected priority level
      setState(() {
        titleController.clear();
        descController.clear();
        subjController.clear();
        deadlineDateController.clear();
        deadlineTimeController.clear();
        scheduleDateController.clear();
        scheduleTimeController.clear();
        selectedPriorityLevel = null;
      });

      showSuccessToast(context, "Schedule added successfully!");
    } catch (e) {
      print("Error adding schedule: $e");
      showErrorToast(context, "Failed to add schedule. Please try again.");
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    subjController.dispose();
    deadlineDateController.dispose();
    deadlineTimeController.dispose();
    scheduleDateController.dispose();
    scheduleTimeController.dispose();
    selectedPriorityLevel = null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAutoSchedAvailable =
        titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        subjController.text.isNotEmpty &&
        deadlineDateController.text.isNotEmpty &&
        deadlineTimeController.text.isNotEmpty &&
        scheduleDateController.text.isEmpty &&
        scheduleTimeController.text.isEmpty &&
        selectedPriorityLevel != null;
    final bool isManualSchedAvail =
        titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        subjController.text.isNotEmpty &&
        deadlineDateController.text.isNotEmpty &&
        deadlineTimeController.text.isNotEmpty &&
        scheduleDateController.text.isNotEmpty &&
        scheduleTimeController.text.isNotEmpty &&
        selectedPriorityLevel != null;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page Title
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
                SizedBox(height: 15),

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
                  hintText: 'Enter the title',
                  controller: titleController,
                ),

                //Description
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 20),
                  child: Row(
                    children: [
                      Text(
                        "Description",
                        style: GoogleFonts.workSans(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "(optional)",
                        style: GoogleFonts.workSans(
                          color: mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                AddSchedTxtField(
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
                  hintText: 'On what subject/course?',
                  controller: subjController,
                ),

                // Deadline of the Task
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
                        isReadOnly: true,
                        onTap: () => deadlinePickDate(),
                        hintText: 'Choose the date...',
                        controller: deadlineDateController,
                      ),
                    ),

                    SizedBox(width: 20),
                    Expanded(
                      child: AddSchedTxtField(
                        isReadOnly: true,
                        onTap: () => deadlinePickTime(),
                        hintText: 'Choose the time...',
                        controller: deadlineTimeController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      deadlineDateController.clear();
                      deadlineTimeController.clear();
                    });
                  },
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(Icons.delete, color: red),
                      Text(
                        "Clear date and time",
                        style: GoogleFonts.workSans(
                          color: red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                      GestureDetector(
                        onTap: () async {
                          
                        },
                        child: SuperTooltip(
                          onShow: () {
                            showtooltip.showTooltip();
                          },
                          onHide: () {
                            showtooltip.hideTooltip();
                          },
                          elevation: 0,
                          showBarrier: false,
                          controller: showtooltip,
                          content: const Text(
                            "When you set a schedule manually, ",
                            softWrap: true,
                            style: TextStyle(color: Colors.black),
                          ),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
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
                        isReadOnly: true,
                        onTap: () => schedulePickDate(),
                        hintText: 'Choose the date...',
                        controller: scheduleDateController,
                      ),
                    ),

                    SizedBox(width: 20),
                    Expanded(
                      child: AddSchedTxtField(
                        isReadOnly: true,
                        onTap: () => schedulePickTime(),
                        hintText: 'Choose the time...',
                        controller: scheduleTimeController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      scheduleDateController.clear();
                      scheduleTimeController.clear();
                    });
                  },
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(Icons.delete, color: red),
                      Text(
                        "Clear date and time",
                        style: GoogleFonts.workSans(
                          color: red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Priority Level",
                    style: GoogleFonts.workSans(
                      color: mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio(
                      value: "Low",
                      groupValue: selectedPriorityLevel,
                      onChanged: (value) {
                        setState(() {
                          selectedPriorityLevel = value;
                        });
                      },
                    ),
                    Text('Low'),
                    Radio(
                      value: "Medium",
                      groupValue: selectedPriorityLevel,
                      onChanged: (value) {
                        setState(() {
                          selectedPriorityLevel = value;
                        });
                      },
                    ),
                    Text('Medium'),
                    Radio(
                      value: "High",
                      groupValue: selectedPriorityLevel,
                      onChanged: (value) {
                        setState(() {
                          selectedPriorityLevel = value;
                        });
                      },
                    ),
                    Text('High'),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isManualSchedAvail)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                          ),
                          onPressed: _onAddSchedule,
                          child: Text(
                            "Add Schedule",
                            style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: manualEditNotAvail,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Add Schedule",
                            style: GoogleFonts.workSans(
                              color: manualEditNotAvailTxt,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      SizedBox(width: 20),

                      if (isAutoSchedAvailable)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Auto Schedule",
                            style: GoogleFonts.workSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: autoSchedNotAvail,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Auto Schedule",
                            style: GoogleFonts.workSans(
                              color: autoSchedNotAvailTxt,
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
      ),
    );
  }

  Future<void> deadlinePickDate() async {
    final DateTime picked =
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();

    if (picked != null) {
      String formattedDate = "${picked.month}-${picked.day}-${picked.year}";
      setState(() {
        deadlineDateController.text = formattedDate;
      });
    }
  }

  Future<void> deadlinePickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      String formattedTime = picked.format(context);
      setState(() {
        deadlineTimeController.text = formattedTime;
      });
    }
  }

  Future<void> schedulePickDate() async {
    final DateTime picked =
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        ) ??
        DateTime.now();

    if (picked != null) {
      String formattedDate = "${picked.month}-${picked.day}-${picked.year}";
      setState(() {
        scheduleDateController.text = formattedDate;
      });
    }
  }

  Future<void> schedulePickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      String formattedTime = picked.format(context);
      setState(() {
        scheduleTimeController.text = formattedTime;
      });
    }
  }
}
