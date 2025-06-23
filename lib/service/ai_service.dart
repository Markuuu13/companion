import 'dart:convert';

import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../models/add_suggested_sched_model.dart';
import '../models/suggested_sched_model.dart';

class AIService {
  Future<dynamic> getSuggestedSchedule({
    required int userId,
    required String title,
    String? description,
    required String subject,
    required String deadlineDate,
    required String deadlineTime,
    required String priorityLevel,
  }) async {
    try {
      SuggestedSchedModel data = SuggestedSchedModel(
        userId: userId, // Replace with actual user ID
        title: title,
        description: description,
        subject: subject,
        deadlineDate: deadlineDate,
        deadlineTime: deadlineTime,
        priorityLevel: priorityLevel,
      );
      final response = await http.post(
        Uri.parse('$backendUrl/addSchedule/autoschedule'),
        body: data.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        return;
      }
    } catch (e) {
      print('Error in AIService: $e');
    }
  }

  Future<void> addSuggestedSchedule(
    BuildContext context, {
    required int userId,
    required String title,
    String? description,
    required String subject,
    required String deadlineDate,
    required String deadlineTime,
    required String priorityLevel,
    required String dateScheduled,
    required String dateScheduledTime,
    required String preferColor,
  }) async {
    try {
      AddSuggestedSchedModel data = AddSuggestedSchedModel(
        userId: userId,
        title: title,
        description: description,
        subject: subject,
        deadlineDate: deadlineDate,
        deadlineTime: deadlineTime,
        dateScheduled: dateScheduled,
        dateScheduledTime: dateScheduledTime,
        tileColor: preferColor,
      );
      final response = await http.post(
        Uri.parse('$backendUrl/addSchedule'),
        body: data.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessToast(context, "Suggested schedule added successfully!");
        await showConfettiDialog(context);
      } else {
        showErrorToast(context, 'Failed to add suggested schedule');
      }
    } catch (e) {
      print('Error in AIService addSuggestedSchedule: $e');
    }
  }

  Future<void> showConfettiDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(); // close dialog after 2 seconds
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 200,
            width: 200,
            child: Lottie.asset('assets/animations/check.json'),
          ),
        );
      },
    );
  }
}
