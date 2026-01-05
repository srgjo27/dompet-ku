import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyTrendLineChart extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const DailyTrendLineChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SizedBox();
    }

    final chartData = _processData(transactions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tren Harian',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: SfCartesianChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd('id_ID'),
              intervalType: DateTimeIntervalType.days,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.compactSimpleCurrency(locale: 'id_ID'),
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
            series: <CartesianSeries<_ChartData, DateTime>>[
              LineSeries<_ChartData, DateTime>(
                name: 'Pemasukan',
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.date,
                yValueMapper: (_ChartData data, _) => data.income,
                color: Colors.green,
                width: 3,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
              LineSeries<_ChartData, DateTime>(
                name: 'Pengeluaran',
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.date,
                yValueMapper: (_ChartData data, _) => data.expense,
                color: Colors.red,
                width: 3,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<_ChartData> _processData(List<TransactionEntity> transactions) {
    if (transactions.isEmpty) return [];

    // Group by Date (Day only)
    final Map<DateTime, _ChartData> groupedData = {};

    for (var tx in transactions) {
      final date = DateTime(tx.date.year, tx.date.month, tx.date.day);
      if (!groupedData.containsKey(date)) {
        groupedData[date] = _ChartData(date, 0, 0);
      }

      if (tx.category == TransactionCategory.income) {
        groupedData[date]!.income += tx.amount;
      } else if (tx.category == TransactionCategory.expense ||
          tx.category == TransactionCategory.other) {
        groupedData[date]!.expense += tx.amount;
      }
    }

    final sortedData = groupedData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return sortedData;
  }
}

class _ChartData {
  final DateTime date;
  double income;
  double expense;

  _ChartData(this.date, this.income, this.expense);
}
