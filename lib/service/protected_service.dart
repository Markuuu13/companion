import 'dart:convert';

import 'package:companion/constants.dart';
import 'package:companion/service/auth_service.dart';
import 'package:http/http.dart' as http;

class ProtectedService {
  String? token = AuthService().getToken();
  Map<String, dynamic>? userData = AuthService().getUserFromToken();

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    if (token == null) {
      print("No token found. User not logged in.");
      return null;
    }

    String email = userData!['email'];
    try {
      var response = await http.get(
        Uri.parse('$backendUrl/profile?email=$email'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData;
      } else {
        print("Failed to fetch profile. Status Code: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    return null;
  }
}
