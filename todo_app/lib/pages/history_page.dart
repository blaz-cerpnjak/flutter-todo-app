import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task_model.dart';
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
    tasks.retainWhere((task) => task.completed);
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
          onUpdate: () {}, 
          onTap: () {},
      ),
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).backgroundColor,
    appBar: buildAppBar(),
    body: Center(
      child: isLoading 
      ? const CircularProgressIndicator()
      : tasks.isEmpty
        ? const Text('No tasks.')
        : buildAnimatedTaskList(tasks),
    ),
  );

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      title: Text(
        'History',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      centerTitle: true,
    );
  }

  Widget buildAnimatedTaskList(final tasks) => ListView.builder(
    key: listKey,
    itemCount: tasks.length,
    itemBuilder: (context, index) => TodoItemWidget(
      task: tasks[index], 
      isEditable: true,
      onUpdate: () => () {},
      onTap: () => () {},
    ),
  );
}