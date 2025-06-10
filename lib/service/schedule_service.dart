import 'dart:convert';

import 'package:companion/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/add_schedManual_model.dart';

class ScheduleService {
  Future<void> addScheduleManual({
    required int userId,
    required String title,
    required String? description,
    required String subject,
    required String deadlineDate,
    required String deadlineTime,
    required String scheduleDate,
    required String scheduleTime,
  }) async {
    AddSchedModelManual addSchedModelManual = AddSchedModelManual(
      userId: userId,
      title: title,
      description: description!,
      subject: subject,
      deadlineDate: deadlineDate,
      deadlineTime: deadlineTime,
      scheduleDate: scheduleDate,
      scheduleTime: scheduleTime,
    );
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/addSchedule'),
        body: addSchedModelManual.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        print('Schedule added successfully');
      } else {
        print('Failed to add schedule');
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<dynamic> scheduleToday(BuildContext context, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/scheduleToday'),
        body: jsonEncode({"user_id": userId}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if(response.statusCode == 200) {
        print("Schedules today fetched: ${response.body}");
        final schedulesToday = jsonDecode(response.body); 
        // return schedulesToday;
        if (schedulesToday is List) {
        return schedulesToday;
      } else if (schedulesToday is Map && schedulesToday['data'] is List) {
        return schedulesToday['data'];
      } else {
        print("Unexpected format: $schedulesToday");
        return [];
      }
      }
      else {
        print("Failed to fetch schedules for today");
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
