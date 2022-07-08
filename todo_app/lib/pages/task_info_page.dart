import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskInfoPage extends StatefulWidget {
  final Task task;

  const TaskInfoPage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskInfoPage> createState() => _TaskInfoPageState();
}

class _TaskInfoPageState extends State<TaskInfoPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
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
            controller: titleController, 
            hint: 'Title',
            hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: Colors.grey,
            ),
            textStyle: Theme.of(context).textTheme.subtitle1!,
            maxLines: 1,
          ),
          buildTextField(
            controller: descriptionController, 
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
        onPressed: () {},
        icon: const Icon(Icons.done_rounded),
        label: const Text('Mark as Done')
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