// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'today_sched_details.dart';

class TodaysGridBuilder extends StatefulWidget {
  final List<dynamic>? scheduleTodayData;
  final VoidCallback? onScheduleUpdated;
  const TodaysGridBuilder({
    super.key,
    required this.scheduleTodayData,
    this.onScheduleUpdated,
  });

  @override
  State<TodaysGridBuilder> createState() => _TodaysGridBuilderState();
}

class _TodaysGridBuilderState extends State<TodaysGridBuilder> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 5,
        childAspectRatio: 5 / 1,
      ),
      itemCount: widget.scheduleTodayData!.length,
      itemBuilder: (context, index) {
        final data = widget.scheduleTodayData![index];
        print(data['title']);
        return buildPlanTile(
          data: data,
          context: context,
          title: data['title'],
          status:
              data['status_id'] == 1
                  ? data['preferColor'] == "#FFC64242"
                      ? const Color(0xFFF39595)
                      : red
                  : data['status_id'] == 2
                  ? orange
                  : data['status_id'] == 3
                  ? green
                  : Colors.grey,
          preferColor: parseColor(data['preferColor']),
          timeScheduled: parseTime(data['dateScheduledTime']),
          onScheduleUpdated: widget.onScheduleUpdated,
        );
      },
    );
  }

  Color parseColor(String colorString) {
    colorString = colorString.replaceAll('#', '');
    if (colorString.length == 6) {
      colorString = 'FF$colorString'; // add alpha if missing
    }
    return Color(int.parse(colorString, radix: 16));
  }
}

TimeOfDay parseTime(String timeStr) {
  final parts = timeStr.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

Widget buildPlanTile({
  required BuildContext context,
  required Color preferColor,
  required String title,
  required Color status,
  required TimeOfDay timeScheduled,
  required Map<String, dynamic> data,
  required VoidCallback? onScheduleUpdated,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
    child: InkWell(
      onTap: () {
        Get.to(() => TodayScheduleDetails(scheduleDetails: data))?.then((_) {
          onScheduleUpdated!();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: preferColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.workSans(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  DateFormat.jm().format(
                    DateTime(
                      1970,
                      1,
                      1,
                      timeScheduled.hour,
                      timeScheduled.minute,
                    ),
                  ),
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(width: 20),
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: status,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
