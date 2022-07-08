import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/add_task_page.dart';
import 'package:todo_app/widgets/todo_item_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<Task> tasks;
  final listKey = GlobalKey<AnimatedListState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setTasks();
  }

  Future<void> setTasks() async {
    setState(() => isLoading = true);
    tasks = Hive.box<Task>("tasks").values.toList().cast<Task>();
    setState(() => isLoading = false);
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
      duration: const Duration(milliseconds: 200),
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
      : tasks.isEmpty
        ? const Text('No tasks.')
        : buildAnimatedTaskList(tasks),
    ),
  );

  Widget buildAnimatedTaskList(final tasks) => AnimatedList(
    key: listKey,
    initialItemCount: tasks.length,
    itemBuilder: (context, index, animation) => TodoItemWidget(
      task: tasks[index], 
      isEditable: true, 
      animation: animation,
      onUpdate: () => () {},
      onDelete: () => onDelete(index),
    ),
  );
}