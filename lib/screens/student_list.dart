import 'package:flutter/material.dart';
import '../models/student.dart';
import '../db/database_helper.dart';
import 'add_student.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    setState(() => loading = true);
    students = await DatabaseHelper.instance.readAllStudents();
    setState(() => loading = false);
  }

  Future _delete(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        actions: [
          IconButton(onPressed: () => Navigator.pushNamed(context, '/feeplans'), icon: Icon(Icons.money)),
          IconButton(onPressed: () => Navigator.pushNamed(context, '/payments'), icon: Icon(Icons.payment)),
          IconButton(onPressed: () => Navigator.pushNamed(context, '/invoices'), icon: Icon(Icons.receipt)),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
      students.isEmpty ? Center(child: Text('No students yet. Tap + to add')) :
      ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, i) {
          final s = students[i];
          return ListTile(
            title: Text(s.name),
            subtitle: Text('Class: ${s.studentClass} • Guardian: ${s.guardian}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () async {
                final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddStudentScreen(student: s)));
                if (res == true) _load();
              }),
              IconButton(icon: Icon(Icons.delete), onPressed: () async {
                final ok = await showDialog(context: context, builder: (_) => AlertDialog(
                  title: Text('Delete?'),
                  content: Text('Delete ${s.name}?'),
                  actions: [
                    TextButton(onPressed: ()=> Navigator.pop(context,false), child: Text('No')),
                    TextButton(onPressed: ()=> Navigator.pop(context,true), child: Text('Yes')),
                  ],
                ));
                if (ok == true) _delete(s.id!);
              }),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.pushNamed(context, '/add');
          if (res == true) _load();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
