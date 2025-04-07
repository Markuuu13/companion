import 'package:companion/constants.dart';
import 'package:companion/service/protected_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProtectedService protectedService = ProtectedService();

  Map<String, dynamic>? userProfile;

  void fetchUserProfile() async {
    var response = await protectedService.fetchUserProfile();
    if (response != null) {
      setState(() {
        userProfile = response;
      });
    } else {
      print("Failed to fetch user profile");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${userProfile!['firstname']} ${userProfile!['lastname']} ${userProfile!['email']}',
                      ),
                      Container(
                        width: double.infinity,
                        height: 350,
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        child: Text("image"),
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
                        "Mark Cardeno",
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
                        "markcardeno04@gmail.com",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontSize: 20,
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
                        "College 3rd Year",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
