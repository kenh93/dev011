import 'package:task_manager/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
    };
  }
}
