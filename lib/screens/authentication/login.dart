import 'package:companion/components/navigation.dart';
import 'package:companion/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/textfield.dart';
import '../../service/auth_service.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool isToastVisible = false;

  @override
  void dispose() {
    username.dispose();
    passwordController.dispose();
    isToastVisible = false;
    super.dispose();
  }

  void login() async {
    bool isEmpty =
        username.text.trim().isEmpty || passwordController.text.trim().isEmpty;

    if (isEmpty) {
      if (!isToastVisible) {
        isToastVisible = true;

        showErrorToast(context, "The username and password fields are required.");

        Future.delayed(Duration(seconds: 2), () {
          isToastVisible = false;
        });
      }
      return;
    }
    try {
      // var connectivityResult = await Connectivity().checkConnectivity();
      // if (connectivityResult == ConnectivityResult.none) {
      //   if (!isToastVisible) {
      //     isToastVisible = true;
      //     showErrorToast(context, "No internet connection.");
      //     Future.delayed(Duration(seconds: 2), () {
      //       isToastVisible = false;
      //     });
      //   }
      //   return;
      // }

      bool successLogin = await authService.signIn(
        context: context,
        username: username.text.trim(),
        password: passwordController.text.trim(),
      );

      if (successLogin) {
        Get.offAll(() => Navigation());
      } else {
        if (!isToastVisible) {
          isToastVisible = true;

          showErrorToast(
            context,
            "Invalid email or password. Please try again.",
          );

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
    } catch (e) {
      if (!isToastVisible) {
        isToastVisible = true;

        showErrorToast(context, "Error occured. Please try again later.");

        Future.delayed(Duration(seconds: 2), () {
          isToastVisible = false;
        });
      }
      return;
    }
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: Text(
                  //     "What is CompAInion?",
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.workSans(
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.w500,
                  //       color: mainColor,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 50),
                  Image.asset("assets/companion_logo.png", width: 250),
                  SizedBox(height: 60),
                  CustomTextField(
                    labeltext: 'Username',
                    icon: Icon(Icons.person),
                    controller: username,
                  ),
                  SizedBox(height: 40),
                  CustomTextField(
                    labeltext: 'Password',
                    isObscure: true,
                    icon: Icon(Icons.lock),
                    controller: passwordController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 25),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ForgotPasswordPage());
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.workSans(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: InkWell(
                      onTap: login,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: MediaQuery.sizeOf(context).width * 0.83,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Log in",
                          style: GoogleFonts.workSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
                            style: GoogleFonts.workSans(color: Colors.grey),
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
