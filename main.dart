import 'package:flutter/material.dart';
import 'task_form_page.dart';

void main() {
  runApp(AsianCollegeTodoApp());
}

class AsianCollegeTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asian College To-Do',
      theme: ThemeData(
        primaryColor: Color(0xFF0056b3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0056b3),
          primary: Color(0xFF0056b3),
          secondary: Color(0xFFFFD700),
        ),
        useMaterial3: true,
      ),
      home: TaskListPage(),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime? dueDate;
  bool isCompleted;
  String category;

  Task({
    required this.title,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
    this.category = 'General',
  });
}

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [];
  String _searchQuery = '';


  void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormPage(
          onSave: (task) {
            setState(() => _tasks.add(task));
          },
        ),
      ),
    );
  }


  void _editTask(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormPage(
          task: _tasks[index],
          onSave: (updatedTask) {
            setState(() => _tasks[index] = updatedTask);
          },
        ),
      ),
    );
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }


  Widget _buildTaskItem(int index) {
    final task = _tasks[index];
    final now = DateTime.now();
    final isDueSoon = task.dueDate != null &&
        task.dueDate!.isAfter(now) &&
        task.dueDate!.isBefore(now.add(Duration(days: 2)));

    return ListTile(
      onTap: () => _editTask(index),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.dueDate != null
          ? Text(
              'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                color: isDueSoon ? Colors.red : Colors.black,
                fontWeight: isDueSoon ? FontWeight.bold : FontWeight.normal,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (_) => _toggleComplete(index),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteTask(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _tasks.where((task) {
      final query = _searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0056b3),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Color(0xFFFFD700)),
                SizedBox(width: 10),
                Text('Asian College To-Do'),
              ],
            ),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ],
        ),
        toolbarHeight: 90,
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (_, index) {
          final taskIndex = _tasks.indexOf(filteredTasks[index]);
          return _buildTaskItem(taskIndex);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Color(0xFFFFD700),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}




