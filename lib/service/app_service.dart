import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

class AppService {

  Future<List<String>> fetchEducationLevel() async {
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/educationlevel'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];
        List<String> grades = data.map<String>((item) => item['educationLevel'].toString()).toList();

        return grades;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return []; // Return empty list if status code is not 200
      }
    } catch (e) {
      print("Exception: $e");
      return []; 
    }
  }
}
