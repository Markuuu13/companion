import 'package:companion/constants.dart';
import 'package:companion/main.dart';
import 'package:companion/screens/authentication/signup.dart';
import 'package:flutter/material.dart';

import '../screens/authentication/login.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final PageController _pageController = PageController();
  bool isOnSecondPage = false;
  bool _isFading = false;

  final List<Widget> _pages = [
    LoginPage(), // Call LoginPage widget
    SignupPage(), // Call RegisterPage widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                isOnSecondPage = index == 1;
              });
            },
            children: _pages,
          ),

          // Ball that moves slightly ahead of the swipe
          AnimatedAlign(
            duration: Duration(milliseconds: 500), // Adjust speed here
            curve: Curves.easeInOut,
            alignment:
                isOnSecondPage ? Alignment.bottomLeft : Alignment.bottomRight,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 550),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(
                isOnSecondPage ? -150 : 150, // Moves ahead slightly
                200,
                0,
              ),
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    isOnSecondPage ? 0 : 1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );

                  setState(() {
                    isOnSecondPage = !isOnSecondPage;
                  });
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: isOnSecondPage ? Colors.white : mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment:
                        isOnSecondPage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      // child: Text(
                      //   isOnSecondPage ? "Sign In" : "Register", // Dynamic text
                      //   style: TextStyle(
                      //     color: isOnSecondPage ? Colors.black : Colors.white,
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: 15,
            left: isOnSecondPage ? 30 : null,
            right: isOnSecondPage ? null : 30,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: isOnSecondPage || _isFading ? 1.0 : 0.0, // Fade effect
              onEnd: () {
                if (!isOnSecondPage) {
                  setState(() {
                    _isFading = false; // Reset fade effect after animation
                  });
                }
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFading = true; // Trigger fade effect
                  });

                  Future.delayed(Duration(milliseconds: 2000), () {
                    _pageController.animateToPage(
                      isOnSecondPage ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                },
                child: Text(
                  isOnSecondPage ? "Log in" : "Register",
                  style: TextStyle(
                    color: isOnSecondPage ? mainColor : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
