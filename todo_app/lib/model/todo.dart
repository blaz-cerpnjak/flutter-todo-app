import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Todo {
  final String id = Uuid().v1();
  final DateTime _inputDate = DateTime.now();
  String text;

  Todo(this.text);

  String get inputDate {
    return DateFormat.yMd(Intl.systemLocale).format(_inputDate);
  }

}