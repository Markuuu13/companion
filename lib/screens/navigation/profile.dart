import 'package:companion/constants.dart';
import 'package:companion/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/schedule_status.dart';
import '../other_pages/edit_profile.dart';

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
      backgroundColor: Colors.white,
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
                      buildUserDetails(
                        title: "Username",
                        userDetails:
                            "${userProfile!['username']}",
                      ),
                      SizedBox(height: 30),
                      buildUserDetails(
                        title: "Email",
                        userDetails: userProfile!['email'],
                      ),
                      SizedBox(height: 30),
                      buildUserDetails(
                        title: "Education Level",
                        userDetails: userProfile!['educationLevel'],
                      ),
                      SizedBox(height: 30),
                      buildUserDetails(
                        title: "Grade Level",
                        userDetails: userProfile!['selectedGrade'],
                      ),
                      Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(EditProfile());
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

  Widget buildUserDetails({
    required String title,
    required String userDetails,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.workSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: mainColor,
          ),
        ),
        Text(
          userDetails,
          style: GoogleFonts.workSans(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
