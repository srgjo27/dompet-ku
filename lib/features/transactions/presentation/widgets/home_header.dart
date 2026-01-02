import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final VoidCallback onAddTransaction;

  const HomeHeader({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.onAddTransaction,
  });

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'DompetKu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Total Saldo',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 5),
          Text(
            _formatCurrency(totalBalance),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            spacing: 10,
            children: [
              _buildSummaryItem(
                'Pemasukan',
                totalIncome,
                Icons.arrow_downward,
                Colors.green.shade100,
              ),
              _buildSummaryItem(
                'Pengeluaran',
                totalExpense,
                Icons.arrow_upward,
                Colors.red.shade100,
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onAddTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              icon: Icon(Icons.add),
              label: Text(
                'Tambah Transaksi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    double amount,
    IconData icon,
    Color iconBgColor,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconBgColor == Colors.green.shade100
                    ? Colors.green
                    : Colors.red,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    _formatCurrency(amount),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
