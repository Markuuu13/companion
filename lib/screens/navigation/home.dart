import 'dart:async';

import 'package:companion/constants.dart';
import 'package:companion/lists/todaylist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../components/no_schedule.dart';
import '../../lists/date_grid.dart';
import '../../service/schedule_service.dart';
import '../../service/user_service.dart';
import '../other_pages/add_sched.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserService userService = UserService();
  final ScheduleService scheduleService = ScheduleService();

  Map<String, dynamic>? userProfile;
  List<dynamic>? scheduleToday;
  bool isLoading = true;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    getScheduleToday();
    startLoadingTimer();
  }

  Future<void> _loadUserProfile() async {
    final userId = box.read('userid');
    try {
      final details = await userService.fetchUserDetails(userId);
      print(details);
      setState(() {
        userProfile = details;
      });
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  Future<void> getScheduleToday() async {
    final userId = box.read('userid');

    try {
      final schedules = await scheduleService.scheduleToday(context, userId);
      setState(() {
        scheduleToday = schedules;
      });
    } catch (e) {
      print(e);
    }
  }

  void startLoadingTimer() {
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          isLoading || userProfile != null
              ? IconButton(
                onPressed: () {
                  Get.to(() => AddSchedule())?.then((_) {
                    getScheduleToday();
                  });
                },
                icon: Icon(Icons.add, color: completeColor, size: 35),
              )
              : Text(""),
          SizedBox(width: 5),
        ],
      ),
      body:
          isLoading || userProfile == null
              ? Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  repeat: true,
                  width: 150,
                  height: 150,
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi ${userProfile!['username']}",
                            style: GoogleFonts.workSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "How's your day?",
                            style: GoogleFonts.workSans(
                              color: mainColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: DateGrid(),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Today's Plan",
                                  style: GoogleFonts.workSans(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                if (scheduleToday != null)
                                  Row(
                                    children: [
                                      Icon(Icons.check, color: green),
                                      Text(
                                        "0",
                                        style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Icon(Icons.close, color: red),
                                      Text(
                                        scheduleToday == null
                                            ? ""
                                            : scheduleToday!
                                                .where(
                                                  (sched) =>
                                                      sched['status_id'] == 1,
                                                )
                                                .isNotEmpty
                                            ? "${scheduleToday!.where((sched) => sched['status_id'] == 1).length}"
                                            : "0",
                                        style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),

                            Expanded(
                              child:
                                  scheduleToday == null
                                      ? Center(
                                        child: Lottie.asset(
                                          'assets/animations/loading.json',
                                          repeat: true,
                                          width: 150,
                                          height: 150,
                                        ),
                                      )
                                      : scheduleToday!.isEmpty
                                      ? NoSchedule()
                                      : TodaysGridBuilder(
                                        scheduleTodayData: scheduleToday,
                                        onScheduleUpdated: getScheduleToday,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
