
import 'package:flutter/material.dart';
import 'main.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  TaskFormPage({this.task, required this.onSave});

  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  DateTime? _dueDate;
  String _category = 'General';

  final List<String> _categories = ['General', 'Academic', 'Personal', 'Work'];

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = t?.title ?? '';
    _description = t?.description ?? '';
    _dueDate = t?.dueDate;
    _category = t?.category ?? 'General';
  }

  void _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        category: _category,
      );
      widget.onSave(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        backgroundColor: Color(0xFF0056b3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (val) => _title = val,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (val) => _description = val,
              ),
              DropdownButtonFormField(
                value: _category,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (val) => setState(() => _category = val!),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _dueDate == null
                        ? 'No due date'
                        : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _pickDueDate,
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                ),
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
    ),
    );
  }
  }