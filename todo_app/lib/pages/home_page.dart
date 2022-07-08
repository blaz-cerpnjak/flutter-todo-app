import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/add_task_page.dart';
import 'package:todo_app/pages/history_page.dart';
import 'package:todo_app/widgets/todo_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> tasks;
  final listKey = GlobalKey<AnimatedListState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setTodoList();
  }

  Future setTodoList() async {
    setState(() => isLoading = true);
    tasks = await Hive.box<Task>("tasks").values.toList().cast<Task>();
    setState(() => isLoading = false);
  }

  void onChecked(int position) async {
    await Future.delayed(const Duration(seconds: 1));

    final task = tasks[position];
    task.completed = true;

    task.save();
    tasks.removeAt(position);

    listKey.currentState!.removeItem(
      position, 
      (context, animation) => TodoItemWidget(
          task: task,
          isEditable: false,
          animation: animation, 
          onUpdate: () {}, 
          onDelete: () {},
      ),
      duration: const Duration(milliseconds: 200),
    );
  }

  void onDelete(int position) async {
    final task = tasks[position];

    task.delete();
    tasks.removeAt(position);

    listKey.currentState!.removeItem(
      position, 
      (context, animation) => TodoItemWidget(
          task: task,
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
      title: const Text('Home'),
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
        : tasks.isEmpty
          ? const Text('No tasks.')
          : buildAnimatedTodoList(tasks),
      ),
  );

  Widget buildAnimatedTodoList(final tasks) => AnimatedList(
    key: listKey,
    initialItemCount: tasks.length,
    itemBuilder: (context, index, animation) => TodoItemWidget(
      task: tasks[index],
      isEditable: true, 
      animation: animation,
      onUpdate: () => onChecked(index),
      onDelete: () => onDelete(index),
    ),
  );
}