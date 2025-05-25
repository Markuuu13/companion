import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/textfield_register.dart';
import '../../constants.dart';
import '../../service/auth_service.dart';
import 'setpassword.dart';
import 'verifyemail.dart';

class EmailSignup extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String educationLevel;
  final String selectedGrade;
  const EmailSignup({
    super.key,
    required this.firstname,
    required this.lastname,
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

  void verifyUserEmail(
    String emailAddress,
    String firstname,
    String lastname,
    String educationLevel,
    String selectedGrade,
    String password,
  ) async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      showErrorToast(context, "Passwords doesn't match");
      return;
    }
    if (passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      showErrorToast(context, "Password required");
      return;
    }

    try {
      bool isExistingUser = await authService.isExistingUser(
        context,
        emailController.text.trim(),
      );
      if (isExistingUser) {
        showErrorToast(
          context,
          "This email is already registered. Please try another email",
        );
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
            firstname: firstname,
            lastname: lastname,
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
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
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
                      side: BorderSide(color: Colors.white),
                      fillColor: WidgetStateProperty.all(Colors.white),
                      checkColor: Colors.black,
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
                        color: Colors.white,
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
                          widget.firstname,
                          widget.lastname,
                          widget.educationLevel,
                          widget.selectedGrade,
                          passwordController.text.trim(),
                        ),
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
