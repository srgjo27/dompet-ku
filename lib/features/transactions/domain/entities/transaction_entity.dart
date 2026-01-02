import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String title;
  final double amount;
  final TransactionCategory category;
  final DateTime date;

  const TransactionEntity({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [id, title, amount, category, date];
}
