import 'package:restaurant_app/data/model/favorite.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String _databaseName = 'restaurant.db';
  static const String _tableName = 'favorite';
  static const int _version = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE $_tableName(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       restaurantId TEXT,
       name TEXT,
       description TEXT,
       pictureId TEXT,
       city TEXT,
       rating REAL
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

  Future<int> insertItem(Favorite favorite) async {
    final db = await _initializeDb();

    final data = favorite.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Favorite>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id DESC");

    return results.map((result) => Favorite.fromJson(result)).toList();
  }

  Future<Favorite> getItemById(int id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    return results.map((result) => Favorite.fromJson(result)).first;
  }

  Future<Favorite> getItemByRestaurantId(String restaurantId) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "restaurantId = ?",
      whereArgs: [restaurantId],
      limit: 1,
    );

    return results.map((result) => Favorite.fromJson(result)).first;
  }

  Future<int> removeItem(int id) async {
    final db = await _initializeDb();

    final result = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  Future<int> removeItemByRestaurantId(String restaurantId) async {
    final db = await _initializeDb();

    final result = await db.delete(
      _tableName,
      where: "restaurantId = ?",
      whereArgs: [restaurantId],
    );
    return result;
  }
}
