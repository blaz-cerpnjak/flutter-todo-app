import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/pages/add_task_page.dart';
import 'package:todo_app/pages/history_page.dart';

import '../pages/home_page.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case '/': 
        return PageTransition(child: const HomePage(), type: PageTransitionType.fade);

      case '/addTask': 
        return PageTransition(child: const AddTaskPage(), type: PageTransitionType.fade);

      case '/history':
        return PageTransition(child: const HistoryPage(), type: PageTransitionType.fade);

      default: 
        return _errorRoute();
    }

  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Oops'),
        ),
        body: const Center(
          child: Text('Oops.. Something went wrong.'),
        ),
      );
    });
  }

}