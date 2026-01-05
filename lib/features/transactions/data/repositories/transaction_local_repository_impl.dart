import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:dompet_ku/features/transactions/data/models/transaction_model.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionLocalRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionLocalRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await localDataSource.addTransaction(model);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance() async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      // Calculate locally since we are fetching all anyway, or could add a specific query in Datasource.
      // For simplicity and matching current logic, we can fetch all or do it in memory.
      // Ideally, the Bloc handles calculation from the list, but the Repo interface asks for it.
      // However, the interface might just return the list and let UseCase handle it?
      // Checking interface... Repo has getTotalBalance.
      // Let's implement simple calculation here or call a specific DS method if we want optimization.
      // Memory calculation for now is fine for "personal" finance data size.

      // Actually, checking standard implementation, usually Repo calls DS.
      // Let's just fetch all and calculate.

      // Wait, TransactionCategory is in Entity.
      // We need to calculate Income - Expense.
      // Re-using the logic commonly found in Bloc or previous Repo.

      // Since we fetch all transactions for the list anyway, this method might be redundant
      // if the Bloc calculates it from the list. But let's fulfill the contract.

      // Note: The previous remote impl might have done this.
      // Let's just return 0 for now and let the Bloc calculate from the list if the Bloc allows it,
      // OR implement the loop.

      double total = 0;
      for (var tx in transactions) {
        if (tx.category.name == 'income') {
          total += tx.amount;
        } else {
          total -= tx.amount;
        }
      }
      // Initial Repo likely just summed it up.
      // Wait, standard `getTotalBalance` might be "current balance".

      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      // Filter logic in Repository (or Datasource query)
      var filtered = transactions;
      if (startDate != null && endDate != null) {
        filtered = transactions.where((tx) {
          return tx.date.isAfter(
                startDate.subtract(const Duration(seconds: 1)),
              ) &&
              tx.date.isBefore(endDate.add(const Duration(seconds: 1)));
        }).toList();
      }
      return Right(filtered);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await localDataSource.updateTransaction(model);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllTransactions() async {
    try {
      await localDataSource.deleteAllTransactions();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
