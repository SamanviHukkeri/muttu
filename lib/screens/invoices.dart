import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/invoice.dart';
import 'package:intl/intl.dart';

class InvoiceListScreen extends StatefulWidget {
  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<Invoice> invoices = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    invoices = await DatabaseHelper.instance.readAllInvoices();
    setState(()=> loading=false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoices')),
      body: loading ? Center(child:CircularProgressIndicator()) : invoices.isEmpty ? Center(child: Text('No invoices')) :
      ListView.builder(itemCount: invoices.length, itemBuilder: (ctx,i){ final inv=invoices[i]; return ListTile(title: Text('Invoice #\${inv.id} - \${inv.amount}'), subtitle: Text('\${inv.date} • Status: \${inv.status}'),); }),
    );
  }
}
