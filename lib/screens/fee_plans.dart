import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/fee_plan.dart';
import 'dart:async';

class FeePlanListScreen extends StatefulWidget {
  @override
  _FeePlanListScreenState createState() => _FeePlanListScreenState();
}

class _FeePlanListScreenState extends State<FeePlanListScreen> {
  List<FeePlan> plans = [];
  bool loading = true;

  final _name = TextEditingController();
  final _amount = TextEditingController();
  String _frequency = 'monthly';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    setState(()=> loading=true);
    plans = await DatabaseHelper.instance.readAllFeePlans();
    setState(()=> loading=false);
  }

  Future _save() async {
    if(_name.text.trim().isEmpty || _amount.text.trim().isEmpty) return;
    final f = FeePlan(name: _name.text.trim(), amount: double.tryParse(_amount.text.trim()) ?? 0.0, frequency: _frequency);
    await DatabaseHelper.instance.createFeePlan(f);
    _name.clear(); _amount.clear();
    await _load();
  }

  Future _delete(int id) async {
    await DatabaseHelper.instance.deleteFeePlan(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fee Plans')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: _name, decoration: InputDecoration(labelText: 'Plan name (e.g., Tuition Monthly)')),
          TextField(controller: _amount, decoration: InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
          DropdownButton<String>(value: _frequency, items: ['monthly','term','one-time'].map((e)=>DropdownMenuItem(child: Text(e), value: e)).toList(), onChanged: (v){ if(v!=null) setState(()=>_frequency=v);}),
          SizedBox(height:8),
          ElevatedButton(onPressed: _save, child: Text('Save Plan')),
          SizedBox(height:12),
          Expanded(child: loading? Center(child:CircularProgressIndicator()) : ListView.builder(itemCount: plans.length, itemBuilder: (ctx,i){ final p=plans[i]; return ListTile(title: Text(p.name), subtitle: Text('\${p.amount} • \${p.frequency}'), trailing: IconButton(icon: Icon(Icons.delete), onPressed: ()=> _delete(p.id!))); })),
        ]),
      ),
    );
  }
}
