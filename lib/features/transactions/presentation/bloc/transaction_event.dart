part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionsEvent extends TransactionEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetTransactionsEvent({this.startDate, this.endDate});

  @override
  List<Object> get props => [startDate ?? '', endDate ?? ''];
}

class AddTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String id;

  const DeleteTransactionEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  const UpdateTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteAllTransactionsEvent extends TransactionEvent {}
