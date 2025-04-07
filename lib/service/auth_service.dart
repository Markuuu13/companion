import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:companion/components/utils.dart';
import 'package:companion/screens/authentication/login.dart';
import 'package:companion/screens/authentication/verifyemail.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user_model.dart';

class AuthService {
  final box = GetStorage();

  void signUp({
    required BuildContext context,
    required String email,
    required String firstname,
    required String lastname,
    required String password,
    required String educationLevel,
    required String otp,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        firstname: firstname,
        lastname: lastname,
        token: '',
        password: password,
        educationLevel: educationLevel,
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
        showSuccessToast(context, jsonDecode(response.body)['message']);
        Get.offAll(() => LoginPage());
      } else if (response.statusCode == 500) {
        showErrorToast(context, jsonDecode(response.body)['message']);
      } else {
        print("Invalid");
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
          showErrorToast(context, jsonDecode(response.body)['message']);
          return true;

        case 400: // Error occurred
          showErrorToast(context, jsonDecode(response.body)['message']);
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

  Future<bool> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var response = await http.post(
        Uri.parse('$backendUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        print("token: $token");

        box.write('token', token);
        return true;
      } else {
        print(jsonDecode(response.body)['message']);
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

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
