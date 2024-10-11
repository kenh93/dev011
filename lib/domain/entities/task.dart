import 'package:flutter/material.dart';

class Task extends ChangeNotifier{

  final String id;
  String title;
  String description;
  String priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
  });

  void updateTask(String newTitle, String newDescription, String newPriority) {
    title = newTitle;
    description = newDescription;
    priority = newPriority;
    notifyListeners(); // Notificar cambios
  }
}
