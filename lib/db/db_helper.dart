import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'note_class.dart';

class DBHelper {
  static Database? database;

  static Future<void> open() async {
    database = await openDatabase(join(await getDatabasesPath(), 'notedb.db'),
        version: 1, onCreate: (Database db, int version) async {
      return db.execute(
          'CREATE TABLE notes(id INT PRIMARY KEY, title TEXT NOT NULL, note TEXT, imgLoc TEXT)');
    });
  }

  static Future<Map<String, dynamic>> insertNote(Note note) async {
    final db = database;
    try {
      await db!.insert('notes', note.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return <String, dynamic>{
        'success': true,
        'message': 'Successfully created note.',
      };
    } catch (e) {
      return <String, dynamic>{
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<List<Note>> getNoteList() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db!.query('notes');
    return List.generate(maps.length, (index) {
      return Note(
        id: maps[index]['id'],
        title: maps[index]['title'].toString(),
        note: maps[index]['note'].toString(),
        imgLoc: maps[index]['imgLoc'].toString(),
      );
    });
  }

  static Future<void> updateNote(Note note) async {
    final db = database;
    await db!
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
