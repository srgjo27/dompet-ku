import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/add_transaction.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/get_transactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
  }) : super(TransactionInitial()) {
    on<GetTransactionsEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await getTransactions();
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (data) => emit(TransactionLoaded(data)),
      );
    });

    on<AddTransactionEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await addTransaction(event.transaction);
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (success) => add(GetTransactionsEvent()),
      );
    });

    on<DeleteTransactionEvent>((event, emit) async {
      final result = await deleteTransaction(event.id);
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (success) => add(GetTransactionsEvent()),
      );
    });
  }
}
