import 'package:companion/splash/splash_screen_logged.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();
  final userId = box.read('userid');
  
  runApp(MyApp(userId: userId));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final dynamic userId;
  const MyApp({super.key, this.userId});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreenLoggedIn(),
      // home: userId != null ? Navigation() : LoginPage(),
    );
  }
}
