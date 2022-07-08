import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/main_page.dart';
import 'package:todo_app/routes/locator.dart';
import 'package:todo_app/routes/navigation_service.dart';

import 'theme/theme_constants.dart';
import 'theme/theme_manager.dart';

late Box box;

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Task>(TaskAdapter());
  box = await Hive.openBox<Task>("tasks");

  GetIt.instance.registerSingleton<NavigationService>(NavigationService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManager()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: context.watch<ThemeManager>().themeMode,
          home: const MainPage(),
        );
      }
    );
  }
}
