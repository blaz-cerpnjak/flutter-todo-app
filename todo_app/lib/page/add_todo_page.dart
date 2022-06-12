import 'package:flutter/material.dart';
import 'package:todo_app/db/local/todos_database.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/home_page.dart';

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

  void addTodoItem(BuildContext context) async {
    final Todo todo = new Todo(text: text, inputDate: DateTime.now());

    await TodosDatabase.instance.create(todo);

    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(
        builder: (context) => HomePage()
      ),
      (route) => false
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
            style: TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
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