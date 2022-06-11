import 'package:intl/intl.dart';

final String tableTodos = 'todos';

class TodoFields {
  static final List<String> values = [
    id, inputDate, text
  ];
  static final String id = '_id';
  static final String inputDate = 'inputDate';
  static final String text = 'text';
}

class Todo {
  final int? id;
  final DateTime inputDate;
  final String text;

  const Todo({
    this.id, 
    required this.inputDate, 
    required this.text,
  });

  static Todo fromJson(Map<String, Object?> json) => Todo(
    id: json[TodoFields.id] as int?,
    inputDate: DateTime.parse(json[TodoFields.inputDate] as String) as DateTime,
    text: json[TodoFields.text] as String,
  );

  Map<String, Object?> toJson() => {
    TodoFields.id: id,
    TodoFields.inputDate: inputDate.toIso8601String(),
    TodoFields.text: text,
  };

  Todo copy({
    int? id,
    DateTime? inputDate,
    String? text,
  }) => Todo(
    id: id ?? this.id,
    inputDate: inputDate ?? this.inputDate,
    text: text ?? this.text,
  );
}