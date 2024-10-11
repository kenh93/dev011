import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/providers/task_provider.dart';
import 'package:task_manager/presentation/providers/theme_provider.dart';
import 'package:task_manager/presentation/widgets/task_tile.dart';
import 'package:task_manager/config/app_routes.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  List<String> selectedPriorities = [];

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.loadTasks();
  }

  void _togglePriority(String priority) {
    setState(() {
      if (selectedPriorities.contains(priority)) {
        selectedPriorities.remove(priority);
      } else {
        selectedPriorities.add(priority);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Lista de Tareas')),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: StreamBuilder<List<Task>>(
            stream: taskProvider.taskStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
        
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay tareas disponibles.'));
              }
        
              final tasks = snapshot.data!.where((task) {
                if (selectedPriorities.isEmpty) return true;
                if (selectedPriorities.contains('Otros')) {
                  return !['Alta', 'Media', 'Baja'].contains(task.priority);
                }
                return selectedPriorities.contains(task.priority);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskTile(task: task);
                },
              );
            },
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botón de Filtrado Extendido
            FloatingActionButton.extended(
              onPressed: () {
                _showPriorityFilterDialog(context);
              },
              label: const Text('Filtrar'),
              icon: const Icon(Icons.filter_list),
              heroTag: 'filterBtn',
              backgroundColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.blue, // Cambiar color según el modo
            ),
            const SizedBox(height: 16),
            // Botón de Agregar Tarea
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.taskEdit);
              },
              tooltip: 'Agregar Tarea',
              heroTag: 'addBtn',
              backgroundColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.blue,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar el diálogo de selección de prioridades
  void _showPriorityFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Seleccionar Prioridades'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPriorityCheckbox('Alta', setState),
                  _buildPriorityCheckbox('Media', setState),
                  _buildPriorityCheckbox('Baja', setState),
                  _buildPriorityCheckbox('Otros', setState), // "Otros" para cualquier otra prioridad
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Construir el checkbox para cada prioridad
  Widget _buildPriorityCheckbox(String priority, StateSetter setState) {
    return CheckboxListTile(
      title: Text(priority),
      value: selectedPriorities.contains(priority),
      onChanged: (bool? selected) {
        setState(() {
          _togglePriority(priority); // Actualizar la lista de prioridades seleccionadas
        });
      },
    );
  }
}


