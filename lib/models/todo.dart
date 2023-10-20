import 'dart:developer';

import 'package:todo_app/models/todo_hive.dart';

class Todo {
  late String id;
  final String name;
  final String description;
  bool complete;

  Todo({this.id = '', required this.name, required this.description, this.complete = false});

  @override
  String toString() {
    return "$name - $description (Complete: $complete)";
  }

  Map<String, dynamic> toMap(){
  return {
    'id': id,
    'name': name,
    'description':description,
    'complete': complete ? 1 : 0,
    };
  }

   HiveTodo toHiveTodo() {
    return HiveTodo(
        name: name,
        description: description,
        complete: complete);
  }

  factory Todo.fromMap(Map<dynamic, dynamic> mapData) {
    String id;
    bool completed;
    log(mapData.toString());
    if (mapData['complete'] is int) {
      completed = mapData['complete'] == 1 ? true : false;
    } else {
      completed = mapData['complete'];
    }
    if (mapData['id'] is int) {
      id = mapData['id'].toString();
    } else {
      id = mapData['id'];
    }
    return Todo(
      id: id, 
      name :mapData['name'], 
      description: mapData['description'], 
      complete: completed,
    );
  }
}