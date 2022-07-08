import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../routes/route_generator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  void navigateToPage(int index) {
    switch (index) {
      case 0: { 
        setState(() { _currentIndex = 0; });
        _navigatorKey.currentState!.pushNamed('/'); 
        break;
      }
      case 1: { 
        setState(() { _currentIndex = 1; });
        _navigatorKey.currentState!.pushNamed('/addTask'); 
        break;
      }
      case 2: {
        setState(() { _currentIndex = 2; });
        _navigatorKey.currentState!.pushNamed('/history'); 
        break;  
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      bottomNavigationBar: buildBottomAppBar(
        currentIndex: _currentIndex,
        onTap: navigateToPage,
      ),
    );
  }

  Widget buildBottomAppBar({
    required int currentIndex, 
    required Function(int) onTap
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_rounded), 
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.add_rounded), 
            title: const Text('Add Task'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history_rounded), 
            title: const Text('History'),
          ),
        ]
      ),
    );
  }
}