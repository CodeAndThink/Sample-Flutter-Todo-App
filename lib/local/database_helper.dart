import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/note_model.dart';

class DatabaseHelper {
  static Database? _database;

  // Sử dụng factory constructor để chỉ tạo ra một instance duy nhất
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'notes.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS notes (
            id INTEGER PRIMARY KEY,
            device_id TEXT,
            task_title TEXT NOT NULL,
            category INTEGER NOT NULL,
            content TEXT,
            status BOOLEAN NOT NULL,
            date TEXT NOT NULL,
            time TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveListNote(List<NoteModel> notes) async {
    await Future.forEach(notes, (note) async {
      await insertNote(note);
    });
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return db.insert('notes', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes');
    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteAllNotes() async {
    final db = await database;
    await db.delete('notes');
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
