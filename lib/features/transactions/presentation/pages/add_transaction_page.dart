import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dompet_ku/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/add_transaction_button.dart';
import 'package:dompet_ku/features/transactions/presentation/widgets/add_transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  final TransactionEntity? transactionToEdit;

  const AddTransactionPage({super.key, this.transactionToEdit});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TransactionCategory _selectedCategory = TransactionCategory.other;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _titleController.text = tx.title;
      _amountController.text = NumberFormat.currency(
        locale: 'id_ID',
        symbol: '',
        decimalDigits: 0,
      ).format(tx.amount);
      _selectedDate = tx.date;
      _selectedCategory = tx.category;
    }
  }

  void _submitData() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final sanitizedAmount = _amountController.text.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    final enteredAmount = double.parse(sanitizedAmount);

    if (widget.transactionToEdit != null) {
      final updatedTx = TransactionEntity(
        id: widget.transactionToEdit!.id,
        title: enteredTitle,
        amount: enteredAmount,
        date: _selectedDate,
        category: _selectedCategory,
      );
      context.read<TransactionBloc>().add(UpdateTransactionEvent(updatedTx));
    } else {
      final newTx = TransactionEntity(
        id: DateTime.now().toString(),
        title: enteredTitle,
        amount: enteredAmount,
        date: _selectedDate,
        category: _selectedCategory,
      );
      context.read<TransactionBloc>().add(AddTransactionEvent(newTx));
    }

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.transactionToEdit != null
              ? 'Edit Transaksi'
              : 'Tambah Transaksi',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: AddTransactionForm(
                titleController: _titleController,
                amountController: _amountController,
                selectedCategory: _selectedCategory,
                selectedDate: _selectedDate,
                onCategoryChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                onDateTap: _presentDatePicker,
              ),
            ),
          ),
          AddTransactionButton(onPressed: _submitData),
        ],
      ),
    );
  }
}
