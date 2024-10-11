import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screens/task_edit_screen.dart';
import 'package:task_manager/presentation/screens/task_list_screen.dart';
import 'package:task_manager/presentation/screens/welcome_screen.dart';
import 'package:task_manager/domain/entities/task.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String taskList = '/taskList';
  static const String taskEdit = '/edit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case taskList:
        return MaterialPageRoute(builder: (_) => const TaskListScreen());
      case taskEdit:
        final task = settings.arguments as Task?;
        return MaterialPageRoute(builder: (_) => TaskEditScreen(task: task));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
