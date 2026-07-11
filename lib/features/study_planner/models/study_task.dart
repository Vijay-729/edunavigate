import 'package:cloud_firestore/cloud_firestore.dart';

class StudyTask {
  const StudyTask({
    required this.id,
    required this.subject,
    required this.goal,
    required this.date,
    required this.durationMinutes,
    required this.isCompleted,
    required this.createdAt,
    this.priority = 'medium',
    this.startTime,
  });

  final String id;
  final String subject;
  final String goal;
  final DateTime date;
  final int durationMinutes;
  final bool isCompleted;
  final DateTime createdAt;

  /// 'high' | 'medium' | 'low'
  final String priority;

  /// Optional wall-clock start time stored as HH:mm (e.g. "09:30")
  final String? startTime;

  StudyTask copyWith({bool? isCompleted, String? priority, String? startTime}) {
    return StudyTask(
      id: id,
      subject: subject,
      goal: goal,
      date: date,
      durationMinutes: durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      priority: priority ?? this.priority,
      startTime: startTime ?? this.startTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'goal': goal,
      'date': Timestamp.fromDate(date),
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'priority': priority,
      if (startTime != null) 'startTime': startTime,
    };
  }

  factory StudyTask.fromMap(Map<String, dynamic> map) {
    return StudyTask(
      id: map['id'] as String,
      subject: map['subject'] as String,
      goal: map['goal'] as String,
      date: (map['date'] as Timestamp).toDate(),
      durationMinutes: (map['durationMinutes'] as num).toInt(),
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      priority: map['priority'] as String? ?? 'medium',
      startTime: map['startTime'] as String?,
    );
  }
}
