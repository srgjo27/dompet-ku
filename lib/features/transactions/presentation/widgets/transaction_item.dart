import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  final Function(String) onDelete;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
    );

    return Dismissible(
      key: Key(transaction.id!),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete(transaction.id!);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.attach_money, color: Colors.green),
          ),
          title: Text(
            transaction.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
          trailing: Text(
            currencyFormatter.format(transaction.amount),
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
