import 'package:companion/components/navigation.dart';
import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/textfield.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isToastVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isToastVisible = false;
    super.dispose();
  }

  void login() {
    try {
      bool isEmpty =
          emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty;

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

      // Get.to(
      //   () => EmailSignup(
      //     firstname: firstname.text.trim(),
      //     lastname: lastname.text.trim(),
      //     educationLevel: selectedValue!,
      //   ),
      //   transition: Transition.fade,
      //   duration: Duration(milliseconds: 600),
      // );
    } catch (e) {}
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/companion_logo.png", width: 250),
                  SizedBox(height: 60),
                  CustomTextField(
                    labeltext: 'Email Address',
                    controller: emailController,
                  ),
                  SizedBox(height: 40),
                  CustomTextField(
                    labeltext: 'Password',
                    controller: passwordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ForgotPasswordPage());
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: InkWell(
                      onTap: login,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Icon(
                      Icons.facebook,
                      color: Color(0xFF1877F2),
                      size: 50,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => SignupPage()),
                        child: Text(
                          "Register",
                          style: GoogleFonts.workSans(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
