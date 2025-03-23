import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

var mainColor = Color(0xFFFF7559);
var completeColor = Color(0xFF5BEF8D);
var notStarted = Color(0xFFFF6262);
var red = Color(0xFFC64242);
var orange = Color(0xFFFFAD5C);
var green = Color(0xFF52BD76);
var blue = Color(0xFF52A9FF);
var autoSchedNotAvail = Color(0xFF7FA58C);
var autoSchedNotAvailTxt = Color(0xFFD2D2D2);

// Snackbars

void showSuccessToast(BuildContext context, String message) {
  CherryToast.info(
    title: Text(message, style: TextStyle(color: Colors.black)),

    action: Text("Display information", style: TextStyle(color: Colors.black)),

    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}

void showErrorToast(BuildContext context, String message) {
  CherryToast.info(
    autoDismiss: true,
    toastDuration: Duration(seconds: 1, milliseconds: 500),
    toastPosition: Position.bottom,
    animationDuration: Duration(milliseconds: 500),
    animationType: AnimationType.fromBottom,
    title: Text(message, style: GoogleFonts.workSans(color: Colors.red)),
    iconWidget: Icon(Icons.error, color: Colors.red),
    displayCloseButton: false,
    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}


