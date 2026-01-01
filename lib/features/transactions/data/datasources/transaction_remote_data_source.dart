import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dompet_ku/features/transactions/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await firestore.collection('transactions').add(transaction.toDocument());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await firestore.collection('transactions').doc(id).delete();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final snapshot = await firestore
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromSnapshot(doc))
        .toList();
  }
}
