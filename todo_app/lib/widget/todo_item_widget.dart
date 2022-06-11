import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';

class TodoItemWidget extends StatefulWidget {
  final Todo todo;
  bool isChecked = false;
  final bool isEditable;
  final Function onUpdate;
  final Function onDelete;

  TodoItemWidget({
    required this.todo, 
    required this.isEditable,
    required this.onUpdate, 
    required this.onDelete,
    Key? key}) : super(key: key);

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {

  @override
  void initState() {
    widget.isChecked = widget.todo.isCompleted;
    super.initState();
  }

  void onChecked(bool? value) {
    if (widget.isEditable) {
      setState(() {
        widget.isChecked = value!; 
        widget.onUpdate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            child: Checkbox(
              value: widget.isChecked, 
              onChanged: (bool? value) => onChecked(value),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.todo.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(widget.todo.formattedInputDate),
              ],
            )
          ),
          Visibility(
            visible: widget.isEditable,
            child: IconButton(
              onPressed: () => {
                widget.onDelete()
              }, 
              icon: Icon(Icons.close)
            ),
          )
        ]
      ),
    );
  }
}