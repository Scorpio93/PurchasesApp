import 'package:get_it/get_it.dart';
import 'package:purchases/data/repositories/purchases_repository.dart';
import 'package:purchases/domain/usecases/purchases_usecase.dart';
import 'package:purchases/presentation/purchases_bloc.dart.dart';
import 'package:purchases/storage/database_provider.dart';
import 'package:purchases/storage/services/purchases_dao.dart';

final serviceLocator = GetIt.instance;

void init(){
  // blocs
  serviceLocator.registerFactory<PurchasesBlocImpl>(() => PurchasesBlocImpl(usecase: serviceLocator()));

  //usecases
  serviceLocator.registerFactory<GetPurchasesUsecase>(() => GetPurchasesUsecaseImplementation(serviceLocator()));

  //repositories
  serviceLocator.registerFactory<PurchasesRepository>(() => PurchasesRepositoryImpl(dao: serviceLocator()));

  //queries
  serviceLocator.registerFactory<PurchasesDAO>(() => PurchasesDAOImpl(databaseProvider: serviceLocator()));

  //database instance
  serviceLocator.registerSingleton<DatabaseProvider>(DatabaseProvider());
}