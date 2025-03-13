import 'package:companion/constants.dart';
import 'package:companion/lists/todaylist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../headers.dart';
import '../other_pages/add_sched.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  home_header,
                  // Plans

                  // Add Schedule Button --> navigates to another page
                  Positioned(
                    right: 10,
                    top: 5,
                    child: IconButton(
                      onPressed: () => Get.to(() => AddSchedule()),
                      icon: Icon(Icons.add, color: completeColor, size: 35),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, -5),
                          color: Colors.black.withAlpha(50),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Plan",
                              style: GoogleFonts.workSans(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(child: TodaysGridBuilder()),
                          ],
                        ),
                      ),
                    
                  ),
                
              ),
            
          ],
        ),
      ),
    );
  }
}
