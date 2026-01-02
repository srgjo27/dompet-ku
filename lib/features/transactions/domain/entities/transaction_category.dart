enum TransactionCategory {
  income('Pemasukan'),
  expense('Pengeluaran'),
  other('Lainnya');

  final String label;

  const TransactionCategory(this.label);

  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (element) => element.name == value,
      orElse: () => TransactionCategory.other,
    );
  }
}
