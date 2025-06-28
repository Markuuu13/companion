import 'dart:convert';
import 'package:companion/screens/authentication/login.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user_model.dart';
import '../screens/authentication/successful.dart';

class AuthService {
  final box = GetStorage();
  Map<String, dynamic>? userDetails;
  int? userId;
  bool isToastVisible = false;
  void signUp({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
    required String educationLevel,
    required String selectedGrade,
    required String otp,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        username: username,
        password: password,
        educationLevel: educationLevel,
        selectedGrade: selectedGrade,
        otp: otp,
      );

      var response = await http.post(
        Uri.parse('$backendUrl/registration'),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        Get.offAll(() => SuccessfullyVerified());
        return;
      } else if (response.statusCode == 500) {
        if (!isToastVisible) {
          isToastVisible = true;
          showErrorToast(context, jsonDecode(response.body)['message']);
          Future.delayed(Duration(seconds: 2), () {
            isToastVisible = false;
          });
        }
        return;
      } else {
        if (!isToastVisible) {
          isToastVisible = true;
          showErrorToast(context, jsonDecode(response.body)['message']);
          Future.delayed(Duration(seconds: 2), () {
            isToastVisible = false;
          });
        }
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isExistingUser(BuildContext context, String email) async {
    try {
      var response = await http.post(
        Uri.parse('$backendUrl/existingUser'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"email": email}),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      switch (response.statusCode) {
        case 409: // Email already exists
          return true;

        case 400: // Error occurred
          return false;

        case 200: // Email is available
          return false;

        default:
          print("Unexpected status code: ${response.statusCode}");
          showErrorToast(
            context,
            "Unexpected error occurred. Please try again.",
          );
          return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Future<bool> signIn({
  //   required BuildContext context,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse('$backendUrl/login'),
  //       body: jsonEncode({'email': email, 'password': password}),
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       String token = data['token'];

  //       print("token: $token");

  //       box.write('token', token);
  //       return true;
  //     } else {
  //       print(jsonDecode(response.body)['message']);
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }
  Future<bool> signIn({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$backendUrl/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userId = data['data']['user_id'];

        // final userdata = UserService().fetchUserDetails(userId);
        box.write('userid', userId);
        print(userId);
        // print(userDetails);
        return true;
      } else {
        print(jsonDecode(response.body)['message']);
        showErrorToast(context, jsonDecode(response.body)['message']);
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // void loadUserFromStorage() async {
  //   final userId = box.read("userid");
  //   if (userId != null) {
  //     userDetails = await UserService().fetchUserDetails(userId);
  //     print("Loaded user from storage: $userId");
  //   } else {
  //     print("No user found in storage");
  //   }
  // }

  Future<bool> sendOTP(BuildContext context, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        showSuccessToast(context, jsonDecode(response.body)['message']);
        return true;
      } else if (response.statusCode == 400) {
        showErrorToast(context, jsonDecode(response.body)['message']);
        return false;
      } else {
        return false;
      }
    } catch (e) {
      showErrorToast(context, "Error occured. Please try again.");
      return false;
    }
  }

  String? getToken() {
    return box.read("token");
  }

  Map<String, dynamic>? getUserFromToken() {
    String? token = getToken();

    if (token == null) {
      return null;
    }

    try {
      final jwt = JWT.decode(token);
      return jwt.payload;
    } catch (e) {}
  }
}
