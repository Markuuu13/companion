// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class TodaysGridBuilder extends StatefulWidget {
  final List<dynamic>? scheduleTodayData;
  const TodaysGridBuilder({super.key, required this.scheduleTodayData});

  @override
  State<TodaysGridBuilder> createState() => _TodaysGridBuilderState();
}

class _TodaysGridBuilderState extends State<TodaysGridBuilder> {
  List sample = [
    {"color": red, "title": "Activity", "status": completeColor},
    {"color": orange, "title": "Assignment", "status": notStarted},
    {"color": blue, "title": "Assignment", "status": notStarted},
    {"color": green, "title": "Assignment", "status": completeColor},
    {"color": red, "title": "Assignment", "status": completeColor},
    {"color": red, "title": "Assignment", "status": completeColor},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 5,
        childAspectRatio: 4 / 1,
      ),
      itemCount: widget.scheduleTodayData!.length,
      itemBuilder: (context, index) {
        final data = widget.scheduleTodayData![index];
        print(data['title']);
        return buildPlanTile(
          context: context,
          title: data['title'],
          status:
              data['status_id'] == 1
                  ? red
                  : data['status_id'] == 2
                  ? orange
                  : data['status_id'] == 3
                  ? green
                  : Colors.grey,
          preferColor: green,
          timeScheduled: parseTime(data['dateScheduledTime']),
        );
      },
    );
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
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                timeScheduled.format(context),
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
  );
}
