import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:todo_app/db/local/todos_database.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/add_todo_page.dart';
import 'package:todo_app/page/history_page.dart';
import 'package:todo_app/widget/todo_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Todo> todoList;
  final listKey = GlobalKey<AnimatedListState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setTodoList();
  }

  Future setTodoList() async {
    setState(() => isLoading = true);
    todoList = await TodosDatabase.instance.readAllTodos();
    debugPrint(todoList.length.toString());
    setState(() => isLoading = false);
  }

  void onChecked(int position) async {
    await Future.delayed(const Duration(seconds: 1));
    Todo todo = todoList[position];
    todo.isCompleted = true;
    TodosDatabase.instance.update(todo);
    setState(() => todoList.removeAt(position));   
  }

  void onDelete(int position) async {
    final Todo todo = todoList[position];
    TodosDatabase.instance.delete(todo.id!);
    //setState(() => todoList.removeAt(position));
    todoList.removeAt(position);
    listKey.currentState!.removeItem(
      position, 
      (context, animation) => TodoItemWidget(
          todo: todo, 
          isEditable: false,
          animation: animation, 
          onUpdate: () {}, 
          onDelete: () {},
      ),
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Home'),
      actions: [
        IconButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage()),
            ),
          },
          icon: Icon(Icons.history_rounded)
        ),
      ],
    ),
    body: Center(
        child: isLoading 
        ? CircularProgressIndicator()
        : todoList.isEmpty
          ? Text('No todo items.')
          : buildAnimatedTodoList(),
      ),
    floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTodoPage()),
            ),
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
  );

  /*Widget buildTodoList() => ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return TodoItemWidget(
          todo: todoList[index],
          isEditable: true,
          onUpdate: () => onChecked(index),
          onDelete: () => onDelete(index),
        );
      }
    );*/

  Widget buildAnimatedTodoList() => AnimatedList(
    key: listKey,
    initialItemCount: todoList.length,
    itemBuilder: (context, index, animation) => TodoItemWidget(
      todo: todoList[index], 
      isEditable: true, 
      animation: animation,
      onUpdate: () => onChecked(index),
      onDelete: () => onDelete(index),
    ),
  );
}