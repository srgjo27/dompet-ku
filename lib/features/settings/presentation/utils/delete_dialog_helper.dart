import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hapus Semua Data?'),
      content: const Text(
        'Tindakan ini akan menghapus semua riwayat transaksi Anda secara permanen. Anda tidak dapat membatalkannya.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            context.read<TransactionBloc>().add(DeleteAllTransactionsEvent());
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Semua data berhasil dihapus'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
