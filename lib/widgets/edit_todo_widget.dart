import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_list.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  const EditTodoScreen({Key? key, required this.todo})
  : super(key: key);

  @override
  EditTodoScreenState createState() => EditTodoScreenState();
}

class EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the current todo values
    _controllerName.text = widget.todo.name;
    _controllerDescription.text = widget.todo.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit To-Do'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding:  EdgeInsets.all(4),
            child: Text('Name'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              controller: _controllerName,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(4),
            child: Text('Description'),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              controller: _controllerDescription,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final updatedTodo = Todo(
                  id: widget.todo.id,
                  name: _controllerName.text,
                  description: _controllerDescription.text,
                  complete: widget.todo.complete,
                );
                Provider.of<TodoList>(context, listen: false)
                    .update(updatedTodo);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
