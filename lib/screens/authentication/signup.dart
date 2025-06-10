import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:companion/constants.dart';
import 'package:companion/screens/authentication/email_signup.dart';
import 'package:companion/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/textfield_register.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController username = TextEditingController();
  AppService appService = AppService();

  String? selectedEducationLevel;
  String? selectedGrade;

  List<dynamic> educationLevels = [];
  List<dynamic> primaryEducGradeLevel = [];
  List<dynamic> secondaryEducGradeLevel = [];
  List<dynamic> tertiaryEducGradeLevel = [];

  bool isToastVisible = false;
  bool? isExistingUsername;

  Timer? _debounce;

  void _onUsernameChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.isNotEmpty) {
        existingUsername(text);
      } else {
        setState(() {
          isExistingUsername = null;
        });
      }
    });
  }

  void existingUsername(String username) async {
    if (username.length < 2) {
      setState(() {
        isExistingUsername = null;
      });
      return;
    }

    try {
      bool isExisting = await appService.existingUsername(context, username);
      print("Is Existing Username: $isExisting");

      setState(() {
        isExistingUsername = isExisting;
      });
    } catch (e) {
      print("Exception while checking username: $e");
    }
  }

  void next() {
    try {
      bool isEmpty =
          username.text.trim().isEmpty ||
          selectedEducationLevel == null ||
          selectedGrade == null;

      if (isEmpty) {
        if (!isToastVisible) {
          isToastVisible = true;

          showErrorToast(context, "Please fill all fields");

          Future.delayed(Duration(seconds: 2), () {
            isToastVisible = false;
          });
        }
        return;
      }

      if (isExistingUsername == true) {
        if (!isToastVisible) {
          isToastVisible = true;
          showErrorToast(context, "Username already exists");
          Future.delayed(Duration(seconds: 2), () {
            isToastVisible = false;
          });
        }
        return;
      }

      Get.to(
        () => EmailSignup(
          username: username.text.trim(),
          educationLevel: selectedEducationLevel!,
          selectedGrade: selectedGrade!,
        ),
        transition: Transition.fade,
        duration: Duration(milliseconds: 600),
      );
    } catch (e) {
      showErrorToast(context, e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadEducationLevel();
    loadPrimaryEducGradeLevel();
    loadSecondaryEducGradeLevel();
    loadTertiaryEducGradeLevel();

    username.addListener(() {
      _onUsernameChanged(username.text.trim());
    });
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    isToastVisible = false;
    username.dispose();
    selectedEducationLevel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(isExistingUsername);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create your Account",
                        style: GoogleFonts.workSans(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      Text(
                        "Set up your account to get started",
                        style: GoogleFonts.workSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                TextfieldRegister(labeltext: 'Username', controller: username),
                if (isExistingUsername != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Row(
                      children: [
                        Icon(
                          isExistingUsername == true
                              ? Icons.cancel_outlined
                              : Icons.check_circle_rounded,
                          color: isExistingUsername == true ? red : green,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            isExistingUsername == true
                                ? "Username already exists"
                                : "Username is available",
                            style: GoogleFonts.workSans(
                              color: isExistingUsername == true ? red : green,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (username.text.trim().length < 2 &&
                    username.text.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 5,
                    ),
                    child: Text(
                      "Username must be at least 2 characters",
                      style: GoogleFonts.workSans(
                        color: mainColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            
                SizedBox(height: 20),
                // TextfieldRegister(labeltext: 'Last name', controller: lastname),
                // SizedBox(height: 20),
                // Text(educationLevels.toString()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField(
                      value: selectedEducationLevel,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      hint: Text(
                        "Select your Education Level",
                        style: GoogleFonts.workSans(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      items:
                          educationLevels.map<DropdownMenuItem>((dynamic value) {
                            return DropdownMenuItem(
                              value: value.toString(),
                              child: Text(
                                value.toString(),
                                style: GoogleFonts.workSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedEducationLevel = newValue;
                          selectedGrade = null;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (selectedEducationLevel != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField(
                        value: selectedGrade,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        hint: Text(
                          "Select your Education Level",
                          style: GoogleFonts.workSans(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                              50,
                            ), // Rounded corners
                          ),
                        ),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        items:
                            selectedEducationLevel == 'Primary Education'
                                ? primaryEducGradeLevel.map<DropdownMenuItem>((
                                  dynamic value,
                                ) {
                                  return DropdownMenuItem(
                                    value: value.toString(),
            
                                    child: Text(
                                      value.toString(),
                                      style: GoogleFonts.workSans(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList()
                                : selectedEducationLevel == 'Secondary Education'
                                ? secondaryEducGradeLevel.map<DropdownMenuItem>((
                                  dynamic value,
                                ) {
                                  return DropdownMenuItem(
                                    value: value.toString(),
                                    child: Text(
                                      value.toString(),
                                      style: GoogleFonts.workSans(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList()
                                : selectedEducationLevel == 'Tertiary Education'
                                ? tertiaryEducGradeLevel.map<DropdownMenuItem>((
                                  dynamic value,
                                ) {
                                  return DropdownMenuItem(
                                    value: value.toString(),
                                    child: Text(
                                      value.toString(),
                                      style: GoogleFonts.workSans(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList()
                                : null,
            
                        onChanged: (newValue) {
                          setState(() {
                            selectedGrade = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: InkWell(
                      onTap: next,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadEducationLevel() async {
    try {
      List<dynamic> data = await appService.fetchEducationLevel(context);
      print("Fetched Data: $data");
      setState(() {
        educationLevels = data;
      });
    } catch (e) {
      print('Error fetching education levels: $e');
    }
  }

  Future<void> loadPrimaryEducGradeLevel() async {
    try {
      List<dynamic> data = await appService.fetchPrimaryEducationLevels(
        context,
      );
      setState(() {
        primaryEducGradeLevel = data;
      });
    } catch (e) {
      print('Error fetching grades: $e');
    }
  }

  Future<void> loadSecondaryEducGradeLevel() async {
    try {
      List<dynamic> data = await appService.fetchSecondaryEducationLevels(
        context,
      );
      setState(() {
        secondaryEducGradeLevel = data;
      });
    } catch (e) {
      print('Error fetching grades: $e');
    }
  }

  Future<void> loadTertiaryEducGradeLevel() async {
    try {
      List<dynamic> data = await appService.fetchTertiaryEducationLevels(
        context,
      );
      setState(() {
        tertiaryEducGradeLevel = data;
      });
    } catch (e) {
      print('Error fetching grades: $e');
    }
  }
}
