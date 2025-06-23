// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddSuggestedSchedModel {
  final int userId;
  final String title;
  final String? description;
  final String subject;
  final String deadlineDate;
  final String deadlineTime;
  final String dateScheduled;
  final String dateScheduledTime;
  final String tileColor;

  AddSuggestedSchedModel({
    required this.userId,
    required this.title,
    this.description,
    required this.subject,
    required this.deadlineDate,
    required this.deadlineTime,
    required this.dateScheduled,
    required this.dateScheduledTime,
    required this.tileColor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'title': title,
      'description': description,
      'subject': subject,
      'deadlineDate': deadlineDate,
      'deadlineTime': deadlineTime,
      'dateScheduled': dateScheduled,
      'dateScheduledTime': dateScheduledTime,
      'preferColor': tileColor,
    };
  }

  factory AddSuggestedSchedModel.fromMap(Map<String, dynamic> map) {
    return AddSuggestedSchedModel(
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      subject: map['subject'] as String,
      deadlineDate: map['deadlineDate'] as String,
      deadlineTime: map['deadlineTime'] as String,
      dateScheduled: map['dateScheduled'] as String,
      dateScheduledTime: map['dateScheduledTime'] as String,
      tileColor: map['preferColor'] as String, 
    );
  }

  String toJson() => json.encode(toMap());

  factory AddSuggestedSchedModel.fromJson(String source) =>
      AddSuggestedSchedModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
