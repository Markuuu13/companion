import 'package:companion/constants.dart';
import 'package:companion/service/schedule_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../lists/incoming_sched_details.dart';

class ViewIncomingSchedules extends StatefulWidget {
  final DateTime date; // e.g., "June 24"
  final List<dynamic>? incomingSchedules;
  final VoidCallback? onDataChanged;
  const ViewIncomingSchedules({
    super.key,
    required this.date,
    required this.incomingSchedules,
    this.onDataChanged,
  });

  @override
  State<ViewIncomingSchedules> createState() => _ViewIncomingSchedulesState();
}

class _ViewIncomingSchedulesState extends State<ViewIncomingSchedules> {
  Set<int> selectedTile = {};
  bool isClickedSelect = false;
  final ScheduleService scheduleService = ScheduleService();

  void toggleSelection(int id) {
    setState(() {
      if (selectedTile.contains(id)) {
        selectedTile.remove(id);
      } else {
        selectedTile.add(id);
      }
    });
  }

  Future<void> _confirmAndDeleteSelected() async {
    if (selectedTile.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete Schedules'),
            content: Text(
              'Are you sure you want to delete selected schedules?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await scheduleService.deleteMultipleSchedules(
        selectedTile.toList(),
      );

      if (success) {
        setState(() {
          widget.incomingSchedules?.removeWhere(
            (item) => selectedTile.contains(item['schedule_id']),
          );
          selectedTile.clear();
          isClickedSelect = false; // ✅ optional: exit selection mode
        });
        widget.onDataChanged?.call();
        showSuccessToast(context, "Deleted successfully!");
      } else {
        showErrorToast(context, "Failed to delete schedules.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter only schedules matching the selected formatted date
    final filteredSchedules =
        widget.incomingSchedules!.where((schedule) {
          final scheduledDate = DateTime.parse(schedule['dateScheduled']);
          return scheduledDate.year == widget.date.year &&
              scheduledDate.month == widget.date.month &&
              scheduledDate.day == widget.date.day;
        }).toList();

    return Scaffold(
      appBar: AppBar(),
      body:
          filteredSchedules.isEmpty
              ? Center(child: Text('No schedules found for ${widget.date}'))
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidCalendar,
                            color: red,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            DateFormat('MMMM dd yyyy').format(widget.date),
                            style: GoogleFonts.workSans(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isClickedSelect = !isClickedSelect;
                              if (!isClickedSelect) selectedTile.clear();
                            });
                          },
                          child: Text(
                            isClickedSelect ? "Cancel" : "Select",
                            style: GoogleFonts.workSans(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Spacer(),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          transitionBuilder:
                              (child, animation) => FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                          child:
                              (isClickedSelect && selectedTile.isNotEmpty)
                                  ? IconButton(
                                    key: ValueKey(
                                      true,
                                    ), // Ensures AnimatedSwitcher detects change
                                    icon: Icon(
                                      FontAwesomeIcons.trash,
                                      color: red,
                                      size: 20,
                                    ),
                                    onPressed: _confirmAndDeleteSelected,
                                  )
                                  : SizedBox(
                                    key: ValueKey(false), // Triggers fade out
                                  ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSchedules.length,
                        itemBuilder: (context, index) {
                          final schedule = filteredSchedules[index];
                          return GestureDetector(
                            onTap:
                                () => Get.to(
                                  () => IncomingSchedDetails(
                                    scheduleDetails: schedule,
                                  ),
                                ),
                            child: Card(
                              color: hexToColor(schedule['preferColor']),
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                onTap:
                                    isClickedSelect
                                        ? () => toggleSelection(
                                          schedule['schedule_id'],
                                        )
                                        : null,
                                leading:
                                    isClickedSelect
                                        ? AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          transitionBuilder:
                                              (child, animation) =>
                                                  FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  ),
                                          child: Checkbox(
                                            key: ValueKey(
                                              schedule['schedule_id'],
                                            ),
                                            value: selectedTile.contains(
                                              schedule['schedule_id'],
                                            ),
                                            onChanged:
                                                (_) => toggleSelection(
                                                  schedule['schedule_id'],
                                                ),
                                            activeColor: Colors.white,
                                            checkColor: Colors.black,
                                          ),
                                        )
                                        : null,
                                title: Text(
                                  schedule['title'],
                                  style: GoogleFonts.workSans(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Text(
                                  DateFormat.jm().format(
                                    DateTime.parse(
                                      '1970-01-01 ${schedule['dateScheduledTime']}',
                                    ),
                                  ),
                                  style: GoogleFonts.workSans(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Add opacity if not present
    }
    return Color(int.parse("0x$hexColor"));
  }
}
