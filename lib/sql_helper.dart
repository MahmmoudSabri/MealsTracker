import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE meals(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        calories INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE water(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                ml INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mealstracker.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (Meal)
  static Future<int> createMeal(String name, int calories) async {
    final db = await SQLHelper.db();

    final data = {'name': name, 'calories': calories};
    final id = await db.insert('meals', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (Meal)
  static Future<List<Map<String, dynamic>>> getMeals(date,date2) async {
    final db = await SQLHelper.db();
    return db.query('meals',where: "createdAt BETWEEN  ? and ?", whereArgs: [date.toString(),date2.toString()], orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getMeal(int id) async {
    final db = await SQLHelper.db();
    return db.query('meals', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateMeal(
      int id, String name, int calories) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'calories': calories,
     // 'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('meals', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteMeal(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("meals", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }



  // Create new item (Water)
  static Future<int> createWater(int ml) async {
    final db = await SQLHelper.db();

    final data = {'ml': ml};
    final id = await db.insert('water', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (Water)
  static Future<List<Map<String, dynamic>>> getWaters(date,date2) async {
    final db = await SQLHelper.db();
    return db.query('water',where: "createdAt BETWEEN  ? and ?", whereArgs: [date.toString(),date2.toString()], orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getWater(int id) async {
    final db = await SQLHelper.db();
    return db.query('water', where: "id = ?", whereArgs: [id], limit: 1);
  }



  // Delete
  static Future<void> deleteWater(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("water", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}