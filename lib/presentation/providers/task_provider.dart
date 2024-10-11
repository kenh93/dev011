import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository taskRepository;
  final _taskStreamController = StreamController<List<Task>>.broadcast();
  List<Task> _tasks = [];

  TaskProvider(this.taskRepository);

  List<Task> get tasks => _tasks;
  Stream<List<Task>> get taskStream => _taskStreamController.stream;

  Future<void> loadTasks() async {
    _tasks = await taskRepository.getTasks();
    _taskStreamController.add(_tasks);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    if (!_tasks.any((t) => t.id == task.id)) {
      await taskRepository.addTask(task);
      _tasks.add(task);
    if (_taskStreamController.hasListener) {
      _taskStreamController.add(List<Task>.from(_tasks)); 
    }
    notifyListeners();
  }
  }

  Future<void> updateTask(Task updatedTask) async {
      await taskRepository.updateTask(updatedTask);
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        _taskStreamController.add(_tasks);
        notifyListeners();
      }
  }
  Future<void> deleteTask(String taskId) async {
    await taskRepository.deleteTask(taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    _taskStreamController.add(_tasks);
    notifyListeners();
  }

  @override
  void dispose() {
    _taskStreamController.close();
    super.dispose();
  }
}
