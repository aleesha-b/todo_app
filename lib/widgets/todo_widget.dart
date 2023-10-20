import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_list.dart';

import 'edit_todo_widget.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  final Color colour;

  const TodoWidget({Key? key, required this.todo, required this.colour})
      : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white,),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Todo'),
              content: const Text('Are you sure you want to delete this todo?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<TodoList>(context, listen: false).remove(widget.todo);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTodoScreen(todo: widget.todo),
          ),
        );
      },
      child: Container(
        color: widget.colour,
        padding: const EdgeInsets.all(2.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                    child: Text(
                      widget.todo.name,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
                    child: Text(
                      widget.todo.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: widget.todo.complete,
              onChanged: (completedStatus) {
                widget.todo.complete = completedStatus ?? false;
                Provider.of<TodoList>(context, listen: false).update(widget.todo);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}