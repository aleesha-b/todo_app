import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/datasource.dart';

class TodoList extends ChangeNotifier {
  late List<Todo> _todos = [];

  //protected copy of the list
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  TodoList() {
    refresh();
  }

  int get completedTodos {
    int completed = 0;
    for (Todo todo in _todos){
      if(!todo.complete){
        completed += 1;
      }
    }
    return completed;
  }

  void add(Todo todo) async{
    await GetIt.I<IDataSource>().add(todo);
    await refresh();
    notifyListeners();
  }

  void remove(Todo todo) async{
    await GetIt.I<IDataSource>().delete(todo);
    await refresh();
    notifyListeners();
  }

  void update(Todo todo) async{
    await GetIt.I<IDataSource>().edit(todo);
    await refresh();
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      _todos = await GetIt.I<IDataSource>().browse();
      log(_todos.toString());
      notifyListeners();
    }
    catch(e) {
      // ignore: avoid_print
      print('Failed to browse todos: $e');
    }
  }
}