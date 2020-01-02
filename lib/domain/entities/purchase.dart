import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:purchases/storage/purchases_schema.dart';

Purchase fromJson(String str) => Purchase.fromJson(json.decode(str));

String toJson(Purchase data) => json.encode(data.toJson());

class Purchase extends Equatable {
  final int id;
  final String name;
  final int price;
  final String description;
  final int isBought;

  Purchase(
      {this.id,
      @required this.name,
      @required this.price,
      @required this.description,
      @required this.isBought})
      : super([name, price, description, isBought]);

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
      id: json[PurchasesTable.id],
      name: json[PurchasesTable.name],
      price: json[PurchasesTable.price],
      description: json[PurchasesTable.description],
      isBought: json[PurchasesTable.bought]);

  Map<String, dynamic> toJson() => {
        PurchasesTable.id: id,
        PurchasesTable.name: name,
        PurchasesTable.price: price,
        PurchasesTable.description: description,
        PurchasesTable.bought: isBought,
      };
}
