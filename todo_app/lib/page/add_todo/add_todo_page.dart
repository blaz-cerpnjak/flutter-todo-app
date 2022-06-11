import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String text = '';

  void onTextChanged(String text) {
    setState(() {
      this.text = text;
    });
  }

  void addTodoItem(BuildContext context) {
    final Todo todo = new Todo(text);
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text("Task added."),
        action: SnackBarAction(label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Add Task'),
    ),
    body: Column(
      children: <Widget>[
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'New Task',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            onChanged: (text) => onTextChanged(text),
          ),
        ),
        ElevatedButton(
          onPressed: () => {
            addTodoItem(context),
          },
          child: Text('Insert'),
        )
      ]
    ),
  );
}