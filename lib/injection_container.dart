import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dompet_ku/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:dompet_ku/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/add_transaction.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/get_transactions.dart';
import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! --- Features - Transactions ---
  // Bloc
  sl.registerFactory(
    () => TransactionBloc(
      getTransactions: sl(),
      addTransaction: sl(),
      deleteTransaction: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(firestore: sl()),
  );

  //! --- External ---
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);
}
