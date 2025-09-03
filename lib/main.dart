import 'package:flutter/material.dart';
import 'screens/student_list.dart';
import 'screens/add_student.dart';
import 'screens/fee_plans.dart';
import 'screens/payments.dart';
import 'screens/invoices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TuitionApp());
}

class TuitionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuition Offline App (Full)',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StudentListScreen(),
        '/add': (context) => AddStudentScreen(),
        '/feeplans': (context) => FeePlanListScreen(),
        '/payments': (context) => PaymentEntryScreen(),
        '/invoices': (context) => InvoiceListScreen(),
      },
    );
  }
}
