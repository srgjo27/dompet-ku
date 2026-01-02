import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dompet_ku/features/transactions/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<double> getTotalBalance();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await firestore
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toDocument());
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await firestore
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toDocument());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await firestore.collection('transactions').doc(id).delete();
  }

  @override
  Future<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = DateTime.now();
    final effectiveEndDate = endDate != null
        ? DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59)
        : now;
    final effectiveStartDate = startDate ?? DateTime(now.year, now.month, 1);
    final snapshot = await firestore
        .collection('transactions')
        .where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(effectiveStartDate),
        )
        .where(
          'date',
          isLessThanOrEqualTo: Timestamp.fromDate(effectiveEndDate),
        )
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => TransactionModel.fromSnapshot(doc))
        .toList();
  }

  @override
  Future<double> getTotalBalance() async {
    final snapshot = await firestore.collection('transactions').get();
    double balance = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] ?? 0).toDouble();
      final category = data['category'];
      if (category == 'income') {
        balance += amount;
      } else {
        balance -= amount;
      }
    }
    return balance;
  }
}
