import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'components/navigation.dart';
import 'screens/authentication/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final userId = box.read('userid');

    Future.delayed(Duration(milliseconds: 100), () {
      Get.offAll(() => userId != null ? Navigation() : LoginPage());
    });

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}