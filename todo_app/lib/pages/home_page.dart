import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/routes/locator.dart';
import 'package:todo_app/routes/navigation_service.dart';
import 'package:todo_app/widgets/todo_item_widget.dart';
import 'package:week_of_year/week_of_year.dart';
import '../theme/theme_manager.dart';
import '../widgets/circle_tab_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _navigationService = locator<NavigationService>();
  late List<Task> tasks;
  bool isLoading = false;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    setTodoList(0);
    _isDark = context.read<ThemeManager>().themeMode == ThemeMode.dark;
  }

  bool isToday(Task task) {
    return formatDate(task.created, [dd, '-', MM, '-', yyyy]) == formatDate(DateTime.now(), [dd, '-', MM, '-', yyyy]);
  }

  bool isThisWeek(Task task) {
    return task.created.weekOfYear == DateTime.now().weekOfYear;
  }

  bool isThisMonth(Task task) {
    return formatDate(task.created, [MM, '-', yyyy]) == formatDate(DateTime.now(), [MM, '-', yyyy]);
  }

  Future setTodoList(int index) async {
    setState(() => isLoading = true);
    tasks = await Hive.box<Task>("tasks").values.toList().cast<Task>();

    switch (index) {
      case 0: tasks.retainWhere((task) => isToday(task)); break;
      case 1: tasks.retainWhere((task) => isThisWeek(task)); break;
      case 2: tasks.retainWhere((task) => isThisMonth(task)); break;
    }

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

  @override
  Widget build(BuildContext context) {
    final tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: isLoading ? const Center(child: CircularProgressIndicator())
        : tasks.isEmpty
          ? Text(
              'No tasks.',
              style: Theme.of(context).textTheme.subtitle2,
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildContent(tabController),
              //buildAnimatedTodoList(tasks),
            ],
          )
    );
  }

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

  Widget buildContent(TabController tabController) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hey Blaz,', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(height: 3),
        Text("Let's be productive today!", style: Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w400
        )),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey),
        const SizedBox(height: 5),
        TabBar(
          controller: tabController,
          labelColor: Theme.of(context).primaryColor,
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          indicator: CircleTabIndicator(color: Theme.of(context).primaryColor, radius: 3),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
          onTap: (index) => setTodoList,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: TabBarView(
              controller: tabController,
              children: [
                buildTodoList(tasks),
                buildTodoList(tasks),
                buildTodoList(tasks),
              ]
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildTodoList(final tasks) => ValueListenableBuilder(
    valueListenable: Hive.box<Task>('tasks').listenable(),
    builder: (context, box, _) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (context, index) => TodoItemWidget(
          task: tasks[index],
          isEditable: true, 
          onUpdate: () => onChecked(index),
          onTap: () => _navigationService.navigateTo('/taskInfo', arguments: tasks[index]),
        )
      );
    }
  );
}