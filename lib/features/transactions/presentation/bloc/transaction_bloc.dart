import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/add_transaction.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/delete_all_transactions.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/get_total_balance.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/get_transactions.dart';
import 'package:dompet_ku/features/transactions/domain/usecases/update_transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final GetTotalBalance getTotalBalance;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteAllTransactions deleteAllTransactions;

  DateTime? _currentStartDate;
  DateTime? _currentEndDate;

  TransactionBloc({
    required this.getTransactions,
    required this.getTotalBalance,
    required this.addTransaction,
    required this.deleteTransaction,
    required this.updateTransaction,
    required this.deleteAllTransactions,
  }) : super(TransactionInitial()) {
    on<GetTransactionsEvent>((event, emit) async {
      emit(TransactionLoading());

      if (event.startDate != null && event.endDate != null) {
        _currentStartDate = event.startDate;
        _currentEndDate = event.endDate;
      }

      final transactionsResult = await getTransactions(
        startDate: _currentStartDate ?? event.startDate,
        endDate: _currentEndDate ?? event.endDate,
      );
      final balanceResult = await getTotalBalance();

      transactionsResult.fold(
        (failure) => emit(TransactionError(failure.message)),
        (transactions) => balanceResult.fold(
          (failure) => emit(TransactionError(failure.message)),
          (balance) => emit(
            TransactionLoaded(
              transactions,
              balance,
              startDate: _currentStartDate,
              endDate: _currentEndDate,
            ),
          ),
        ),
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

    on<DeleteAllTransactionsEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await deleteAllTransactions();
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (success) => add(GetTransactionsEvent()),
      );
    });

    on<UpdateTransactionEvent>((event, emit) async {
      emit(TransactionLoading());
      final result = await updateTransaction(event.transaction);
      result.fold(
        (failure) => emit(TransactionError(failure.message)),
        (success) => add(GetTransactionsEvent()),
      );
    });
  }
}
