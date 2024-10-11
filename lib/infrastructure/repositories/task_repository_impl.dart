import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';
import 'package:task_manager/infrastructure/datasources/api_task_datasource.dart';
import 'package:task_manager/infrastructure/datasources/local_task_datasource.dart';
import 'package:task_manager/infrastructure/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final ApiTaskDataSource apiTaskDataSource;
  final LocalTaskDataSource localTaskDataSource;

  TaskRepositoryImpl({
    required this.apiTaskDataSource,
    required this.localTaskDataSource,
  });

  @override
  Future<List<Task>> getTasks() async {
    //carga las tareas desde el metodo y tambien unifica con las tareas locales
    List<TaskModel> taskModels = [];
    try {
      final taskModelsFromApi = await apiTaskDataSource.fetchTasks();
      for (var taskModel in taskModelsFromApi) {
        await localTaskDataSource.saveTask(taskModel);
      }
      taskModels.addAll(taskModelsFromApi);
    } catch (e) {
      print('Error al cargar las tareas desde la API: $e');
    }

    final taskModelsFromLocal = await localTaskDataSource.loadTasks();
    for (var localTask in taskModelsFromLocal) {
      if (!taskModels.any((apiTask) => apiTask.id == localTask.id)) {
        taskModels.add(localTask);
      }
    }

    return taskModels.map((taskModel) => Task(
      id: taskModel.id,
      title: taskModel.title,
      description: taskModel.description,
      priority: taskModel.priority,
    )).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
    );
    await localTaskDataSource.saveTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
    );
    await localTaskDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localTaskDataSource.deleteTask(id);
  }
}
