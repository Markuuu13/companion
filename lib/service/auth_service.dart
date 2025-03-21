import 'package:cherry_toast/cherry_toast.dart';
import 'package:companion/components/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AuthService {
  final backendUrl = 'http://192.168.0.104:3500';

  void signUp({
    required BuildContext context,
    required String email,
    required String firstname,
    required String lastname,
    required String password,
    required String educationLevel,
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
      );

      var response = await http.post(
        Uri.parse('${backendUrl}/registration'),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        CherryToast.info(
          title: Text("User added", style: TextStyle(color: Colors.black)),

          action: Text(
            "Display information",
            style: TextStyle(color: Colors.black),
          ),

          actionHandler: () {
            print("Action button pressed");
          },
        ).show(context);
      } else if(response.statusCode == 500) {
        CherryToast.info(
          title: Text("This email is already registered", style: TextStyle(color: Colors.black)),
          actionHandler: () {
            print("Action button pressed");
          },
        ).show(context);
      } else {
        print("Invalid");
      }
    } catch (e) {
      print(e);
    }
  }
}
