import 'package:sqflite/sqflite.dart';
import 'package:story_app/data/model/story.dart';

class SqliteService {
  static const String _databaseName = "story.db";
  static const String _tableName = "favorite";
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE $_tableName(
       favoriteId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       id TEXT,
       name TEXT,
       description TEXT,
       photoUrl TEXT,
       createdAt TEXT,
       lat REAL,
       lon REAL
     )
     """,
    );
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(Story story) async {
    final db = await _initializeDb();

    final data = story.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Story>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "favoriteId DESC");

    return results.map((result) => Story.fromJson(result)).toList();
  }

  Future<Story?> getItemByStoryId(String id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return results.map((result) => Story.fromJson(result)).first;
  }

  Future<int> removeItemByStoryId(String id) async {
    final db = await _initializeDb();

    final result = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }
}
