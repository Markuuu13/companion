import 'package:companion/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/textfield_register.dart';
import '../../constants.dart';
import 'successful.dart';

class VerifyEmail extends StatefulWidget {
  final String username;
  final String email;
  final String educationLevel;
  final String selectedGrade;
  final String password;
  const VerifyEmail({
    super.key,
    required this.username,
    required this.email,
    required this.educationLevel,
    required this.password,
    required this.selectedGrade,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController verifyOtp = TextEditingController();

  AuthService authService = AuthService();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    verifyOtp.dispose();
  }

  void signUp(
    String email,
    String username,
    String password,
    String educationLevel,
    String selectedGrade,
    String otp,
  ) async {
    try {
      authService.signUp(
        context: context,
        email: email,
        username: username,
        password: password,
        educationLevel: educationLevel,
        selectedGrade: selectedGrade,
        otp: otp,
      );
      Get.offAll(() => SuccessfullyVerified());
    } catch (e) {
      print(e.toString());
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
                      "Verify your Email",
                      style: GoogleFonts.workSans(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    Text(
                      "You are almost done!",
                      style: GoogleFonts.workSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "OTP code sent to:",
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.workSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.email,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.workSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextfieldRegister(
                labeltext: 'Enter the 6 digit code',
                controller: verifyOtp,
              ),
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap:
                        () => signUp(
                          widget.email,
                          widget.username,
                          widget.password,
                          widget.educationLevel,
                          widget.selectedGrade,
                          verifyOtp.text.trim(),
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
                        "Verify my Email",
                        style: GoogleFonts.workSans(
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
    );
  }
}
