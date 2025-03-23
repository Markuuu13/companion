import 'dart:convert';

import 'package:http/http.dart' as http;

class AppService {
  var backendUrl = 'http://192.168.0.104:3500';

  Future<List<dynamic>> fetchEducationLevel() async {
    try {
      final response = await http.get(
        Uri.parse('${backendUrl}/educationlevel'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
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
