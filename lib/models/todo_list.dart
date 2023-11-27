// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/datasource.dart';

class TodoList extends ChangeNotifier {
  late List<Todo> _todos = [];

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
    try {
      await GetIt.I<IDataSource>().add(todo);
      await refresh();
    }
    catch (e) {
      print('Failed to add to-do. Error: $e');
    }
    notifyListeners();
  }

  void remove(Todo todo) async{
    try {
      await GetIt.I<IDataSource>().delete(todo);
      await refresh();
    }
    catch (e) {
      print('Failed to remove to-do. Error: $e');
    }
    notifyListeners();
  }

  void update(Todo todo) async{
    try {
      await GetIt.I<IDataSource>().edit(todo);
      await refresh(); 
    }
    catch (e) {
      print("Failed to update to-do. Error: $e");
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      _todos = await GetIt.I<IDataSource>().browse();
      log(_todos.toString());
      notifyListeners();
    }
    catch(e) {
      print('Failed to load to-dos. Error: $e');
    }
  }
}