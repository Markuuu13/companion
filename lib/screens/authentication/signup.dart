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

  String? selectedValue;
  List<dynamic> educationLevels = [];
  bool isToastVisible = false;

  void next() {
    try {
      bool isEmpty =
          firstname.text.trim().isEmpty ||
          lastname.text.trim().isEmpty ||
          selectedValue == null;

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
          educationLevel: selectedValue!,
        ),
        transition: Transition.fade,
        duration: Duration(milliseconds: 600),
      );
    } catch (e) {
      showErrorToast(context, e.toString());
    }
  }

  void loadEducationLevel() async {
    try {
      List<dynamic> data = await appService.fetchEducationLevel();
      print("Fetched Data: $data");
      setState(() {
        educationLevels =
            data
                .map<String>((item) => item['grade'].toString())
                .toSet()
                .toList();
      });
    } catch (e) {
      print('Error fetching education levels: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEducationLevel();
  }

  @override
  void dispose() {
    isToastVisible = false;
    firstname.dispose();
    lastname.dispose();
    selectedValue = null;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField(
                  value: selectedValue,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  hint: Text("Select your Education Level"),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ), // Rounded corners
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  items:
                      educationLevels.map((dynamic value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),

                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectedValue = newValue;
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
}
