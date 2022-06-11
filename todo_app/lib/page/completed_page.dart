import 'package:flutter/material.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Completed tasks'),
    ),
    body: Center(child: Text('Completed tasks')),
  );
}