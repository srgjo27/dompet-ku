import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:dompet_ku/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/date_filter_bottom_sheet.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/home_header.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/home_transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            double monthlyIncome = 0;
            double monthlyExpense = 0;

            for (var tx in state.transactions) {
              if (tx.category == TransactionCategory.income) {
                monthlyIncome += tx.amount;
              } else {
                monthlyExpense += tx.amount;
              }
            }

            final totalBalance = state.totalBalance;

            return Stack(
              children: [
                HomeHeader(
                  totalBalance: totalBalance,
                  totalIncome: monthlyIncome,
                  totalExpense: monthlyExpense,
                  onAddTransaction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => AddTransactionPage()),
                    );
                  },
                ),
                HomeTransactionList(
                  transactions: state.transactions,
                  onDelete: (id) {
                    context.read<TransactionBloc>().add(
                      DeleteTransactionEvent(id),
                    );
                  },
                  onFilterTap: () {
                    DateTimeRange? currentRange;
                    if (state.startDate != null && state.endDate != null) {
                      currentRange = DateTimeRange(
                        start: state.startDate!,
                        end: state.endDate!,
                      );
                    }
                    _handleFilterTap(context, currentRange);
                  },
                ),
              ],
            );
          }

          return const Center(child: Text('Siap memulai!'));
        },
      ),
    );
  }

  void _handleFilterTap(BuildContext context, DateTimeRange? initialRange) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DateFilterBottomSheet(
        initialRange: initialRange,
        onApply: (range) {
          final difference = range.duration.inDays + 1;

          if (difference < 7) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Minimal rentang waktu adalah 7 hari'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (difference > 90) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Maksimal rentang waktu adalah 90 hari'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            context.read<TransactionBloc>().add(
              GetTransactionsEvent(startDate: range.start, endDate: range.end),
            );
          }
        },
      ),
    );
  }
}
