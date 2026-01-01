import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<Either<Failure, void>> call(TransactionEntity transaction) async {
    return await repository.addTransaction(transaction);
  }
}
