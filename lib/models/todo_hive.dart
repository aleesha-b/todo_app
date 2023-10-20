import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/todo.dart';

class HiveTodo extends HiveObject {
  @HiveType(typeId: 0)
  String name;
  @HiveType(typeId: 1)
  String description;
  @HiveType(typeId: 2)
  bool complete;

  HiveTodo({
    required this.name,
    required this.description,
    this.complete = false,
  });

  @override
  String toString() {
    return "$name - $description (Completed: $complete) ";
  }

  Todo toAppTodo() {
    return Todo(
        id: key.toString(),
        name: name,
        description: description,
        complete: complete,
        );
  }
}

class HiveToDoAdaptor extends TypeAdapter<HiveTodo> {
  @override
  HiveTodo read(BinaryReader reader) {
    return HiveTodo(
      name: reader.read(0),
      description: reader.read(1),
      complete: reader.read(2),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HiveTodo obj) {
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.complete);
  }
}