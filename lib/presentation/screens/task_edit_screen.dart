import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/domain/entities/task.dart';
import 'package:task_manager/presentation/providers/task_provider.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;

  const TaskEditScreen({super.key, this.task});

  @override
  TaskEditScreenState createState() => TaskEditScreenState();
}

class TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _priority = 'Baja';
  bool _isEditMode = false;
  bool _isSaving = false;
  final List<String> _priorities = ['Alta', 'Media', 'Baja'];

  @override
  void initState() {
    super.initState();
    
    if (widget.task != null) {
      _isEditMode = true;
      _title = widget.task!.title;
      _description = widget.task!.description;
      _priority = _priorities.contains(widget.task!.priority) ? widget.task!.priority : 'Baja';
    }else{
      _priority = 'Baja';
    }
  }
  
  void _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isSaving = true;
      });

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final task = Task(
        id: _isEditMode ? widget.task!.id : DateTime.now().toString(),
        title: _title,
        description: _description,
        priority: _priority,
      );

      if (_isEditMode) {
        await taskProvider.updateTask(task);
      } else {
        if (!taskProvider.tasks.any((t) => t.id == task.id)) {
          await taskProvider.addTask(task);
        }
      }

      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context);
    }
  }

  void _deleteTask() async {
    if (_isEditMode && widget.task != null) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.deleteTask(widget.task!.id);
      Navigator.pop(context);
    }
  }

 @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Actualizar Tarea' : 'Agregar Tarea'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextField(
                      label: 'Título',
                      initialValue: _title,
                      onSaved: (value) => _title = value!,
                      validator: (value) => value!.isEmpty ? 'Por favor, ingrese un título' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Descripción',
                      initialValue: _description,
                      onSaved: (value) => _description = value!,
                    ),
                    const SizedBox(height: 16),
                    _buildPriorityDropdown(),
                    const SizedBox(height: 32),
                    _isSaving
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              _buildActionButton(
                                label: _isEditMode ? 'Actualizar' : 'Agregar',
                                color: theme.colorScheme.primary,
                                onPressed: _saveTask,
                              ),
                              if (_isEditMode) ...[
                                const SizedBox(height: 16),
                                _buildActionButton(
                                  label: 'Eliminar',
                                  color: Colors.red,
                                  onPressed: _deleteTask,
                                ),
                              ],
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _priority.isNotEmpty ? _priority : 'Baja',
      decoration: InputDecoration(
        labelText: 'Prioridad',
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: _priorities.map((priority) {
        return DropdownMenuItem(value: priority, child: Text(priority));
      }).toList(),
      onChanged: (value) => setState(() {
        _priority = value!;
      }),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
