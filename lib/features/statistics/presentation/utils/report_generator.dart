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
    final timeFormat = DateFormat('dd MMM yyyy HH:mm', 'id_ID');

    String dateRangeText = 'Semua Waktu';
    if (startDate != null && endDate != null) {
      dateRangeText =
          '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
    }

    // Calculate Summary
    final totalIncome = transactions
        .where((tx) => tx.category == TransactionCategory.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    final totalExpense = transactions
        .where((tx) => tx.category == TransactionCategory.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    final netBalance = totalIncome - totalExpense;

    // Sort transactions by date (descending)
    final sortedTransactions = List<TransactionEntity>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Load Fonts via Printing package
    final font = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(dateRangeText),
        footer: (context) => _buildFooter(context, timeFormat),
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 20),
            _buildSummarySection(
              totalIncome,
              totalExpense,
              netBalance,
              currencyFormatter,
            ),
            pw.SizedBox(height: 30),
            _buildTransactionTable(
              sortedTransactions,
              dateFormat,
              currencyFormatter,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildHeader(String dateRangeText) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'DompetKu',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Laporan Keuangan',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.Text(
                  dateRangeText,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.grey300, thickness: 1),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context, DateFormat timeFormat) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Dicetak otomatis oleh DompetKu • ${timeFormat.format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
          ),
          pw.Text(
            'Halaman ${context.pageNumber} dari ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummarySection(
    double totalIncome,
    double totalExpense,
    double netBalance,
    NumberFormat formatter,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard('Pemasukan', totalIncome, PdfColors.green, formatter),
        pw.SizedBox(width: 10),
        _buildSummaryCard(
          'Pengeluaran',
          totalExpense,
          PdfColors.red,
          formatter,
        ),
        pw.SizedBox(width: 10),
        _buildSummaryCard(
          'Sisa Dana',
          netBalance,
          netBalance >= 0 ? PdfColors.green : PdfColors.red,
          formatter,
          isBold: true,
        ),
      ],
    );
  }

  static pw.Widget _buildSummaryCard(
    String title,
    double amount,
    PdfColor color,
    NumberFormat formatter, {
    bool isBold = false,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              title,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              formatter.format(amount),
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTransactionTable(
    List<TransactionEntity> transactions,
    DateFormat dateFormat,
    NumberFormat currencyFormatter,
  ) {
    return pw.Table.fromTextArray(
      headers: ['Tanggal', 'Kategori', 'Keterangan', 'Jumlah'],
      data: transactions.map((tx) {
        final isIncome = tx.category == TransactionCategory.income;
        final color = isIncome ? PdfColors.green : PdfColors.red;
        final prefix = isIncome ? '+' : '-';
        return [
          dateFormat.format(tx.date),
          tx.category.label,
          tx.title,
          pw.Text(
            '$prefix${currencyFormatter.format(tx.amount).replaceAll("Rp", "").trim()}',
            style: pw.TextStyle(color: color, fontWeight: pw.FontWeight.bold),
          ),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 11,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.green800),
      rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.all(8),
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
    );
  }
}
