import 'dart:async';

import 'package:companion/constants.dart';
import 'package:companion/lists/todaylist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../components/no_schedule.dart';
import '../../controller/schedule_controller.dart';
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
  final ScheduleController scheduleController = Get.put(ScheduleController());

  Map<String, dynamic>? userProfile;
  List<dynamic>? scheduleToday;
  List<dynamic>? incomingSchedules;
  bool isLoading = true;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    startLoadingTimer();
    getIncomingSchedules();
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

  Future<void> getIncomingSchedules() async {
    final userId = box.read('userid');
    try {
      final data = await scheduleService.incomingSchedules(userId: userId);
      setState(() {
        incomingSchedules = data;
        print("Incoming schedules: $incomingSchedules");
      });
    } catch (e) {
      print("Error fetching incoming schedules: $e");
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
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent, // fully remove gray shadow
        surfaceTintColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          isLoading || userProfile != null
              ? IconButton(
                onPressed: () {
                  Get.to(() => AddSchedule())!.then((_) {
                    scheduleController.fetchTodaySchedule();
                    getIncomingSchedules();
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
                  Padding(
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
                        SizedBox(height: 50),
                        Obx(() {
                          final totalCount =
                              scheduleController.scheduleToday.length;
                          final doneCount =
                              scheduleController.scheduleToday
                                  .where((sched) => sched['status_id'] == 3)
                                  .length;

                          if (totalCount == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: 0,
                                  color: green,
                                  backgroundColor: Colors.grey[300],
                                  minHeight: 25,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "No tasks for today.",
                                  style: GoogleFonts.workSans(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  LinearProgressIndicator(
                                    value: doneCount / totalCount,
                                    color: green,
                                    backgroundColor: Colors.grey[300],
                                    minHeight: 25,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${((doneCount / totalCount) * 100).toStringAsFixed(0)}%",
                                        style: GoogleFonts.workSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "You've completed $doneCount of $totalCount tasks today!",
                                  style: GoogleFonts.workSans(
                                    fontSize: 14,
                                    color: red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 2,
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
                            color: Colors.black.withAlpha(20),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (incomingSchedules != null &&
                              incomingSchedules!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 20,
                                //   ),
                                //   child: Text(
                                //     "Incoming schedules",
                                //     style: GoogleFonts.workSans(
                                //       fontSize: 14,
                                //       color: Colors.black,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                  ),
                                  child: SizedBox(
                                    height: 90,
                                    width: double.infinity,
                                    child: DateGrid(
                                      incomingSchedules: incomingSchedules,
                                      onDataChanged: getIncomingSchedules,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Today's Plan",
                                  style: GoogleFonts.workSans(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.check, color: green),
                                    Obx(
                                      () => Text(
                                        scheduleController.scheduleToday.isEmpty
                                            ? "0"
                                            : scheduleController.scheduleToday
                                                .where(
                                                  (sched) =>
                                                      sched['status_id'] == 3,
                                                )
                                                .isNotEmpty
                                            ? "${scheduleController.scheduleToday.where((sched) => sched['status_id'] == 3).length}"
                                            : "0",
                                        style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Icon(Icons.close, color: red),
                                    Obx(
                                      () => Text(
                                        scheduleController.scheduleToday.isEmpty
                                            ? "0"
                                            : scheduleController.scheduleToday
                                                .where(
                                                  (sched) =>
                                                      sched['status_id'] == 1,
                                                )
                                                .isNotEmpty
                                            ? "${scheduleController.scheduleToday.where((sched) => sched['status_id'] == 1).length}"
                                            : "0",
                                        style: GoogleFonts.workSans(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Expanded(
                            child: Obx(() {
                              if (scheduleController.isLoading.value) {
                                return Center(
                                  child: Lottie.asset(
                                    'assets/animations/loading.json',
                                    repeat: true,
                                    width: 150,
                                    height: 150,
                                  ),
                                );
                              }

                              if (scheduleController.scheduleToday.isEmpty) {
                                return NoSchedule();
                              }

                              return TodaysGridBuilder(
                                scheduleTodayData:
                                    scheduleController.scheduleToday,
                                onScheduleUpdated:
                                    scheduleController.fetchTodaySchedule,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
