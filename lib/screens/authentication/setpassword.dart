import 'package:companion/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/textfield_register.dart';
import '../../constants.dart';

class SetPassword extends StatefulWidget {
  final String username;
  final String educationLevel;
  final String selectedGrade;
  final String emailAddress;
  const SetPassword({
    super.key,
    required this.username,
    required this.educationLevel,
    required this.emailAddress,
    required this.selectedGrade,
  });

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService authService = AuthService();

  bool isChecked = false;
  bool isObscure = true;

  void signUpUser(
    String emailAddress,
    String username,
    String educationLevel,
    String selectedGrade,
    String password,
  ) {
    if (confirmPasswordController.text.trim() !=
        passwordController.text.trim()) {
      print('Password doesnt match');
      return;
    }
    authService.signUp(
      context: context,
      email: emailAddress,
      username: username,
      password: password,
      educationLevel: educationLevel,
      otp: '',
      selectedGrade: selectedGrade,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                      "Create a Password",
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
                obscureText: isObscure,
                labeltext: 'Password',
                controller: passwordController,
              ),
              SizedBox(height: 10),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () {
                      signUpUser(
                        widget.emailAddress,
                        widget.username,
                        widget.educationLevel,
                        widget.selectedGrade,
                        passwordController.text.trim(),
                      );
                    },
                    // () => Get.to(
                    //   () => VerifyEmail(),
                    //   transition: Transition.fade,
                    //   duration: Duration(milliseconds: 600),
                    // ),
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
              // Text(
              //   "${widget.username}, ${widget.lastname}, ${widget.educationLevel}, ${widget.emailAddress}",
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
