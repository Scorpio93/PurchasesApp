import 'package:dartz/dartz.dart';
import 'package:purchases/data/repositories/purchases_repository.dart';
import 'package:purchases/domain/entities/failures.dart';
import 'package:purchases/domain/entities/purchase.dart';

abstract class GetPurchasesUsecase<Type>{
  Future<Either<Failure, List<Type>>> call();
  Future<Either<Failure, int>> addNewPurchase(Purchase purchase);
}

class GetPurchasesUsecaseImplementation implements GetPurchasesUsecase<Purchase> {
  final PurchasesRepository _repository;

  GetPurchasesUsecaseImplementation(this._repository);

  @override
  Future<Either<Failure, List<Purchase>>> call() async {
    return await _repository.getPurchases();
  }

  @override
  Future<Either<Failure, int>> addNewPurchase(Purchase purchase) {
    return _repository.addPurchase(purchase: purchase);
  }
}