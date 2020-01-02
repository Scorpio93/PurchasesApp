import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:purchases/domain/entities/failures.dart';
import 'package:purchases/domain/entities/purchase.dart';
import 'package:purchases/storage/services/purchases_dao.dart';

abstract class PurchasesRepository{
  Future<Either<Failure, int>> addPurchase({@required Purchase purchase});
  Future<Either<Failure, List<Purchase>>> getPurchases();
}

class PurchasesRepositoryImpl extends PurchasesRepository{
  final PurchasesDAO dao;

  PurchasesRepositoryImpl({@required this.dao});

  @override
  Future<Either<Failure, List<Purchase>>> getPurchases() async{
    try{
      final purchases = await dao.getPurchases();
      return Right(purchases);
    }on Exception {
      return Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addPurchase({Purchase purchase}) async{
    try{
      final result = await dao.createPurchase(purchase);
      return Right(result);
    }on Exception {
      return Left(DatabaseWriteFailure());
    }
  }
}