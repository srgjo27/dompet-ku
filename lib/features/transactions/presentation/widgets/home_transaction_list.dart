import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeTransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final Function(String) onDelete;
  final VoidCallback onFilterTap;

  const HomeTransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<TransactionEntity>> groupedTransactions = {};
    for (var tx in transactions) {
      final key = DateFormat('MMMM yyyy', 'id_ID').format(tx.date);
      if (!groupedTransactions.containsKey(key)) {
        groupedTransactions[key] = [];
      }
      groupedTransactions[key]!.add(tx);
    }

    return Container(
      margin: EdgeInsets.only(top: 340),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Transaksi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  IconButton(
                    onPressed: onFilterTap,
                    icon: Icon(Icons.filter_list, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: transactions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 80),
                      itemCount: groupedTransactions.length,
                      itemBuilder: (context, index) {
                        final monthKey = groupedTransactions.keys.elementAt(
                          index,
                        );
                        final monthTransactions =
                            groupedTransactions[monthKey]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Text(
                                monthKey,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            ...monthTransactions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final tx = entry.value;
                              final isLastItem =
                                  index == monthTransactions.length - 1;
                              return Container(
                                color: index % 2 == 0
                                    ? null
                                    : Colors.grey.withValues(alpha: 0.05),
                                child: Column(
                                  children: [
                                    TransactionItem(
                                      transaction: tx,
                                      onDelete: onDelete,
                                    ),
                                    if (!isLastItem)
                                      const Divider(
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada transaksi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ayo mulai catat keuanganmu!',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
