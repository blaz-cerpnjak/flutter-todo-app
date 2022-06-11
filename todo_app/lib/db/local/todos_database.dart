import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo.dart';

class TodosDatabase {
  static final TodosDatabase instance = TodosDatabase._init();

  static Database? _database;

  TodosDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute(
      '''
      CREATE TABLE $tableTodos (
        ${TodoFields.id} $idType,
        ${TodoFields.inputDate} $textType,
        ${TodoFields.text} $textType
      )
      '''
    );
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;

    final id = await db.insert(tableTodos, todo.toJson());

    return todo.copy(id: id);
  }

  Future<Todo?> readTodo(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTodos,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;

    final orderBy = '${TodoFields.inputDate} ASC';
    final result = await db.query(tableTodos, orderBy: orderBy);

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;

    return db.update(
      tableTodos, 
      todo.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTodos,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}