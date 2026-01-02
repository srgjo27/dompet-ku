import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/presentation/pages/add_transaction_page.dart';
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddTransactionPage(transactionToEdit: transaction),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: transaction.category.label == 'Pemasukan'
                ? Colors.green.shade100
                : Colors.red.shade100,
            child: Text(
              'Rp',
              style: TextStyle(
                color: transaction.category.label == 'Pemasukan'
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          title: Text(
            transaction.title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(DateFormat.yMMMd('id_ID').format(transaction.date)),
          trailing: Text(
            transaction.category.label == 'Pemasukan'
                ? "+${currencyFormatter.format(transaction.amount)}"
                : "-${currencyFormatter.format(transaction.amount)}",
            style: TextStyle(
              color: transaction.category.label == 'Pemasukan'
                  ? Colors.green
                  : Colors.red,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
