import 'package:companion/constants.dart';
import 'package:companion/service/auth_service.dart';
import 'package:companion/service/protected_service.dart';
import 'package:companion/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/schedule_status.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: SafeArea(
        child:
            userProfile == null
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Text(
                        "Profile",
                        style: GoogleFonts.workSans(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(color: Colors.grey[300]),
                          ),
                          Column(
                            children: [
                              StatusContainer(
                                color: notStarted,
                                text: "Today's Task: 0",
                              ),
                              SizedBox(height: 15),
                              StatusContainer(
                                color: orange,
                                text: "Pending: 0",
                              ),
                              SizedBox(height: 15),
                              StatusContainer(
                                color: completeColor,
                                text: "Completed: 0",
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Name",
                        style: GoogleFonts.workSans(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Name
                      Text(
                        "${userProfile!['firstname']} ${userProfile!['lastname']}",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Email",
                        style: GoogleFonts.workSans(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Name
                      Text(
                        userProfile!['email'],
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Education Level",
                        style: GoogleFonts.workSans(
                          color: mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Name
                      Text(
                        userProfile!['educationLevel'],
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showSuccessToastProfile(
                              context,
                              "Edit Profile Clicked",
                            );
                          },
                          child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Edit Profile',
                                style: GoogleFonts.workSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
      ),
    );
  }
}
