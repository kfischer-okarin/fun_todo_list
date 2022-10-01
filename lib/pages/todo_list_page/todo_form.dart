import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  final void Function(String) onSubmit;

  const TodoForm({super.key, required this.onSubmit});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  String _title = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('New Todo', style: TextStyle(fontSize: 24)),
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                widget.onSubmit(_title);
              },
              child: const Text('Add'),
            )
          ],
        ));
  }
}
