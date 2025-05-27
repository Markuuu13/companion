import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import 'package:flutter/material.dart';

class AppService {
  Future<bool> existingUsername(BuildContext context, String username) async {
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/existingUsername"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print("Exception: $e");
      showErrorToast(context, 'Error occured');
      return false;
    }
  }

  Future<List<dynamic>> fetchEducationLevel(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/educationlevel'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];

        return data.map((item) => item['educationLevel'].toString()).toList();
      } else {
        showErrorToast(
          context,
          'Error occured while fetching education levels',
        );
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchPrimaryEducationLevels(
    BuildContext context,
  ) async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/gradelevel'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Full API Response: $responseData");
        final data = responseData['data'];
        final primaryEducationLevels =
            data
                .where((item) => item['id'] == 1)
                .toList()
                .map<String>(
                  (item) => item['grade'].toString(),
                ) // Extract gradeLevel
                .toList();

        return primaryEducationLevels;
      } else {
        showErrorToast(
          context,
          'Error occured while fetching primary education levels. Refresh the Screen',
        );
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchSecondaryEducationLevels(
    BuildContext context,
  ) async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/gradelevel'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Full API Response: $responseData");
        final data = responseData['data'];
        final secondaryEducationLevels =
            data
                .where((item) => item['id'] == 2)
                .toList()
                .map<String>(
                  (item) => item['grade'].toString(),
                ) // Extract gradeLevel
                .toList();

        return secondaryEducationLevels;
      } else {
        showErrorToast(
          context,
          'Error occured while fetching secondary education levels. Refresh the Screen',
        );
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchTertiaryEducationLevels(
    BuildContext context,
  ) async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/gradelevel'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Full API Response: $responseData");
        final data = responseData['data'];
        final tertiaryEducationLevels =
            data
                .where((item) => item['id'] == 3)
                .toList()
                .map<String>(
                  (item) => item['grade'].toString(),
                ) // Extract gradeLevel
                .toList();

        return tertiaryEducationLevels;
      } else {
        showErrorToast(
          context,
          'Error occured while fetching tertiary education levels. Refresh the Screen',
        );
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
