// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String email;
  final String firstname;
  final String lastname;
  final String token;
  final String password;
  final String educationLevel;
  final String otp;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.token,
    required this.password,
    required this.educationLevel,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'educationLevel': educationLevel,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user_id'] as String,
      email: map['email'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      token: map['token'] as String,
      password: map['password'] as String,
      educationLevel: map['educationLevel'] as String,
      otp:  map['otp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) {
    return User.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
