import 'dart:convert';

import 'package:companion/constants.dart';
import 'package:http/http.dart' as http;

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

    Future<void> addSuggestedSchedule() async {
      try {
        // final response = 
      } catch (e) {
        print('Error adding suggested schedule: $e');
      }
    }
  }
}
