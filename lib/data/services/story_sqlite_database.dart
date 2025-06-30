import 'package:sqflite/sqflite.dart';

abstract class StorySqliteDatabase {
  static const String _databaseName = "story.db";
  static const int _version = 2;
  static Database? _database;

  static Future<void> _createTables(Database database) async {
    await database.execute("""CREATE TABLE favorite(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       storyId TEXT NOT NULL UNIQUE
     )
     """);

    await database.execute("""CREATE TABLE story(
       id TEXT PRIMARY KEY,
       name TEXT,
       description TEXT,
       photoUrl TEXT,
       createdAt TEXT,
       lat REAL,
       lon REAL
     )
     """);
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await _createTables(database);
      },
    );

    return _database!;
  }
}
