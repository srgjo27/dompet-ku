import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionTypePieChart extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const TransactionTypePieChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Tidak ada data transaksi'));
    }

    final totalIncome = _calculateTotal(TransactionCategory.income);
    final totalExpense = _calculateTotal(TransactionCategory.expense);
    final totalOther = _calculateTotal(TransactionCategory.other);
    final total = totalIncome + totalExpense + totalOther;

    if (total == 0) {
      return const Center(child: Text('Total transaksi 0'));
    }

    final chartData = [
      _ChartData(
        'Pemasukan',
        totalIncome,
        Colors.green,
        '${(totalIncome / total * 100).toStringAsFixed(1)}%',
      ),
      _ChartData(
        'Pengeluaran',
        totalExpense,
        Colors.red,
        '${(totalExpense / total * 100).toStringAsFixed(1)}%',
      ),
      if (totalOther > 0)
        _ChartData(
          'Lainnya',
          totalOther,
          Colors.grey,
          '${(totalOther / total * 100).toStringAsFixed(1)}%',
        ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              PieSeries<_ChartData, String>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                pointColorMapper: (_ChartData data, _) => data.color,
                dataLabelMapper: (_ChartData data, _) => data.text,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                radius: '80%',
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateTotal(TransactionCategory category) {
    return transactions
        .where((tx) => tx.category == category)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }
}

class _ChartData {
  final String x;
  final double y;
  final Color color;
  final String text;

  _ChartData(this.x, this.y, this.color, this.text);
}
