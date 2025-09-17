import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/student.dart';
import '../models/fee_plan.dart';
import '../models/invoice.dart';
import 'package:intl/intl.dart';
import '../utils/receipt_generator.dart';

class PaymentEntryScreen extends StatefulWidget {
  @override
  _PaymentEntryScreenState createState() => _PaymentEntryScreenState();
}

class _PaymentEntryScreenState extends State<PaymentEntryScreen> {
  List<Student> students = [];
  List<FeePlan> plans = [];
  Student? selectedStudent;
  FeePlan? selectedPlan;
  final _amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    students = await DatabaseHelper.instance.readAllStudents();
    plans = await DatabaseHelper.instance.readAllFeePlans();
    setState((){});
  }

  Future _savePayment() async {
    if(selectedStudent == null || selectedPlan == null || _amount.text.trim().isEmpty) return;
    final now = DateTime.now();
    final df = DateFormat('yyyy-MM-dd');
    final inv = Invoice(studentId: selectedStudent!.id!, feePlanId: selectedPlan!.id!, date: df.format(now), amount: double.tryParse(_amount.text.trim()) ?? 0.0, paid: double.tryParse(_amount.text.trim()) ?? 0.0, status: 'paid');
    final created = await DatabaseHelper.instance.createInvoice(inv);
    // generate receipt as PDF
    await ReceiptGenerator.generateInvoicePdf(created, selectedStudent!, selectedPlan!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment saved and receipt generated')));
    _amount.clear();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Collect Payment')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          DropdownButton<Student>(hint: Text('Select Student'), value: selectedStudent, items: students.map((s)=> DropdownMenuItem(child: Text(s.name), value: s)).toList(), onChanged: (v){ setState(()=> selectedStudent = v);}),
          DropdownButton<FeePlan>(hint: Text('Select Fee Plan'), value: selectedPlan, items: plans.map((p)=> DropdownMenuItem(child: Text(p.name + ' - ' + p.amount.toString()), value: p)).toList(), onChanged: (v){ setState(()=> selectedPlan = v);}),
          TextField(controller: _amount, decoration: InputDecoration(labelText: 'Amount Paid'), keyboardType: TextInputType.number),
          SizedBox(height:8),
          ElevatedButton(onPressed: _savePayment, child: Text('Save Payment & Generate Receipt')),
        ]),
      ),
    );
  }
}
