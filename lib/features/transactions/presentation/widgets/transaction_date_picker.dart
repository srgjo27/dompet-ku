import 'package:flutter/material.dart';

class TransactionDatePicker extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final VoidCallback onTap;

  const TransactionDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onTap,
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green),
                const SizedBox(width: 12),
                Text(
                  'Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
