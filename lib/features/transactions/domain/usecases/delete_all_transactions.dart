import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteAllTransactions {
  final TransactionRepository repository;

  DeleteAllTransactions(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.deleteAllTransactions();
  }
}
