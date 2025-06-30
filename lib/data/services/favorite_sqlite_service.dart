import 'package:sqflite/sqflite.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_sqlite_database.dart';

class FavoriteSqliteService {
  static const String _tableName = "favorite";

  Future<int> insertItem(Story story) async {
    final db = await StorySqliteDatabase.database;
    final insertedId = await db.insert(_tableName, {
      "storyId": story.id,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    if (insertedId == 0) throw Exception("Can't insert item");
    return insertedId;
  }

  Future<List<Story>> getAllItems() async {
    final db = await StorySqliteDatabase.database;
    final results = await db.rawQuery("""SELECT story.*
      FROM story
      INNER JOIN favorite ON story.id = favorite.storyId
      ORDER BY favorite.id DESC
    """);
    return results.map((result) => Story.fromJson(result)).toList();
  }

  Future<Story?> getItemByStoryId(String id) async {
    final db = await StorySqliteDatabase.database;
    final results = await db.rawQuery(
      """SELECT story.*
      FROM story
      INNER JOIN favorite ON story.id = favorite.storyId
      WHERE favorite.storyId = ?
      LIMIT 1
    """,
      [id],
    );

    if (results.isEmpty) throw Exception("Item not found");
    return results.map((result) => Story.fromJson(result)).first;
  }

  Future<int> removeItemByStoryId(String id) async {
    final db = await StorySqliteDatabase.database;
    final deletedId = await db.delete(
      _tableName,
      where: "storyId = ?",
      whereArgs: [id],
    );
    if (deletedId == 0) throw Exception("Can't delete item");
    return deletedId;
  }
}
