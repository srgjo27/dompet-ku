import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
  Future<Either<Failure, void>> updateTransaction(
    TransactionEntity transaction,
  );
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, double>> getTotalBalance();
}
