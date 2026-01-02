import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:flutter/material.dart';

class TransactionDropdownField extends StatelessWidget {
  final String label;
  final TransactionCategory value;
  final ValueChanged<TransactionCategory?> onChanged;

  const TransactionDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TransactionCategory>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.category, color: Colors.green),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: TransactionCategory.values.map((TransactionCategory category) {
            return DropdownMenuItem<TransactionCategory>(
              value: category,
              child: Text(category.label),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
