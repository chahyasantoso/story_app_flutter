import 'package:sqflite/sqflite.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_sqlite_database.dart';

class StorySqliteService {
  static const String _tableName = "story";

  Future<void> replaceAll(List<Story> listStory) async {
    final db = await StorySqliteDatabase.database;
    final batch = db.batch();

    batch.delete('story');
    for (final story in listStory) {
      batch.insert('story', story.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<int> insertItem(Story story) async {
    final db = await StorySqliteDatabase.database;

    final data = story.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Story>> getAllItems() async {
    final db = await StorySqliteDatabase.database;
    final results = await db.query(_tableName);
    return results.map((result) => Story.fromJson(result)).toList();
  }

  Future<Story?> getItemByStoryId(String id) async {
    final db = await StorySqliteDatabase.database;

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
    final db = await StorySqliteDatabase.database;

    final result = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }
}
