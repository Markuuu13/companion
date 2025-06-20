// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SuggestedSchedModel {
  final int userId;
  final String title;
  final String? description;
  final String subject;
  final String deadlineDate;
  final String deadlineTime;
  final String priorityLevel;

  SuggestedSchedModel({
    required this.userId,
    required this.title,
    required this.description,
    required this.subject,
    required this.deadlineDate,
    required this.deadlineTime,
    required this.priorityLevel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'title': title,
      'description': description,
      'subject': subject,
      'deadlineDate': deadlineDate,
      'deadlineTime': deadlineTime,
      'priorityLevel': priorityLevel,
    };
  }

  factory SuggestedSchedModel.fromMap(Map<String, dynamic> map) {
    return SuggestedSchedModel(
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      subject: map['subject'] as String,
      deadlineDate: map['deadlineDate'] as String,
      deadlineTime: map['deadlineTime'] as String,
      priorityLevel: map['priorityLevel'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SuggestedSchedModel.fromJson(String source) =>
      SuggestedSchedModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
