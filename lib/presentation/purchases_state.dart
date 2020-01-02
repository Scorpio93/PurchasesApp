import 'package:purchases/domain/entities/purchase.dart';

class PurchasesState {
  PurchasesState();
  factory PurchasesState.purchasesData(List<Purchase> purchases) = PurchasesDataState;
  factory PurchasesState.purchasesLoading() = PurchasesLoadingState;
  factory PurchasesState.purchasesError() = PurchasesErrorState;
}

class PurchasesInitState extends PurchasesState {}

class PurchasesLoadingState extends PurchasesState {}

class PurchasesErrorState extends PurchasesState {}

class PurchasesDataState extends PurchasesState {
  PurchasesDataState(this.purchases);
  final List<Purchase> purchases;
}