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
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions() async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions();

      return Right(remoteTransactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
