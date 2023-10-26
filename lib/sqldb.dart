// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'local.db');
    Database mydb = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return mydb;
  }

  void _onUpgrade(Database db, int oldversion, int newversion) async {
    if (oldversion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN date TEXT');
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "notes" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "title" TEXT,
      "note" TEXT, 
      "date" TEXT
    )
''');
    print('the database and table had been created');
  }

  Future<void> addNote(String title, String note, String date) async {
    final db = await this.db;
    await db!.insert('notes', {'title': title, 'note': note, 'date': date});
  }

  Future<void> updateNote(int id, String title, String note, String date) async {
    final db = await this.db;
    await db!.update(
      'notes',
      {'title': title, 'note': note, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getNote() async {
    final db = await this.db;
    return db!.query('notes');
  }

  Future<void> clearTable() async {
    final db = await this.db;
    await db!.delete('notes');
    print('the table have been cleaned');
  }
}
