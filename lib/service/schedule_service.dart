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

      if (response.statusCode == 200) {
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
      } else {
        print("Failed to fetch schedules for today");
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateScheduleStatus({
    required BuildContext context,
    required int scheduleId,
    required int status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$backendUrl/updateScheduleStatus"),
        body: jsonEncode({'schedule_id': scheduleId, 'status_id': status}),
        headers: {'Content-Type': 'application/json'},
      );

      final result = jsonDecode(response.body);
      print(result);
      if (response.statusCode == 200) {
        showSuccessToast(context, "You started to do this task! Goodluck");
      } else {
        showErrorToast(context, "${result['message']}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteTask(BuildContext context, {required int scheduleId}) async {
    try {
      final response = await http.delete(
        Uri.parse('$backendUrl/schedule/deleteSchedule'),
        body: jsonEncode({'schedule_id': scheduleId}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if(response.statusCode == 200) {
        showSuccessToast(context, "Task deleted successfully!");
      }
      else {
        showErrorToast(context, "$data['message']");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
