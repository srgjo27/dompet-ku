import 'package:dompet_ku/core/database/database_helper.dart';
import 'package:dompet_ku/features/transactions/data/models/transaction_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteAllTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper databaseHelper;

  TransactionLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await databaseHelper.database;
    final result = await db.query('transactions', orderBy: 'date DESC');

    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final db = await databaseHelper.database;
    final id = transaction.id ?? const Uuid().v4();
    final map = transaction.toMap();
    map['id'] = id;

    await db.insert(
      'transactions',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await databaseHelper.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await databaseHelper.database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<void> deleteAllTransactions() async {
    final db = await databaseHelper.database;
    await db.delete('transactions');
  }
}
