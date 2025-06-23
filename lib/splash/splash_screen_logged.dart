import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../components/navigation.dart';
import '../screens/authentication/login.dart';

class SplashScreenLoggedIn extends StatefulWidget {
  const SplashScreenLoggedIn({super.key});

  @override
  State<SplashScreenLoggedIn> createState() => _SplashScreenLoggedInState();
}

class _SplashScreenLoggedInState extends State<SplashScreenLoggedIn> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      final userId = box.read('userid');
      Get.offAll(() => userId != null ? Navigation() : LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animations/hand_loading.json',
          repeat: true,
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}
