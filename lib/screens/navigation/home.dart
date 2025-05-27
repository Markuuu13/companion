import 'package:companion/constants.dart';
import 'package:companion/lists/todaylist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/no_schedule.dart';
import '../../headers.dart';
import '../../service/user_service.dart';
import '../other_pages/add_sched.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserService userService = UserService();
  Map<String, dynamic>? userProfile;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(() => AddSchedule()),
            icon: Icon(Icons.add, color: completeColor, size: 35),
          ),
          SizedBox(width: 5,),
        ],
      ),
      body: SafeArea(
        child:
            userProfile == null
                ? Center(child: CircularProgressIndicator())
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
                              "Hi ${userProfile!['firstname']} ${userProfile!['lastname']}",
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
                              Text(
                                "Today's Plan",
                                style: GoogleFonts.workSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: Center(child: NoSchedule())),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        // userProfile == null
        //     ? Center(child: CircularProgressIndicator())
        //     : Column(
        //       children: [
        //         Expanded(
        //           flex: 2,
        //           child: Stack(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 50, left: 20),
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Row(
        //                       children: [
        //                         Column(
        //                           crossAxisAlignment:
        //                               CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               "Hi ${userProfile!['firstname']} ${userProfile!['lastname']}",
        //                               style: GoogleFonts.workSans(
        //                                 fontSize: 20,
        //                                 fontWeight: FontWeight.w600,
        //                               ),
        //                             ),
        //                             Text(
        //                               "How's your day?",
        //                               style: GoogleFonts.workSans(
        //                                 color: mainColor,
        //                                 fontSize: 30,
        //                                 fontWeight: FontWeight.bold,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               // Plans

        //               // Add Schedule Button --> navigates to another page
        //               Positioned(
        //                 right: 10,
        //                 top: 5,
        //                 child: IconButton(
        //                   onPressed: () => Get.to(() => AddSchedule()),
        //                   icon: Icon(
        //                     Icons.add,
        //                     color: completeColor,
        //                     size: 35,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        // Expanded(
        //   flex: 3,
        //   child:
        //   Container(
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20),
        //         topRight: Radius.circular(20),
        //       ),
        //       boxShadow: [
        //         BoxShadow(
        //           offset: Offset(0, -5),
        //           color: Colors.black.withAlpha(50),
        //           blurRadius: 4,
        //           spreadRadius: 0,
        //         ),
        //       ],
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.only(
        //         left: 25,
        //         right: 25,
        //         top: 30,
        //       ),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             "Today's Plan",
        //             style: GoogleFonts.workSans(
        //               fontSize: 25,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           Expanded(child: TodaysGridBuilder()),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        //       ],
        //     ),
      ),
    );
  }
}
