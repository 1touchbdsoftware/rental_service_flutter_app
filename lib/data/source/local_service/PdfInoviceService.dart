import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../model/budget/BudgetItem.dart';

class PdfInvoiceService {
  static Future<File> generateInvoice({
    required String agencyName,
    required String? agencyLogoPath,
    required String agencyAddress,
    required String agencyEmail,
    required String agencyContact,
    required String ticketNo,
    required String tenantName,
    required String propertyName,
    required List<BudgetItem> budgetItems,
    required double totalAmount,
    required bool isPaid,
  }) async {
    final pdf = pw.Document();

    final currencyFormat = NumberFormat.currency(symbol: '৳', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final currentDate = dateFormat.format(DateTime.now());

    // ✅ Preload image bytes before building PDF
    Uint8List? logoBytes;
    if (agencyLogoPath != null && agencyLogoPath.isNotEmpty) {
      logoBytes = await _loadImage(agencyLogoPath);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left Column: Agency Info
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logoBytes != null && logoBytes.isNotEmpty)
                        pw.Image(pw.MemoryImage(logoBytes), height: 50)
                      else
                        pw.Text(
                          agencyName,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        agencyAddress,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        agencyEmail,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        agencyContact,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),

                  // Right Column: Invoice Info
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Text(
                            'Invoice #: ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            ticketNo,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 15),

              // Bill To Section
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BILL TO',
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Name: $tenantName'),
                    pw.SizedBox(height: 3),
                    pw.Text('Property: $propertyName'),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Budget Table
              pw.Text(
                'Budget Details',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Table Header
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                child: pw.Row(
                  children: [
                    _buildTableHeaderCell('#', 0.5, pw.TextAlign.center),
                    _buildTableHeaderCell('DESCRIPTION', 3, pw.TextAlign.left),
                    _buildTableHeaderCell('QTY', 1, pw.TextAlign.right),
                    _buildTableHeaderCell(
                      'UNIT PRICE',
                      1.5,
                      pw.TextAlign.right,
                    ),
                    _buildTableHeaderCell('TOTAL', 1.5, pw.TextAlign.right),
                  ],
                ),
              ),

              // Table Rows
              ...budgetItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey400),
                      left: pw.BorderSide(color: PdfColors.grey400),
                      right: pw.BorderSide(color: PdfColors.grey400),
                    ),
                  ),
                  child: pw.Row(
                    children: [
                      _buildTableCell(
                        (index + 1).toString(),
                        0.5,
                        pw.TextAlign.center,
                      ),
                      _buildTableCell(item.description, 3, pw.TextAlign.left),
                      _buildTableCell(
                        item.quantity.toString(),
                        1,
                        pw.TextAlign.right,
                      ),
                      _buildTableCell(
                        currencyFormat.format(item.costPerUnit),
                        1.5,
                        pw.TextAlign.right,
                      ),
                      _buildTableCell(
                        currencyFormat.format(item.total),
                        1.5,
                        pw.TextAlign.right,
                      ),
                    ],
                  ),
                );
              }).toList(),

              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 15),

              // Total and Status Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Payment Status
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          color: isPaid ? PdfColors.green : PdfColors.orange,
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Text(
                          isPaid ? 'PAID' : 'PENDING',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Thank you for your business!',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),

                  // Total Amount
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Total Amount:',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'BDT ${currencyFormat.format(totalAmount)}',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 25),

              // Footer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.only(top: 10),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Downloaded on $currentDate',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      'by ProMatrix System',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_$ticketNo.pdf');
    await file.writeAsBytes(await pdf.save());

    // After generating the file
    final pdfBytes = await pdf.save();

    // Open print preview
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);

    return file;
  }

  static pw.Widget _buildTableHeaderCell(
    String text,
    double flex,
    pw.TextAlign align,
  ) {
    return pw.Expanded(
      flex: (flex * 2).round(),
      child: pw.Container(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          text,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          textAlign: align,
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(
    String text,
    double flex,
    pw.TextAlign align,
  ) {
    return pw.Expanded(
      flex: (flex * 2).round(),
      child: pw.Container(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          text,
          style: const pw.TextStyle(fontSize: 9),
          textAlign: align,
        ),
      ),
    );
  }

  static Future<Uint8List> _loadImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return Uint8List(0);
  }
}
