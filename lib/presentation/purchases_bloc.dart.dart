import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases/domain/entities/purchase.dart';
import 'package:purchases/domain/usecases/purchases_usecase.dart';
import 'package:purchases/presentation/purchases_state.dart';

abstract class PurchasesBloc<Purchase, PurchasesState> {
  void loadPurchases();

  void addNewItem(Purchase purchase);

  void dispose();
}

class PurchasesBlocImpl extends PurchasesBloc {
  PurchasesBlocImpl({@required GetPurchasesUsecase this.usecase});

  final GetPurchasesUsecase usecase;

  final _purchasesStreamController = StreamController<PurchasesState>();

  Stream<PurchasesState> get purchases => _purchasesStreamController.stream;

  @override
  void loadPurchases() {
    _purchasesStreamController.sink.add(PurchasesState.purchasesLoading());
    usecase.call().then((purchasesState) {
      purchasesState.fold(
          (failure) => _purchasesStreamController.sink
              .add(PurchasesState.purchasesError()),
          (success) => _purchasesStreamController.sink
              .add(PurchasesState.purchasesData(success)));
    });
  }

  @override
  void dispose() {
    _purchasesStreamController.close();
  }

  @override
  void addNewItem(purchase) {
    usecase.addNewPurchase(purchase).then((isAdded) {
      loadPurchases();
    });
  }
}
