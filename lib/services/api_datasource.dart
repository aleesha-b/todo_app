import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/services/datasource.dart';

class ApiDatasource implements IDataSource {
  late FirebaseDatabase database;
  late Future init;

  ApiDatasource() {
    init = Future(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
      database = FirebaseDatabase.instance;
    });
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    List<Todo> todos = <Todo>[];
    final DataSnapshot snapshot = await database.ref('todos').get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> snapshotValue = snapshot.value as Map;
      if (snapshotValue.isNotEmpty) {
        snapshotValue.forEach((key, map) {
          map['id'] = key;
          map['complete'] = map['complete'] == 1 ? true : false;
          todos.add(Todo.fromMap(map));
        });
      }
    }
    return todos;
  }

  @override
  Future<void> edit(Todo todo) async {
    await init;
    var ref = database.ref('todos').child(todo.id);
    Map<String, dynamic> todoMap = todo.toMap();
    todoMap['complete'] = todoMap['complete'] == 1 ? true : false;
    await ref.set(todoMap);
  }

  @override
  Future<void> add(Todo todo) async {
    await init;
    var ref = database.ref('todos').push();
    Map<String, dynamic> todoMap = todo.toMap();
    todoMap['id'] = ref.key;
    todoMap['complete'] = false;
    await ref.set(todoMap);
  }

  @override
  Future<void> delete(Todo todo) async {
    await init;
    var ref = database.ref('todos').child(todo.id);
    await ref.remove();
  }
}