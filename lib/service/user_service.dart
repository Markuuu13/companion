import 'package:companion/db.dart';

class UserService {
  Map<String, dynamic>? userDetails;
  Future<Map<String, dynamic>> fetchUserDetails(int id) async {
    final response =
        await supabase.from('users').select('*').eq('user_id', id).single();

        if(response.isNotEmpty) {
          print(response);
          return response;
        } else {
          throw Exception('User not found');
        }
  }
}
