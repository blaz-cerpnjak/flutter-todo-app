import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/add_task_page.dart';
import 'package:todo_app/pages/history_page.dart';
import 'package:todo_app/routes/locator.dart';
import 'package:todo_app/routes/navigation_service.dart';
import 'package:todo_app/widgets/todo_item_widget.dart';

import '../theme/theme_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final listKey = GlobalKey<AnimatedListState>();
  final NavigationService _navigationService = locator<NavigationService>();
  late List<Task> tasks;
  bool isLoading = false;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    setTodoList();
    _isDark = context.read<ThemeManager>().themeMode == ThemeMode.dark;
  }

  Future setTodoList() async {
    setState(() => isLoading = true);
    tasks = await Hive.box<Task>("tasks").values.toList().cast<Task>();
    tasks.sort((a, b) { 
      if (b.completed) {
        return 1;
      } else {
        return -1;
      } 
    });
    setState(() => isLoading = false);
  }

  void onChecked(int position) {
    final task = tasks[position];
    task.completed = !task.completed;
    task.save();
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
          ? Text(
              'No tasks.',
              style: Theme.of(context).textTheme.subtitle2,
            )
          : buildAnimatedTodoList(tasks),
      ),
  );

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      title: Text(
        'Home',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () { 
            context.read<ThemeManager>().toggleTheme(_isDark);
            if (context.read<ThemeManager>().themeMode == ThemeMode.dark) {
              context.read<ThemeManager>().toggleTheme(false);
              _isDark = false;
            } else {
              context.read<ThemeManager>().toggleTheme(true);
              _isDark = true;
            }
          },
          icon: _isDark ? const Icon(Icons.light_mode_rounded) : const Icon(Icons.dark_mode_rounded)
        ),
      ],
    );
  }

  Widget buildAnimatedTodoList(final tasks) => ValueListenableBuilder(
    valueListenable: Hive.box<Task>('tasks').listenable(),
    builder: (context, box, _) {
      return AnimatedList(
        key: listKey,
        initialItemCount: tasks.length,
        itemBuilder: (context, index, animation) => TodoItemWidget(
          task: tasks[index],
          isEditable: true, 
          animation: animation,
          onUpdate: () => onChecked(index),
          onTap: () => _navigationService.navigateTo('/taskInfo', arguments: tasks[index]),
        )
      );
    }
  );
}