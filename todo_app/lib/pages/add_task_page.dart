import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/pages/home_page.dart';
import '../models/task_model.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void addTodoItem(BuildContext context) async {
    final task = Task(
      title: titleController.text,
      description: descriptionController.text,
      created: DateTime.now()
    );

    Box<Task> tasksBox = Hive.box<Task>("tasks");

    tasksBox.add(task);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Add Task'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: titleController,
            style: TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Title',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 5,
          ),
          TextFormField(
            controller: descriptionController,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
          ),
          ElevatedButton(
            onPressed: () => {
              addTodoItem(context),
            },
            child: Text('Insert'),
          )
        ]
      ),
    ),
  );
}