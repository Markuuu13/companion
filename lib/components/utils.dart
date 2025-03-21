import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void onSuccess(BuildContext context) {
  CherryToast.info(
    title: Text(
      "Account Created Successfully!",
      style: TextStyle(color: Colors.black),
    ),
    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}

void onError(BuildContext context) {
  CherryToast.info(
    title: Text("Error", style: TextStyle(color: Colors.black)),
    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      onError(context);
      break;
    default:
      print("Invalid");
  }
}
