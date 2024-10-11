import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/config/app_routes.dart';
import 'package:task_manager/presentation/providers/theme_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: null,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Este es su aplicación para administrar tareas',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.taskList);
              },
              child: const Text('Ver todas las tareas'),
            ),
          ],
        ),
      ),
    );
  }
}
