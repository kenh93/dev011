import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/infrastructure/models/task_model.dart';

class ApiTaskDataSource {
  final String apiUrl = 'https://65f43f68f54db27bc02120e0.mockapi.io/api/v1/task';

  Future<List<TaskModel>> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> taskData = json.decode(response.body);
      return taskData.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
