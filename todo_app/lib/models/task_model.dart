import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime created;

  @HiveField(3)
  bool completed; 

  Task({
    required this.title,
    required this.description,
    required this.created,
    this.completed = false,
  });
}