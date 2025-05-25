// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String email;
  final String firstname;
  final String lastname;
  final String password;
  final String educationLevel;
  final String selectedGrade;
  final String otp;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.password,
    required this.educationLevel,
    required this.selectedGrade,
    required this.otp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
      'educationLevel': educationLevel,
      'selectedGrade': selectedGrade,
      'otp': otp,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      password: map['password'] as String,
      educationLevel: map['educationLevel'] as String,
      selectedGrade: map['selectedGrade'] as String,
      otp: map['otp'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
