import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTransaction(id);
  }
}
