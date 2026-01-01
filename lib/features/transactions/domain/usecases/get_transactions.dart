import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await repository.getTransactions();
  }
}
