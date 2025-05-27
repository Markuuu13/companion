import 'package:companion/models/user_model.dart';
import 'package:companion/screens/navigation/profile.dart';
import 'package:companion/service/app_service.dart';
import 'package:companion/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';
import '../../controller/navigation_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  UserService userService = UserService();
  AppService appservice = AppService();

  String? selectedEducationLevel;
  String? selectedGradeLevel;

  // For education lists
  List<dynamic> educationLevels = [];
  List<dynamic> primaryEducGradeLevel = [];
  List<dynamic> secondaryEducGradeLevel = [];
  List<dynamic> tertiaryEducGradeLevel = [];

  NavigationController navigationController = Get.put(NavigationController());

  Map<String, dynamic>? userProfile;
  final box = GetStorage();

  Future<void> loadUserProfile() async {
    final userId = box.read('userid');
    try {
      final details = await userService.fetchUserDetails(userId);
      setState(() {
        userProfile = details;
        firstNameController.text = userProfile!['firstname'];
        lastNameController.text = userProfile!['lastname'];
        selectedEducationLevel = userProfile!['educationLevel'];
        selectedGradeLevel = userProfile!['selectedGrade'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadUserProfile();
    loadEducationLevels();
    loadPrimaryEducGradeLevel();
    loadSecondaryEducGradeLevel();
    loadTertiaryEducGradeLevel();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    selectedEducationLevel = null;
    selectedGradeLevel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child:
              userProfile == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Edit Profile",
                                style: GoogleFonts.workSans(
                                  fontSize: 25,
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Change your profile details",
                                style: GoogleFonts.workSans(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 190,
                                  height: 190,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        size: 16,
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 40),
                        buildtextfield(
                          firstNameController,
                          labelText: "First Name",
                        ),
                        SizedBox(height: 20),
                        buildtextfield(
                          lastNameController,
                          labelText: "Last Name",
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField(
                          value: selectedEducationLevel,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          hint: Text("Select your Education Level"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Rounded corners
                            ),
                          ),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                          items:
                              educationLevels.map<DropdownMenuItem>((
                                dynamic value,
                              ) {
                                return DropdownMenuItem(
                                  value: value.toString(),
                                  child: Text(value.toString(), style: GoogleFonts.workSans(),),
                                );
                              }).toList(),

                          onChanged: (newValue) {
                            setState(() {
                              selectedEducationLevel = newValue;
                              selectedGradeLevel = null;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        if (selectedEducationLevel != null)
                          DropdownButtonFormField(
                            value: selectedGradeLevel,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            hint: Text("Select your Grade Level"),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Rounded corners
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                            items:
                                selectedEducationLevel == 'Primary Education'
                                    ? primaryEducGradeLevel
                                        .map<DropdownMenuItem>((dynamic value) {
                                          return DropdownMenuItem(
                                            value: value.toString(),

                                            child: Text(
                                              value.toString(),
                                              style: GoogleFonts.workSans(),
                                            ),
                                          );
                                        })
                                        .toList()
                                    : selectedEducationLevel ==
                                        'Secondary Education'
                                    ? secondaryEducGradeLevel
                                        .map<DropdownMenuItem>((dynamic value) {
                                          return DropdownMenuItem(
                                            value: value.toString(),
                                            child: Text(
                                              value.toString(),
                                              style: GoogleFonts.workSans(),
                                            ),
                                          );
                                        })
                                        .toList()
                                    : selectedEducationLevel ==
                                        'Tertiary Education'
                                    ? tertiaryEducGradeLevel
                                        .map<DropdownMenuItem>((dynamic value) {
                                          return DropdownMenuItem(
                                            value: value.toString(),
                                            child: Text(
                                              value.toString(),
                                              style: GoogleFonts.workSans(),
                                            ),
                                          );
                                        })
                                        .toList()
                                    : null,

                            onChanged: (newValue) {
                              setState(() {
                                selectedGradeLevel = newValue;
                              });
                            },
                          ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text(
                                        'Discard Changes?',
                                        style: GoogleFonts.workSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to discard changes?',
                                        style: GoogleFonts.workSans(
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.workSans(
                                              color: red,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Get.back();
                                            navigationController.changeIndex(1);
                                          },
                                          child: Text(
                                            'Yes',
                                            style: GoogleFonts.workSans(
                                              color: green,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 170,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Discard',
                                      style: GoogleFonts.workSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: Text(
                                        'Save Changes?',
                                        style: GoogleFonts.workSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to save changes?',
                                        style: GoogleFonts.workSans(
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.workSans(
                                              color: red,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              showSuccessToastProfile(
                                                context,
                                                'Profile updated successfully!',
                                              );
                                              Get.back();
                                            } catch (e) {
                                              showErrorToast(
                                                context,
                                                'Failed to update profile.',
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Save',
                                            style: GoogleFonts.workSans(
                                              color: green,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 170,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: green,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Save',
                                      style: GoogleFonts.workSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget buildtextfield(
    TextEditingController controller, {
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.workSans(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Future<void> loadEducationLevels() async {
    try {
      List<dynamic> levels = await appservice.fetchEducationLevel(context);
      setState(() {
        educationLevels = levels;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadPrimaryEducGradeLevel() async {
    try {
      List<dynamic> levels = await appservice.fetchPrimaryEducationLevels(
        context,
      );
      setState(() {
        primaryEducGradeLevel = levels;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadSecondaryEducGradeLevel() async {
    try {
      List<dynamic> levels = await appservice.fetchSecondaryEducationLevels(
        context,
      );
      setState(() {
        secondaryEducGradeLevel = levels;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadTertiaryEducGradeLevel() async {
    try {
      List<dynamic> levels = await appservice.fetchTertiaryEducationLevels(
        context,
      );
      setState(() {
        tertiaryEducGradeLevel = levels;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
