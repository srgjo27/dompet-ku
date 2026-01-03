import 'package:dompet_ku/features/transactions/domain/entities/transaction_category.dart';
import 'package:dompet_ku/features/transactions/domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportGenerator {
  static Future<void> generateReport({
    required List<TransactionEntity> transactions,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pdf = pw.Document();

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    String dateRangeText = 'Bulan Ini';
    if (startDate != null && endDate != null) {
      dateRangeText =
          '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
    }

    final totalIncome = transactions
        .where((tx) => tx.category == TransactionCategory.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    final totalExpense = transactions
        .where((tx) => tx.category == TransactionCategory.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    final netBalance = totalIncome - totalExpense;

    final sortedTransactions = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    final font = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Laporan Keuangan',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Periode: $dateRangeText',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'Pemasukan',
                    totalIncome,
                    PdfColors.green,
                    currencyFormatter,
                  ),
                  _buildSummaryItem(
                    'Pengeluaran',
                    totalExpense,
                    PdfColors.red,
                    currencyFormatter,
                  ),
                  _buildSummaryItem(
                    'Sisa Dana',
                    netBalance,
                    netBalance >= 0 ? PdfColors.green : PdfColors.red,
                    currencyFormatter,
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.green),
              cellAlignment: pw.Alignment.centerLeft,
              headerAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
              },
              data: [
                ['Tanggal', 'Keterangan', 'Kategori', 'Jumlah'],
                ...sortedTransactions.map((tx) {
                  final isIncome = tx.category == TransactionCategory.income;
                  final color = isIncome ? PdfColors.green : PdfColors.red;
                  final prefix = isIncome ? '+' : '-';
                  return [
                    dateFormat.format(tx.date),
                    tx.title,
                    tx.category.label,
                    pw.Text(
                      '$prefix${currencyFormatter.format(tx.amount).replaceAll("Rp", "").trim()}',
                      style: pw.TextStyle(color: color),
                    ),
                  ];
                }),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    double amount,
    PdfColor color,
    NumberFormat formatter,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
        ),
        pw.Text(
          formatter.format(amount),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
