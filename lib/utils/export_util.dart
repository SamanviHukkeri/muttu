import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import '../models/invoice.dart';

class ExportUtil {
  static Future<String> exportAllDataCsv() async {
    final students = await DatabaseHelper.instance.readAllStudents();
    final invoices = await DatabaseHelper.instance.readAllInvoices();
    List<List<dynamic>> rows = [];
    rows.add(['Students']);
    rows.add(['id','name','dob','guardian','phone','class']);
    for(var s in students) {
      rows.add([s.id,s.name,s.dob,s.guardian,s.phone,s.studentClass]);
    }
    rows.add([]);
    rows.add(['Invoices']);
    rows.add(['id','studentId','feePlanId','date','amount','paid','status']);
    for(var inv in invoices) {
      rows.add([inv.id,inv.studentId,inv.feePlanId,inv.date,inv.amount,inv.paid,inv.status]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('\${dir.path}/tuition_export_\${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    return file.path;
  }
}
