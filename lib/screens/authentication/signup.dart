import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:companion/constants.dart';
import 'package:companion/screens/authentication/email_signup.dart';
import 'package:companion/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/textfield.dart';
import '../../components/textfield_register.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  AppService appService = AppService();

  String? selectedEducationLevel;
  String? selectedGrade;

  List<dynamic> educationLevels = [];
  List<dynamic> primaryEducGradeLevel = [];
  List<dynamic> secondaryEducGradeLevel = [];
  List<dynamic> tertiaryEducGradeLevel = [];

  bool isToastVisible = false;

  void next() {
    try {
      bool isEmpty =
          firstname.text.trim().isEmpty ||
          lastname.text.trim().isEmpty ||
          selectedEducationLevel == null;
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

      Get.to(
        () => EmailSignup(
          firstname: firstname.text.trim(),
          lastname: lastname.text.trim(),
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
    super.initState();
  }

  @override
  void dispose() {
    isToastVisible = false;
    firstname.dispose();
    lastname.dispose();
    selectedEducationLevel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: mainColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Starts on giving your some information",
                      style: GoogleFonts.workSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              TextfieldRegister(labeltext: 'First name', controller: firstname),
              SizedBox(height: 20),
              TextfieldRegister(labeltext: 'Last name', controller: lastname),
              SizedBox(height: 20),
              // Text(educationLevels.toString()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField(
                  value: selectedEducationLevel,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  hint: Text("Select your Education Level"),
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
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  items:
                      educationLevels.map<DropdownMenuItem>((dynamic value) {
                        return DropdownMenuItem(
                          value: value.toString(),
                          child: Text(value.toString()),
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
              SizedBox(height: 20),
              if (selectedEducationLevel != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DropdownButtonFormField(
                    value: selectedGrade,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    hint: Text("Select your Education Level"),
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
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                    items:
                        selectedEducationLevel == 'Primary Education'
                            ? primaryEducGradeLevel.map<DropdownMenuItem>((
                              dynamic value,
                            ) {
                              return DropdownMenuItem(
                                value: value.toString(),
                                
                                child: Text(value.toString(), style: GoogleFonts.workSans(),),
                              );
                            }).toList()
                            : selectedEducationLevel == 'Secondary Education'
                            ? secondaryEducGradeLevel.map<DropdownMenuItem>((
                              dynamic value,
                            ) {
                              return DropdownMenuItem(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            }).toList()
                            : selectedEducationLevel == 'Tertiary Education'
                            ? tertiaryEducGradeLevel.map<DropdownMenuItem>((
                              dynamic value,
                            ) {
                              return DropdownMenuItem(
                                value: value.toString(),
                                child: Text(value.toString()),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InkWell(
                    onTap: next,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: mainColor,
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
      List<dynamic> data = await appService.fetchPrimaryEducationLevels(context);
      setState(() {
        primaryEducGradeLevel = data;
      });
    } catch (e) {
      print('Error fetching grades: $e');
    }
  }

  Future<void> loadSecondaryEducGradeLevel() async {
    try {
      List<dynamic> data = await appService.fetchSecondaryEducationLevels(context);
      setState(() {
        secondaryEducGradeLevel = data;
      });
    } catch (e) {
      print('Error fetching grades: $e');
    }
  }

  Future<void> loadTertiaryEducGradeLevel() async {
    try {
      List<dynamic> data = await appService.fetchTertiaryEducationLevels(context);
      setState(() {
        tertiaryEducGradeLevel = data;
      });
    } catch (e) {
      print('Error fetching grades: $e');
    }
  }
}
