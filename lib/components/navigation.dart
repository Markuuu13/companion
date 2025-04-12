import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../controller/navigation_controller.dart';
import '../screens/navigation/aiassistant.dart';
import '../screens/navigation/home.dart';
import '../screens/navigation/profile.dart';
import '../screens/navigation/settings.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationController navigationController = Get.put(
    NavigationController(),
  );

  List pages = [Home(), Profile(), AiAssistant(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() => pages[navigationController.selectedIndex.value]),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                child: Image.asset(
                  'assets/icons/menu.png',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     scaffoldKey.currentState!.openDrawer();
            //   },
            //   icon: Icon(Icons.menu, color: mainColor),
            // ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),

                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mark Cardeno",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "3 pending tasks",
                        style: GoogleFonts.workSans(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            // Home
            Obx(
              () => ListTile(
                tileColor:
                    navigationController.selectedIndex.value == 0
                        ? Colors.deepOrange[100]
                        : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                onTap: () {
                  navigationController.changeIndex(0);
                  Get.back();
                },
                leading: Icon(
                  Icons.home,
                  color:
                      navigationController.selectedIndex.value == 0
                          ? Colors.deepOrange
                          : Colors.deepOrange[200],
                ),
                title: Text(
                  "Home",
                  style: GoogleFonts.workSans(
                    color:
                        navigationController.selectedIndex.value == 0
                            ? Colors.deepOrange
                            : Colors.deepOrange[200],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Profile
            Obx(
              () => ListTile(
                tileColor:
                    navigationController.selectedIndex.value == 1
                        ? Colors.deepOrange[100]
                        : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                onTap: () {
                  navigationController.changeIndex(1);
                  Get.back();
                },
                leading: Icon(
                  Icons.person,
                  color:
                      navigationController.selectedIndex.value == 1
                          ? Colors.deepOrange
                          : Colors.deepOrange[200],
                ),
                title: Text(
                  "Profile",
                  style: GoogleFonts.workSans(
                    color:
                        navigationController.selectedIndex.value == 1
                            ? Colors.deepOrange
                            : Colors.deepOrange[200],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // AI Assistant
            Obx(
              () => ListTile(
                tileColor:
                    navigationController.selectedIndex.value == 2
                        ? Colors.deepOrange[100]
                        : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                onTap: () {
                  navigationController.changeIndex(2);
                  Get.back();
                },
                leading: Icon(
                  Icons.hearing_outlined,
                  color:
                      navigationController.selectedIndex.value == 2
                          ? Colors.deepOrange
                          : Colors.deepOrange[200],
                ),
                title: Text(
                  "AI Assistant",
                  style: GoogleFonts.workSans(
                    color:
                        navigationController.selectedIndex.value == 2
                            ? Colors.deepOrange
                            : Colors.deepOrange[200],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Settings
            Obx(
              () => ListTile(
                tileColor:
                    navigationController.selectedIndex.value == 3
                        ? Colors.deepOrange[100]
                        : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                onTap: () {
                  navigationController.changeIndex(3);
                  Get.back();
                },
                leading: Icon(
                  Icons.settings,
                  color:
                      navigationController.selectedIndex.value == 3
                          ? Colors.deepOrange
                          : Colors.deepOrange[200],
                ),
                title: Text(
                  "Settings",
                  style: GoogleFonts.workSans(
                    color:
                        navigationController.selectedIndex.value == 3
                            ? Colors.deepOrange
                            : Colors.deepOrange[200],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
