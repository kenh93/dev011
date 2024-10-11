import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/infrastructure/models/task_model.dart';

class LocalTaskDataSource {
  final String key = 'tasks';

  Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(key);
    if (tasksJson != null) {
      final List<dynamic> taskData = json.decode(tasksJson);
      return taskData.map((json) => TaskModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> saveTask(TaskModel task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await _saveTasks(tasks);
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await _saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == id);
    await _saveTasks(tasks);
  }

  Future<void> _saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(key, tasksJson);
  }
}
