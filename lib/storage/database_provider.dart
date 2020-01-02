import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:purchases/storage/purchases_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const int _databaseVersion = 1;
const String _databaseName = "Purchases.db";

class DatabaseProvider {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  initDatabase() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(databaseDirectory.path, _databaseName);
    return await openDatabase(databasePath, version: _databaseVersion, onCreate: (Database database, int  version) async{
      await database.execute("CREATE TABLE " + PurchasesTable.tableName + " ("
          "id INTEGER PRIMARY KEY, "
          + PurchasesTable.name + " TEXT, "
          + PurchasesTable.price + " INTEGER, "
          + PurchasesTable.description + " TEXT, "
          + PurchasesTable.bought + " INTEGER)");
    });
  }
}
