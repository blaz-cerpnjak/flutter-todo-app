import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:date_format/date_format.dart';

class TodoItemWidget extends StatefulWidget {
  final Task task;
  bool isChecked = false;
  final bool isEditable;
  final Function onUpdate;
  final Function() onTap;

  TodoItemWidget({
    required this.task, 
    required this.isEditable,
    required this.onUpdate, 
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {

  @override
  void initState() {
    widget.isChecked = widget.task.isCompleted;
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
    return buildItem();
  }
  
  Widget buildItem() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      children: [
        InkWell(
          onTap: () => widget.onUpdate(),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: widget.task.isCompleted ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: widget.task.isCompleted ? null : Border.all(
                color: Colors.grey,
                width: 1.5
              )
            ),
            child: widget.task.isCompleted 
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
              : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: InkWell(
            onTap: widget.onTap,
            child: Text(
              widget.task.title,
              style: TextStyle(
                color: widget.task.isCompleted ? Theme.of(context).primaryColor : Colors.grey,
                fontWeight: widget.task.isCompleted ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ]
    ),
  );
}