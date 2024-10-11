import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/providers/task_provider.dart';
import 'package:task_manager/presentation/screens/task_edit_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {    
    final theme = Theme.of(context);

    return ChangeNotifierProvider<Task>.value(
      value: task,
      child: Consumer<Task>(
        builder: (context, task, child) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: theme.cardColor, // Usar el color de la tarjeta según el tema
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    _buildPriorityTag(task.priority),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskEditScreen(task: task),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                  taskProvider.deleteTask(task.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriorityTag(String priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'alta':
        return Colors.redAccent; // Color para prioridad alta
      case 'media':
        return Colors.orangeAccent; // Color para prioridad media
      case 'baja':
        return Colors.greenAccent; // Color para prioridad baja
      default:
        return Colors.blueAccent; // Color por defecto
    }
  }
}
