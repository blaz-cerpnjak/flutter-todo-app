import 'package:flutter/material.dart';
import 'package:todo_app/db/local/todos_database.dart';
import 'package:todo_app/model/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Todo> todoList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  
    setTodoList();
  }

  @override
  void dispose() {
    TodosDatabase.instance.close();

    super.dispose();
  }

  Future setTodoList() async {
    setState(() => isLoading = true);

    this.todoList = await TodosDatabase.instance.readAllTodos();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Home'),
    ),
    body: ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.white,
          child: Center(
            child: Text(todoList[index].text)
          ),
        );
      },
    ),
  );
}