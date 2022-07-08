import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:date_format/date_format.dart';

class TodoItemWidget extends StatefulWidget {
  final Task task;
  bool isChecked = false;
  final bool isEditable;
  final Function onUpdate;
  final Function onDelete;
  final Animation<double> animation;

  TodoItemWidget({
    required this.task, 
    required this.isEditable,
    required this.animation,
    required this.onUpdate, 
    required this.onDelete,
    Key? key}) : super(key: key);

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {

  @override
  void initState() {
    widget.isChecked = widget.task.completed;
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
  Widget build(BuildContext context) => SizeTransition(
    sizeFactor: widget.animation,
    child: buildItem(),
  );
  
  Widget buildItem() => Card(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
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
                  widget.task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(formatDate(widget.task.created, [dd, '-', mm, '-', yyyy])),
              ],
            )
          ),
          IconButton(
            onPressed: () => {
              widget.onDelete()
            }, 
            icon: Icon(Icons.close)
          ),
        ]
      ),
    );
  }