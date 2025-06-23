// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:companion/constants.dart';

import '../screens/other_pages/view_incoming_sched.dart';

class DateGrid extends StatelessWidget {
  final List<dynamic>? incomingSchedules;
  final VoidCallback? onDataChanged;
  const DateGrid({super.key, this.incomingSchedules, this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    if (incomingSchedules == null || incomingSchedules!.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/no-schedule.webp',
              height: 100,
              width: 200,
            ),
            Text(
              'No Incoming Schedules',
              style: GoogleFonts.workSans(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final Set<DateTime> uniqueDates =
        incomingSchedules!
            .map((item) => DateTime.parse(item['dateScheduled']))
            .map(
              (date) => DateTime(date.year, date.month, date.day),
            ) // Remove time
            .toSet();

    final dateList = uniqueDates.toList()..sort();

    return GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(8),
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 19,
        childAspectRatio: 1.1 / 1,
      ),
      itemCount: dateList.length,
      itemBuilder: (context, index) {
        final date = dateList[index];

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap:
                () => Get.to(
                  () => ViewIncomingSchedules(
                    date: date,
                    incomingSchedules: incomingSchedules,
                    onDataChanged: onDataChanged,
                  ),
                ),
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    DateFormat('MMM \nd').format(date),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
