import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/datasource.dart';
import 'package:path/path.dart';

class SQLDataSource implements IDataSource {
  late Database database;
  late Future init;

  SQLDataSource() {
    init = initialise();
  }

  Future<void> initialise() async {
    database = await openDatabase(
      join(await getDatabasesPath(),'todo_data.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)');
      },
    );
  }

  @override
  Future<void> add(Todo todo) async {
    await init;
    Map<String, dynamic> map = todo.toMap();
    log(map.toString());
    map.remove('id');
    await database.insert('todos', map);
  }

  @override
  Future<List<Todo>> browse() async {
    await init;
    List<Map<String, dynamic>> maps = await database.query('todos');
    return List.generate(maps.length, (i) {
      log(maps[i].toString());
      return Todo.fromMap(maps[i]);
    });
  }

  @override
  Future<void> delete(Todo todo) async {
    await init;
    await database.delete(
      'todos', 
      where: 'id = ?', 
      whereArgs: [todo.id]);
  }

  @override
  Future<void> edit(Todo todo) async{
    await init;
    await database.update(
      'todos', 
      todo.toMap(), 
      where: 'id = ?', 
      whereArgs: [todo.id],);

  }
}