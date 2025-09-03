import 'package:flutter/material.dart';
import '../models/student.dart';
import '../db/database_helper.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? student;
  AddStudentScreen({this.student});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _guardian = TextEditingController();
  final _phone = TextEditingController();
  final _class = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _name.text = widget.student!.name;
      _dob.text = widget.student!.dob;
      _guardian.text = widget.student!.guardian;
      _phone.text = widget.student!.phone;
      _class.text = widget.student!.studentClass;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _dob.dispose();
    _guardian.dispose();
    _phone.dispose();
    _class.dispose();
    super.dispose();
  }

  Future _save() async {
    if (!_formKey.currentState!.validate()) return;
    final s = Student(
      name: _name.text.trim(),
      dob: _dob.text.trim(),
      guardian: _guardian.text.trim(),
      phone: _phone.text.trim(),
      studentClass: _class.text.trim(),
    );

    if (widget.student == null) {
      await DatabaseHelper.instance.createStudent(s);
    } else {
      s.id = widget.student!.id;
      await DatabaseHelper.instance.updateStudent(s);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Student' : 'Add Student')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _name, decoration: InputDecoration(labelText: 'Name'), validator: (v)=> v==null||v.isEmpty? 'Required':null),
              TextFormField(controller: _dob, decoration: InputDecoration(labelText: 'DOB (dd-mm-yyyy)')),
              TextFormField(controller: _guardian, decoration: InputDecoration(labelText: 'Guardian Name')),
              TextFormField(controller: _phone, decoration: InputDecoration(labelText: 'Phone')),
              TextFormField(controller: _class, decoration: InputDecoration(labelText: 'Class')),
              SizedBox(height:12),
              ElevatedButton(onPressed: _save, child: Text(isEdit? 'Update' : 'Save'))
            ],
          ),
        ),
      ),
    );
  }
}
