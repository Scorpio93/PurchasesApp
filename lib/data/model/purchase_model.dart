import 'package:flutter/cupertino.dart';
import 'package:purchases/domain/entities/purchase.dart';

class PurchaseModel extends Purchase {
  PurchaseModel({
    @required String name,
    @required int price,
    @required String description,
    @required int isBought
  }) : super(name: name, price: price, description: description, isBought: isBought);
}