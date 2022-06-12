import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_app/db/local/todos_database.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/add_todo_page.dart';
import 'package:todo_app/widget/todo_item_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
    todoList = await TodosDatabase.instance.readCompletedTodos();
    debugPrint(todoList.length.toString());
    setState(() => isLoading = false);
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
      title: Text('History'),
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

  Widget buildAnimatedTodoList() => AnimatedList(
    key: listKey,
    initialItemCount: todoList.length,
    itemBuilder: (context, index, animation) => TodoItemWidget(
      todo: todoList[index], 
      isEditable: true, 
      animation: animation,
      onUpdate: () => () {},
      onDelete: () => () {},
    ),
  );
}