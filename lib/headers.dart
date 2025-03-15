import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var home_header = Padding(
  padding: const EdgeInsets.only(top: 50, left: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi Mark,",
                style: GoogleFonts.workSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "How's your day?",
                style: GoogleFonts.workSans(
                  color: mainColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);

var settingsHeader = Padding(
  padding: const EdgeInsets.only(top: 50, left: 20),
  child: Text(
    "Settings",
    style: GoogleFonts.workSans(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  ),
);
