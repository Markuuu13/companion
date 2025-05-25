import 'package:companion/db.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class UserService {
  Map<String, dynamic>? userDetails;
  Future<Map<String, dynamic>> fetchUserDetails(int id) async {
    final response =
        await supabase.from('users').select('*').eq('user_id', id).single();

    if (response.isNotEmpty) {
      print(response);
      return response;
    } else {
      throw Exception('User not found');
    }
  }

  void updateProfile({required user_id, required firstName, required lastName, required educatio}) async {


    final response = await http.post(
      Uri.parse('$backendUrl/updateProfile'),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if(response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile');
    }
  }
}
