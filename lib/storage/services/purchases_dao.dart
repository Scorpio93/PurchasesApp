import 'package:flutter/cupertino.dart';
import 'package:purchases/domain/entities/purchase.dart';
import 'package:purchases/storage/database_provider.dart';
import 'package:purchases/storage/purchases_schema.dart';

abstract class PurchasesDAO{
  createPurchase(Purchase purchase);
  getPurchases();
  getPurchase(int id);
}

class PurchasesDAOImpl implements PurchasesDAO {
  DatabaseProvider databaseProvider;

  PurchasesDAOImpl({@required this.databaseProvider});

  @override
  createPurchase(Purchase purchase) async {
    final db = await databaseProvider.database;
    var request = await db.rawInsert("INSERT INTO ${PurchasesTable.tableName}"
        "(${PurchasesTable.name},"
        " ${PurchasesTable.price},"
        " ${PurchasesTable.description},"
        " ${PurchasesTable.bought})"
        " VALUES ('${purchase.name}',"
        " '${purchase.price}',"
        " '${purchase.description}',"
        " '${purchase.isBought}')");
    return request;
  }

  @override
  getPurchases() async{
    final db = await databaseProvider.database;
    var request = await db.query(PurchasesTable.tableName);
    List<Purchase> purchases = request.isNotEmpty ? request.map((c) => Purchase.fromJson(c)).toList() : [];
    return purchases;
  }

  @override
  getPurchase(int id) async{
    final db = await databaseProvider.database;
    var request = await db.query(PurchasesTable.tableName, where: "${PurchasesTable.id} = ?", whereArgs: [id]);
    return request.isNotEmpty ? Purchase.fromJson(request.first) : Null;
  }
}
