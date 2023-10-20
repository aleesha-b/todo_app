import 'package:todo_app/models/todo.dart';

abstract class IDataSource {
  Future<List<Todo>> browse();
  Future<void> edit(Todo todo);
  Future<void> add(Todo todo);
  Future<void> delete(Todo todo);
}