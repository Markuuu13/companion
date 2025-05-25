// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddSchedModelManual {
  final int userId;
  final String title;
  final String? description;
  final String subject;
  final String deadlineDate;
  final String deadlineTime;
  final String scheduleDate;
  final String scheduleTime;

  AddSchedModelManual({
    required this.userId,
    required this.title,
    this.description,
    required this.subject,
    required this.deadlineDate,
    required this.deadlineTime,
    required this.scheduleDate,
    required this.scheduleTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'title': title,
      'description': description,
      'subject': subject,
      'deadlineDate': deadlineDate,
      'deadlineTime': deadlineTime,
      'dateScheduled': scheduleDate,
      'dateScheduledTime': scheduleTime,
    };
  }

  factory AddSchedModelManual.fromMap(Map<String, dynamic> map) {
    return AddSchedModelManual(
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      subject: map['subject'] as String,
      deadlineDate: map['deadlineDate'] as String,
      deadlineTime: map['deadlineTime'] as String,
      scheduleDate: map['dateScheduled'] as String,
      scheduleTime: map['dateScheduledTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddSchedModelManual.fromJson(String source) =>
      AddSchedModelManual.fromMap(json.decode(source) as Map<String, dynamic>);
}
