import 'package:dartz/dartz.dart';
import 'package:dompet_ku/core/error/failures.dart';
import 'package:dompet_ku/features/transactions/domain/repositories/transaction_repository.dart';

class GetTotalBalance {
  final TransactionRepository repository;

  GetTotalBalance(this.repository);

  Future<Either<Failure, double>> call() async {
    return await repository.getTotalBalance();
  }
}
