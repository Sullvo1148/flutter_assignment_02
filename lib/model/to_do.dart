///
/// `to_do_provider.dart`
/// Class contains data of to-do provider
///

import 'dart:async';
import 'package:sqflite/sqflite.dart';

class ToDo {
  int _id;
  String _title;
  bool _done;

  ToDo({String title}) {
    this._title = title;
    this._done = false;
  }

  ToDo.fromMap(Map<String, dynamic> map) {
    _id = map[ToDoProvider.columnId];
    _title = map[ToDoProvider.columnTitle];
    _done = map[ToDoProvider.columnDone] == 1;
  }

  int get id => this._id;
  set id(int id) => this._id = id;

  String get title => this._title;
  set title(String title) => this._title = title;

  bool get done => this._done;
  set done(bool done) => this._done = done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      ToDoProvider.columnTitle: _title,
      ToDoProvider.columnDone: _done ? 1 : 0,
    };

    if (_id != null) {
      map[ToDoProvider.columnId] = _id;
    }

    return map;
  }
}

class ToDoProvider {
  static final String tableToDo = 'todo';
  static final String columnId = '_id';
  static final String columnTitle = 'title';
  static final String columnDone = 'done';

  Database _database;

  Database get database => this._database;

  Future open({String path = 'todo.db'}) async {
    String databasesPath = await getDatabasesPath();
    path = databasesPath + path;

    this._database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute('''
          CREATE TABLE $tableToDo (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDone INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<ToDo> insert(ToDo toDo) async {
    toDo.id = await this._database.insert(
          tableToDo,
          toDo.toMap(),
        );

    return toDo;
  }

  Future<ToDo> getToDo(int id) async {
    List<Map> maps = await this._database.query(
          tableToDo,
          columns: [columnId, columnTitle, columnDone],
          where: '$columnId = ?',
          whereArgs: [id],
        );

    if (maps.length > 0) {
      return ToDo.fromMap(maps.first);
    }

    return null;
  }

  Future<int> delete(int id) async {
    return await this._database.delete(
      tableToDo,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(ToDo toDo) async {
    await this._database.update(
      tableToDo,
      toDo.toMap(),
      where: '$columnId = ?',
      whereArgs: [toDo.id],
    );
  }

  // ⬇️ Additional query methods ⬇️
  Future<List<ToDo>> getAllTask() async {
    List<Map<String, dynamic>> data = await this._database.query(
          tableToDo,
          where: '$columnDone = 0',
        );
    return data.map((e) => ToDo.fromMap(e)).toList();
  }

  Future<List<ToDo>> getAllCompleted() async {
    List<Map<String, dynamic>> data = await this._database.query(
          tableToDo,
          where: '$columnDone = 1',
        );
    return data.map((e) => ToDo.fromMap(e)).toList();
  }

  void deleteAllCompleted() async {
    await this._database.delete(
          tableToDo,
          where: '$columnDone = 1',
        );
  }
  // ⬆️ Additional query methods ⬆️

  Future close() async {
    database.close();
  }
}
