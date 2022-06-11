import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final String tableTodos = 'todos';

class TodoFields {
  static final List<String> values = [
    id, inputDate, text
  ];
  static final String id = '_id';
  static final String inputDate = 'inputDate';
  static final String text = 'text';
  static final String isCompleted = 'isCompleted';
}

class Todo {
  final int? id;
  final DateTime inputDate;
  String text;
  bool isCompleted;

  Todo({
    this.id, 
    this.isCompleted = false,
    required this.inputDate, 
    required this.text,
  });

  String get formattedInputDate {
     return DateFormat( "dd.MM.yyyy").format(inputDate);
  }

  static Todo fromJson(Map<String, Object?> json) => Todo(
    id: json[TodoFields.id] as int?,
    isCompleted: json[TodoFields.isCompleted] == 1,
    inputDate: DateTime.parse(json[TodoFields.inputDate] as String) as DateTime,
    text: json[TodoFields.text] as String,
  );

  Map<String, Object?> toJson() => {
    TodoFields.id: id,
    TodoFields.isCompleted: isCompleted ? 1 : 0,
    TodoFields.inputDate: inputDate.toIso8601String(),
    TodoFields.text: text,
  };

  Todo copy({
    int? id,
    bool? isCompleted,
    DateTime? inputDate,
    String? text,
  }) => Todo(
    id: id ?? this.id,
    isCompleted: isCompleted ?? this.isCompleted,
    inputDate: inputDate ?? this.inputDate,
    text: text ?? this.text,
  );
}