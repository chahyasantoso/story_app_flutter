import 'package:sqflite/sqflite.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_sqlite_database.dart';

class StorySqliteService {
  static const String _tableName = "story";

  Future<void> insertAll(List<Story> listStory) async {
    final db = await StorySqliteDatabase.database;
    final batch = db.batch();

    for (final story in listStory) {
      batch.insert('story', story.toJson());
    }
    await batch.commit(noResult: true, continueOnError: true);

    // // print all the tables
    // final list = await db.rawQuery("SELECT * from story");
    // for (final item in list) {
    //   print(item);
    // }
  }

  Future<int> updateItemByStoryId(String id, Story updatedStory) async {
    final db = await StorySqliteDatabase.database;

    final updatedId = await db.update(
      _tableName,
      updatedStory.toJson()..remove('id'),
      where: "id = ?",
      whereArgs: [id],
    );
    if (updatedId == 0) throw Exception("Can't update item");
    return updatedId;
  }

  Future<int> insertItem(Story story) async {
    final db = await StorySqliteDatabase.database;

    final id = await db.insert(
      _tableName,
      story.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (id == 0) throw Exception("Can't insert item");
    return id;
  }

  Future<List<Story>> getAllItems({
    int? page,
    int? size,
    int? location = 0,
  }) async {
    final db = await StorySqliteDatabase.database;

    String? where;
    if (location == 1) {
      where = "lat IS NOT NULL AND lon IS NOT NULL";
    }

    int? offset;
    if (page != null && size != null) {
      offset = (page - 1) * size;
    }

    final results = await db.query(
      _tableName,
      where: where,
      orderBy: 'createdAt DESC',
      limit: size,
      offset: offset,
    );

    return results.map((result) => Story.fromJson(result)).toList();
  }

  Future<Story> getItemByStoryId(String id) async {
    final db = await StorySqliteDatabase.database;

    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) throw Exception("Item not found");
    return results.map((result) => Story.fromJson(result)).first;
  }

  Future<int> removeItemByStoryId(String id) async {
    final db = await StorySqliteDatabase.database;

    final deletedId = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedId == 0) throw Exception("Can't delete item");
    return deletedId;
  }
}
