import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:dompet_ku/features/statistics/presentation/widgets/transaction_type_pie_chart.dart';
import 'package:dompet_ku/features/statistics/presentation/widgets/statistic_header.dart';
import 'package:dompet_ku/features/statistics/presentation/widgets/daily_trend_line_chart.dart';
import 'package:dompet_ku/features/statistics/presentation/widgets/colorful_summary_card.dart';
import 'package:dompet_ku/features/statistics/presentation/utils/report_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          } else if (state is TransactionLoaded) {
            final transactions = state.transactions;
            final startDate = state.startDate;
            final endDate = state.endDate;

            String dateRangeText = 'Bulan Ini';
            if (startDate != null && endDate != null) {
              final startFormat = DateFormat(
                'dd MMM yyyy',
                'id_ID',
              ).format(startDate);
              final endFormat = DateFormat(
                'dd MMM yyyy',
                'id_ID',
              ).format(endDate);
              dateRangeText = '$startFormat - $endFormat';
            }

            final totalIncome = transactions
                .where((tx) => tx.category == TransactionCategory.income)
                .fold(0.0, (sum, tx) => sum + tx.amount);

            final totalExpense = transactions
                .where(
                  (tx) =>
                      tx.category == TransactionCategory.expense ||
                      tx.category == TransactionCategory.other,
                )
                .fold(0.0, (sum, tx) => sum + tx.amount);

            final netBalance = totalIncome - totalExpense;

            return SingleChildScrollView(
              child: Column(
                children: [
                  StatisticHeader(
                    dateRangeText: dateRangeText,
                    netBalance: netBalance,
                    onExportPdf: () {
                      ReportGenerator.generateReport(
                        transactions: transactions,
                        startDate: startDate,
                        endDate: endDate,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: ColorfulSummaryCard(
                                title: 'Pemasukan',
                                amount: totalIncome,
                                backgroundColor: Colors.green.shade50,
                                accentColor: Colors.green,
                                icon: Icons.arrow_upward_rounded,
                              ),
                            ),
                            Expanded(
                              child: ColorfulSummaryCard(
                                title: 'Pengeluaran',
                                amount: totalExpense,
                                backgroundColor: Colors.red.shade50,
                                accentColor: Colors.red,
                                icon: Icons.arrow_downward_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Analisis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TransactionTypePieChart(
                            transactions: transactions,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DailyTrendLineChart(
                            transactions: transactions,
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Memuat data...'));
        },
      ),
    );
  }
}
