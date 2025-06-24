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
    required String tileColor,
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
      tileColor: tileColor,
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
        Uri.parse('$backendUrl/schedule/scheduleToday'),
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

  Future<dynamic> incomingSchedules({required int userId}) async {
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/schedule/incomingSchedules?user_id=$userId'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        print("Incoming schedules fetched: ${response.body}");
        final incomingSchedules = jsonDecode(response.body);
        return incomingSchedules['data'];
      } else {
        print("Failed to fetch incoming schedules");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateScheduleStatus({
    required BuildContext context,
    required int scheduleId,
    required int status,
    String? message,
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
        if (message != null && message.isNotEmpty) {
          showSuccessToast(context, message);
        }
      } else {
        showErrorToast(context, "${result['message']}");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteTask(
    BuildContext context, {
    required int scheduleId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$backendUrl/schedule/deleteSchedule'),
        body: jsonEncode({'schedule_id': scheduleId}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showSuccessToast(context, "Task deleted successfully!");
      } else {
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> deleteMultipleSchedules(List<int> scheduleIds) async {
    try {
      final response = await http.delete(
        Uri.parse('$backendUrl/schedule/deleteMultiple'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'schedule_ids': scheduleIds}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("Multiple schedules deleted successfully: $result");
        return true;
      } else {
        print("Failed to delete multiple schedules: ${result['message']}");
        return false;
      }
    } catch (e) {
      print("Error deleting multiple schedules: $e");
      return false;
    }
  }
}
