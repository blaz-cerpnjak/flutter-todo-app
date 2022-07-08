import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/routes/locator.dart';
import 'package:todo_app/routes/navigation_service.dart';
import '../models/task_model.dart';

class TaskInfoPage extends StatefulWidget {
  final Task task;

  const TaskInfoPage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskInfoPage> createState() => _TaskInfoPageState();
}

class _TaskInfoPageState extends State<TaskInfoPage> {
  final NavigationService _navigationService = locator<NavigationService>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
  }

  void onSave() {
    widget.task.title = _titleController.text;
    widget.task.description = _descriptionController.text;
    widget.task.save();

    Fluttertoast.showToast(
      msg: 'Task saved.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  void onDelete() {
    widget.task.delete();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          buildTextField(
            controller: _titleController, 
            hint: 'Title',
            hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Colors.grey,
            ),
            textStyle: Theme.of(context).textTheme.subtitle1!,
            maxLines: 1,
          ),
          buildTextField(
            controller: _descriptionController, 
            hint: 'Description',
            hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
            textStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w400
            ),
            maxLines: null
          ),
        ]
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
        onPressed: onSave,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Save')
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      title: Text(
        'Edit Task',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onDelete, 
          icon: const Icon(Icons.delete_rounded),
        ),
      ],
    );
  }
  
  Widget buildTextField({
    required TextEditingController controller,
    String hint = '',
    int? maxLines = 1,
    required TextStyle hintStyle,
    required TextStyle textStyle
  }) {
    return TextField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: hintStyle,
      ),
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
    );
  }
}