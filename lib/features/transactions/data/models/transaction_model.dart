import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    String? id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) : super(
         id: id,
         title: title,
         amount: amount,
         category: category,
         date: date,
       );

  factory TransactionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return TransactionModel(
      id: document.id,
      title: data['title'] ?? 'Tanpa Judul',
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'] ?? 'Lainnya',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
    );
  }
}
