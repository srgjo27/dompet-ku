import 'package:dompet_ku/core/utils/currency_input_formatter.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/transaction_date_picker.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/transaction_dropdown_field.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/transaction_input_field.dart';
import 'package:flutter/material.dart';

class AddTransactionForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TransactionCategory selectedCategory;
  final DateTime selectedDate;
  final ValueChanged<TransactionCategory?> onCategoryChanged;
  final VoidCallback onDateTap;

  const AddTransactionForm({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedCategory,
    required this.selectedDate,
    required this.onCategoryChanged,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Transaksi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            TransactionInputField(
              label: 'Nama Transaksi',
              controller: titleController,
              hintText: 'Contoh: Beli Makan Siang',
              icon: Icons.description,
            ),
            const SizedBox(height: 20),
            TransactionInputField(
              label: 'Jumlah',
              controller: amountController,
              hintText: '0',
              icon: Icons.attach_money,
              inputType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
            ),
            const SizedBox(height: 20),
            TransactionDropdownField(
              label: 'Kategori',
              value: selectedCategory,
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 20),
            TransactionDatePicker(
              label: 'Pilih Tanggal',
              selectedDate: selectedDate,
              onTap: onDateTap,
            ),
          ],
        ),
      ),
    );
  }
}
