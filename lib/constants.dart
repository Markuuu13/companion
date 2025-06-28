import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

var backendUrl = 'http://192.168.100.103:3500';

var mainColor = Color(0xFFFF7559);
var txtfield = Color(0xFFFF7559);
var completeColor = Color(0xFF5BEF8D);
var notStarted = Color(0xFFFF6262);
var red = Color(0xFFC64242);
var orange = Color(0xFFFFAD5C);
var green = Color(0xFF52BD76);
var blue = Color(0xFF52A9FF);
var manualEditNotAvail = const Color.fromARGB(255, 255, 150, 118);
var manualEditNotAvailTxt = const Color.fromARGB(255, 246, 193, 177);
var autoSchedNotAvail = Color(0xFF7FA58C);
var autoSchedNotAvailTxt = Color(0xFFD2D2D2);

// Snackbars

void showSuccessToast(BuildContext context, String message) {
  CherryToast.info(
    autoDismiss: true,
    toastDuration: Duration(seconds: 2, milliseconds: 500),
    toastPosition: Position.bottom,
    animationDuration: Duration(milliseconds: 500),
    animationType: AnimationType.fromBottom,
    title: Text(
      message,
      style: GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    iconWidget: Icon(Icons.check_circle_outline, color: Colors.white),
    backgroundColor: green,
    displayCloseButton: false,
    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}

void showSuccessToastProfile(BuildContext context, String message) {
  CherryToast.info(
    autoDismiss: true,
    toastDuration: Duration(seconds: 2, milliseconds: 500),
    toastPosition: Position.top,
    animationDuration: Duration(milliseconds: 500),
    animationType: AnimationType.fromBottom,
    title: Text(
      message,
      style: GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    iconWidget: Icon(Icons.check_circle_outline, color: Colors.white),
    backgroundColor: green,
    displayCloseButton: false,
    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}

void showErrorToast(BuildContext context, String message) {
  CherryToast.info(
    autoDismiss: true,
    toastDuration: Duration(seconds: 2, milliseconds: 500),
    toastPosition: Position.bottom,
    animationDuration: Duration(milliseconds: 500),
    animationType: AnimationType.fromBottom,
    title: Text(
      message,
      style: GoogleFonts.workSans(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    iconWidget: Icon(Icons.error, color: Colors.white),
    backgroundColor: red,
    displayCloseButton: false,
    actionHandler: () {
      print("Action button pressed");
    },
  ).show(context);
}
