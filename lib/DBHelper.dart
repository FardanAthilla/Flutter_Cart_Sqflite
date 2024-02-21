import 'dart:io';
import 'package:flutter_bookmark_sqflite/Model/CartModel.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper extends GetxController {
  final String _databaseName = 'my_database.db';
  final int _databaseVersion = 1;

  final String table = 'cart';
  final String id = 'id';
  final String image = 'image';
  final String price = 'price';
  final String title = 'title';

  List<CartModel> CartData = [];

  @override
  void onInit() {
    super.onInit();
    database();
  }

  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($id INTEGER PRIMARY KEY, $image BLOB NULL, $price DOUBLE NULL, $title TEXT NULL)');
  }

  Future<void> all() async {
    final data = await _database?.query(table);
    CartData = data!.map((e) => CartModel.fromJson(e)).toList();
  }

  Future<void> insert(Map<String, dynamic> row) async {
    await _database!.insert(table, row);
    all();
  }

  Future<bool> isProductExist(int productId) async {
    final db = await database();
    var result = await db.query(
      table,
      where: '$id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }

  Future delete(int? idParam) async {
    await _database!.delete(table, where: '$id = ?', whereArgs: [idParam]);
    all();
  }
}
