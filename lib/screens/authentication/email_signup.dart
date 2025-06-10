import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/textfield_register.dart';
import '../../constants.dart';
import '../../service/auth_service.dart';
import 'verifyemail.dart';

class EmailSignup extends StatefulWidget {
  final String username;
  final String educationLevel;
  final String selectedGrade;
  const EmailSignup({
    super.key,
    required this.username,
    required this.educationLevel,
    required this.selectedGrade,
  });

  @override
  State<EmailSignup> createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  AuthService authService = AuthService();
  bool isChecked = false;
  bool isObscure = true;
  bool isToastVisible = false;
  String password = '';

  void verifyUserEmail(
    String emailAddress,
    String username,
    String educationLevel,
    String selectedGrade,
    String password,
  ) async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      if (!isToastVisible) {
        isToastVisible = true;
        showErrorToast(context, "Password doesn't match!");
        Future.delayed(Duration(seconds: 2), () {
          isToastVisible = false;
        });
      }
      return;
    }
    if (passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      if (!isToastVisible) {
        isToastVisible = true;
        showErrorToast(context, "Password is required.");
        Future.delayed(Duration(seconds: 2), () {
          isToastVisible = false;
        });
      }
      return;
    }

    try {
      bool isExistingUser = await authService.isExistingUser(
        context,
        emailController.text.trim(),
      );
      if (isExistingUser) {
        if (!isToastVisible) {
          isToastVisible = true;
          showErrorToast(
            context,
            "This email is already registered. Please try another email.",
          );
          Future.delayed(Duration(seconds: 2), () {
            isToastVisible = false;
          });
        }
        return;
      }
      bool sendEmail = await authService.sendOTP(
        context,
        emailController.text.trim(),
      );
      print(sendEmail);
      if (sendEmail) {
        Get.to(
          () => VerifyEmail(
            email: emailAddress,
            username: username,
            educationLevel: educationLevel,
            selectedGrade: selectedGrade,
            password: passwordController.text.trim(),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() {
      setState(() {
        password = passwordController.text.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Email Address",
                        style: GoogleFonts.workSans(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      Text(
                        "Starts on giving your some information",
                        style: GoogleFonts.workSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                TextfieldRegister(
                  labeltext: 'Email Address',
                  controller: emailController,
                ),
                SizedBox(height: 20),
                TextfieldRegister(
                  obscureText: isObscure,
                  labeltext: 'Password',
                  controller: passwordController,
                ),
                SizedBox(height: 20),

                buildPasswordRequirement(
                  text: 'Password must contain at least 8 characters.',
                  condition: password.length >= 8,
                ),
                buildPasswordRequirement(
                  text: "Should contain special characters !@_^&#* only.",
                  condition: RegExp(r'[!@_^&#*]').hasMatch(password),
                ),

                buildPasswordRequirement(
                  text: "Should contain at least one uppercase letter.",
                  condition: RegExp(r'[A-Z]').hasMatch(password),
                ),

                SizedBox(height: 20),
                TextfieldRegister(
                  obscureText: isObscure,
                  labeltext: 'Confirm Password',
                  controller: confirmPasswordController,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        side: BorderSide.none,
                        fillColor: WidgetStateProperty.all(Colors.black26),
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                            isObscure = !newValue;
                          });
                        },
                      ),
                      Text(
                        "Show Password",
                        style: GoogleFonts.workSans(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap:
                          () => verifyUserEmail(
                            emailController.text.trim(),
                            widget.username,
                            widget.educationLevel,
                            widget.selectedGrade,
                            passwordController.text.trim(),
                          ),
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

  Widget buildPasswordRequirement({
    required String text,
    required bool condition,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            condition ? Icons.check_circle_rounded : Icons.cancel_outlined,
            color: condition ? green : red,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: GoogleFonts.workSans(
                  color: condition ? green : red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
