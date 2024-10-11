import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/config/app_routes.dart';
import 'package:task_manager/config/app_theme.dart';
import 'package:task_manager/infrastructure/datasources/api_task_datasource.dart';
import 'package:task_manager/infrastructure/datasources/local_task_datasource.dart';
import 'package:task_manager/infrastructure/repositories/task_repository_impl.dart';
import 'package:task_manager/presentation/providers/task_provider.dart';
import 'package:task_manager/presentation/providers/theme_provider.dart';


Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuración de los proveedores
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            // Inicializa las fuentes de datos y el repositorio
            final apiDataSource = ApiTaskDataSource();
            final localDataSource = LocalTaskDataSource();
            final taskRepository = TaskRepositoryImpl(
              apiTaskDataSource: apiDataSource,
              localTaskDataSource: localDataSource,
            );
            
            // Inicializa el TaskProvider con el repositorio
            return TaskProvider(taskRepository)..loadTasks();
          },
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Task Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(themeProvider.isDarkMode, themeProvider.primaryColor),
            initialRoute: AppRoutes.welcome,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}