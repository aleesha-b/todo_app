import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_list.dart';
import 'package:todo_app/services/api_datasource.dart';
import 'package:todo_app/services/datasource.dart';
import 'package:todo_app/services/hive_datasource.dart';
import 'package:todo_app/services/sql_datasource.dart';
import 'package:todo_app/widgets/todo_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<IDataSource>(
    //SQLDataSource(),
    //HiveDatasource(),
    ApiDatasource(),
    signalsReady: true
  );
  runApp(ChangeNotifierProvider(
    create: (context) => TodoList(),
    child: const TodoApp(),
    ));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "To-Do App",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<TodoList>(builder: (context, model, child){
          return Text('Not completed: ${model.completedTodos}');
        }
      ),
      ),
      body: Center(
        child: Consumer<TodoList>(
          builder: (context, model, child) {
          return RefreshIndicator(
            onRefresh: model.refresh,
            child: ListView.builder(
              itemCount: model.todoCount,
              itemBuilder: (context, index) {
                return TodoWidget(
                  todo: model.todos[index],
                  colour: index%2 == 0 ? const Color.fromARGB(255, 213, 213, 213) : const Color.fromARGB(255, 177, 176, 176));
              }),
          );
        }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
         child: const Icon(Icons.add),
         ),
    );
  }

  void _addTodo() {
    showDialog(context: context, builder: (builder) {
      return AlertDialog(
        title: const Text('Create To-Do'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(4),
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
            child: ElevatedButton(onPressed: () {
              setState(() {
                Provider.of<TodoList>(context, listen: false).add(
                  Todo(
                    name: _controllerName.text, 
                    description: _controllerDescription.text));
              });
              Navigator.pop(context);
              _controllerDescription.clear();
              _controllerName.clear();
            },
            child: const Text('Save')),
          )
        ],
      )
      );
    });
  }
}