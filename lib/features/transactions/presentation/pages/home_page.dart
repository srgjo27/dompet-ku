import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:dompet_ku/features/transactions/presentation/pages/add_transaction_page.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DompetKu'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return Center(child: Text('Belum ada transaksi, Ayo tambah!'));
            }

            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                return TransactionItem(
                  transaction: state.transactions[index],
                  onDelete: (id) {
                    context.read<TransactionBloc>().add(
                      DeleteTransactionEvent(id),
                    );
                  },
                );
              },
            );
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          }

          return Center(child: Text('Siap memulai!'));
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AddTransactionPage()));
        },
      ),
    );
  }
}
