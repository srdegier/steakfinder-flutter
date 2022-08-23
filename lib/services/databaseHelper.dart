import 'dart:developer';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/FavoriteSteakhouse.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'favorites.db');
    //databaseFactory.deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //id INTEGER PRIMARY KEY,
  Future _onCreate(Database db, int version) async {
    inspect('Create DB');
    await db.execute('''
      CREATE TABLE favorites(
          placeId TEXT,
          name TEXT,
          lat DOUBLE,
          lng DOUBLE
      )
      ''');
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);

  Future<List<FavoriteSteakhouse>> getFavorites() async {
    //remove('3298743802423');
    Database db = await instance.database;
    var favorites = await db.query('favorites', orderBy: 'name');
    List<FavoriteSteakhouse> favoriteList = favorites.isNotEmpty
        ? favorites.map((c) => FavoriteSteakhouse.fromMap(c)).toList()
        : [];
    return favoriteList;
  }

  Future<int> add(FavoriteSteakhouse favorite) async {
    Database db = await instance.database;
    return await db.insert('favorites', favorite.toMap());
  }

  Future<int> remove(String? id) async {
    inspect('deleting');
    Database db = await instance.database;
    return await db.delete('favorites', where: 'placeId = ?', whereArgs: [id]);
  }

  Future<int> update(FavoriteSteakhouse favorite) async {
    Database db = await instance.database;
    return await db.update('favorites', favorite.toMap(),
        where: "placeId = ?", whereArgs: [favorite.placeId]);
  }

  Future<List<Map<String, Object?>>> findById(String id) async {
    Database db = await instance.database;
    return await db.query('favorites', where: 'placeId = ?', whereArgs: [id]);
  }
}
