import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Notesdb {
  static final Notesdb instance = Notesdb._init();

  static Database? _database;

  Notesdb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb('notes.db');
    return _database!;
  }

  Future<Database> _initDb(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        color INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> addNote(
    String title,
    String content,
    String date,
    int color,
  ) async {
    final db = await instance.database;
    return await db.insert('notes', {
      'title': title,
      'content': content,
      'date': date,
      'color': color,
    });
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await instance.database;
    return await db.query('notes', orderBy: 'date DESC');
  }

  Future<int> updateNote(
    int id,
    String title,
    String content,
    String date,
    int color,
  ) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      {'title': title, 'content': content, 'date': date, 'color': color},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
