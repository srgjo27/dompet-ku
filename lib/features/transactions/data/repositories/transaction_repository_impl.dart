import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:dompet_ku/features/transactions/data/models/transaction_model.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await remoteDataSource.addTransaction(transactionModel);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await remoteDataSource.updateTransaction(
        TransactionModel.fromEntity(transaction),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllTransactions() async {
    try {
      await remoteDataSource.deleteAllTransactions();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions(
        startDate: startDate,
        endDate: endDate,
      );

      return Right(remoteTransactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance() async {
    try {
      final balance = await remoteDataSource.getTotalBalance();
      return Right(balance);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
