import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../components/add_sched_txt.dart';
import '../../service/schedule_service.dart';
import '../../splash/ai_analyze_loading.dart';

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
  Color? selectedTileColor;
  bool isAlarmEnabled = false;
  List<String> alarmOffsets = [
    "At date scheduled",
    "5 minutes before",
    "10 minutes before",
    "30 minutes before",
    "1 hour before",
  ];

  String selectedAlarmOffset = "At date scheduled";

  Future<void> showConfettiDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(); // close dialog after 2 seconds
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 200,
            width: 200,
            child: Lottie.asset('assets/animations/confetti.json'),
          ),
        );
      },
    );
  }

  Future<void> _onAddSchedule() async {
    var userId = box.read('userid');

    if (userId == null) {
      print("Error: User is not logged in. User ID is null.");
      Get.snackbar("Error", "User not logged in. Please login to proceed.");
      return;
    }
    final hexColor =
        selectedTileColor != null
            ? '#${selectedTileColor!.value.toRadixString(16).padLeft(8, '0').toUpperCase()}'
            : '';
    if (titleController.text.isEmpty &&
        subjController.text.isEmpty &&
        deadlineDateController.text.isEmpty &&
        deadlineTimeController.text.isEmpty &&
        scheduleDateController.text.isEmpty &&
        scheduleTimeController.text.isEmpty) {
      showErrorToast(context, "Please fill in all fields.");
      return;
    }
    if (selectedTileColor == null) {
      showErrorToast(context, "Please select a tile color.");
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
        tileColor: hexColor,
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
        selectedTileColor = null;
      });

      showSuccessToast(context, "Schedule added successfully!");
      await showConfettiDialog(context);
    } catch (e) {
      print("Error adding schedule: $e");
      showErrorToast(context, "Failed to add schedule. Please try again.");
    }
  }

  Future<void> autoSchedule() async {
    var userId = box.read('userid');

    // Check if userId is null
    if (userId == null) {
      print("Error: User is not logged in. User ID is null.");
      // You can display a snackbar or a dialog here to notify the user
      Get.snackbar("Error", "User not logged in. Please login to proceed.");
      return;
    }
    final hexColor =
        selectedTileColor != null
            ? '#${selectedTileColor!.value.toRadixString(16).padLeft(8, '0').toUpperCase()}'
            : '';
    if (titleController.text.isEmpty &&
        subjController.text.isEmpty &&
        deadlineDateController.text.isEmpty &&
        deadlineTimeController.text.isEmpty) {
      showErrorToast(context, "Please fill in all fields.");
      return;
    }
    if (selectedTileColor == null) {
      showErrorToast(context, "Please select a tile color.");
      return;
    }
    try {
      // Call the service to add the schedule
      Get.to(
        () => AiAnalyzeLoading(
          title: titleController.text.trim(),
          description: descController.text.trim(),
          subject: subjController.text.trim(),
          deadlineDate: deadlineDateController.text.trim(),
          deadlineTime: deadlineTimeController.text.trim(),
          priorityLevel: selectedPriorityLevel ?? '',
          selectedTileColor: hexColor,
        ),
      );
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
        subjController.text.isNotEmpty &&
        deadlineDateController.text.isNotEmpty &&
        deadlineTimeController.text.isNotEmpty &&
        scheduleDateController.text.isEmpty &&
        scheduleTimeController.text.isEmpty &&
        selectedPriorityLevel != null;
    final bool isManualSchedAvail =
        titleController.text.isNotEmpty &&
        subjController.text.isNotEmpty &&
        deadlineDateController.text.isNotEmpty &&
        deadlineTimeController.text.isNotEmpty &&
        scheduleDateController.text.isNotEmpty &&
        scheduleTimeController.text.isNotEmpty;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
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
                      "Title of the Task",
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\s]'),
                      ),
                      LengthLimitingTextInputFormatter(60),
                    ],
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
                          "(recommended for Auto Schedule)",
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
                    hintText: 'What does this task all about? (optional)',
                    controller: descController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\s]'),
                      ),
                      LengthLimitingTextInputFormatter(300),
                    ],
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\s]'),
                      ),
                      LengthLimitingTextInputFormatter(30),
                    ],
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
                      Icon(FontAwesomeIcons.calendar, color: red),
                      SizedBox(width: 10),
                      Expanded(
                        child: AddSchedTxtField(
                          isReadOnly: true,
                          onTap: () => deadlinePickDate(),
                          hintText: 'Date',
                          controller: deadlineDateController,
                        ),
                      ),

                      SizedBox(width: 20),
                      Expanded(
                        child: AddSchedTxtField(
                          isReadOnly: true,
                          onTap: () => deadlinePickTime(),
                          hintText: 'Time',
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
                          "When to do the Task?",
                          style: GoogleFonts.workSans(
                            color: mainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        Tooltip(
                          message:
                              "Auto Schedule will not available if the \ndate schedule is set.",
                          child: Icon(
                            Icons.info_rounded,
                            color: mainColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "(Long press to view)",
                            style: GoogleFonts.workSans(
                              color: mainColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.calendarCheck, color: green),
                      SizedBox(width: 10),
                      Expanded(
                        child: AddSchedTxtField(
                          isReadOnly: true,
                          onTap: () => schedulePickDate(),
                          hintText: 'Date',
                          controller: scheduleDateController,
                        ),
                      ),

                      SizedBox(width: 20),
                      Expanded(
                        child: AddSchedTxtField(
                          isReadOnly: true,
                          onTap: () => schedulePickTime(),
                          hintText: 'Time',
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
                  if (scheduleDateController.text.trim().isEmpty &&
                      scheduleTimeController.text.trim().isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  SizedBox(height: 20),
                  Text(
                    "Color of schedule tile",
                    style: GoogleFonts.workSans(
                      color: mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      buildColorTile(color: mainColor),
                      buildColorTile(color: blue),
                      buildColorTile(color: red),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.alarm, color: mainColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Set Alarm',
                          style: GoogleFonts.workSans(
                            fontSize: 18,
                            color: mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Switch(
                        value: isAlarmEnabled,
                        onChanged: (value) {
                          setState(() {
                            isAlarmEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (isAlarmEnabled)
                    Row(
                      children: [
                        Text(
                          "Alarm Offset:",
                          style: GoogleFonts.workSans(
                            color: mainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedAlarmOffset,
                          onChanged: (value) {
                            setState(() {
                              selectedAlarmOffset = value!;
                            });
                          },
                          items:
                              alarmOffsets
                                  .map(
                                    (offset) => DropdownMenuItem(
                                      value: offset,
                                      child: Text(
                                        offset,
                                        style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/icons/gemini.png',
                        width: 30,
                        height: 30,
                        color: Colors.blueAccent,
                      ),
                      Expanded(
                        child: Text(
                          "Can't decide when to do it? Let AI suggest a good time for you! Click the Auto Schedule button below.",
                          style: GoogleFonts.workSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isManualSchedAvail)
                          Column(
                            children: [
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
                              ),
                            ],
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
                            onPressed: autoSchedule,
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
    try {
      final parts = deadlineDateController.text.split('-');
      final int month = int.parse(parts[0]);
      final int day = int.parse(parts[1]);
      final int year = int.parse(parts[2]);
      final deadlineDate = DateTime(year, month, day);

      final DateTime picked =
          await showDatePicker(
            context: context,
            initialDate:
                DateTime.now().isAfter(deadlineDate)
                    ? deadlineDate
                    : DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: deadlineDate,
          ) ??
          DateTime.now();

      if (picked != null) {
        String formattedDate = "${picked.month}-${picked.day}-${picked.year}";
        setState(() {
          scheduleDateController.text = formattedDate;
        });
      }
    } catch (e) {
      print(e.toString());
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

  Widget buildColorTile({required Color color}) {
    final bool isSelected = selectedTileColor == color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTileColor = color;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 3,
            ),
          ),
          child:
              isSelected
                  ? Center(
                    child: Icon(Icons.check, color: Colors.white, size: 25),
                  )
                  : null,
        ),
      ),
    );
  }

  DateTime combineDateTime(String dateStr, String timeStr) {
    final fullDateTimeStr = "$dateStr $timeStr";
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(fullDateTimeStr);
  }

  tz.TZDateTime toTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }
}
