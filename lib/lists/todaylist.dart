import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class TodaysGridBuilder extends StatefulWidget {
  const TodaysGridBuilder({super.key});

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
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 5,
        childAspectRatio: 4 / 1,
      ),
      itemCount: sample.length,
      itemBuilder: (context, index) {
        final data = sample[index];
        return buildPlanTile(
          preferColor: data['color'],
          title: data['title'],
          status: data['status'],
        );
      },
    );
  }
}

Widget buildPlanTile({
  required Color preferColor,
  required String title,
  required Color status,
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
                "4:30 PM",
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
