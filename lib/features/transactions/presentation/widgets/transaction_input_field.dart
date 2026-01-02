import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const TransactionInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.inputType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.green),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: inputType,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
