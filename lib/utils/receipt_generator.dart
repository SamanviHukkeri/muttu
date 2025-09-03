import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/invoice.dart';
import '../models/student.dart';
import '../models/fee_plan.dart';

class ReceiptGenerator {
  static Future<String> generateInvoicePdf(Invoice inv, Student s, FeePlan p) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context ctx) {
      return pw.Container(pw.EdgeInsets.all(16), child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Receipt', style: pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 8),
        pw.Text('Invoice ID: \${inv.id}'),
        pw.Text('Date: \${inv.date}'),
        pw.SizedBox(height: 8),
        pw.Text('Student: \${s.name}'),
        pw.Text('Class: \${s.studentClass}'),
        pw.SizedBox(height: 8),
        pw.Text('Fee: \${p.name}'),
        pw.Text('Amount: \${inv.amount.toString()}'),
        pw.Text('Paid: \${inv.paid.toString()}'),
      ]));
    }));

    final output = await getApplicationDocumentsDirectory();
    final file = File('\${output.path}/receipt_\${inv.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
