import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/student.dart';
import '../models/fee_plan.dart';
import '../models/invoice.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tuition_full.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dob TEXT,
        guardian TEXT,
        phone TEXT,
        studentClass TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE fee_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        frequency TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        feePlanId INTEGER NOT NULL,
        date TEXT,
        amount REAL,
        paid REAL DEFAULT 0,
        status TEXT,
        FOREIGN KEY(studentId) REFERENCES students(id),
        FOREIGN KEY(feePlanId) REFERENCES fee_plans(id)
      )
    '''); 
  }

  // Student CRUD
  Future<Student> createStudent(Student s) async {
    final db = await instance.database;
    final id = await db.insert('students', s.toMap());
    s.id = id;
    return s;
  }

  Future<List<Student>> readAllStudents() async {
    final db = await instance.database;
    final result = await db.query('students', orderBy: 'name');
    return result.map((e) => Student.fromMap(e)).toList();
  }

  Future<int> updateStudent(Student s) async {
    final db = await instance.database;
    return db.update('students', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // FeePlan CRUD
  Future<FeePlan> createFeePlan(FeePlan f) async {
    final db = await instance.database;
    final id = await db.insert('fee_plans', f.toMap());
    f.id = id;
    return f;
  }

  Future<List<FeePlan>> readAllFeePlans() async {
    final db = await instance.database;
    final result = await db.query('fee_plans', orderBy: 'name');
    return result.map((e) => FeePlan.fromMap(e)).toList();
  }

  Future<int> updateFeePlan(FeePlan f) async {
    final db = await instance.database;
    return db.update('fee_plans', f.toMap(), where: 'id = ?', whereArgs: [f.id]);
  }

  Future<int> deleteFeePlan(int id) async {
    final db = await instance.database;
    return db.delete('fee_plans', where: 'id = ?', whereArgs: [id]);
  }

  // Invoice CRUD
  Future<Invoice> createInvoice(Invoice inv) async {
    final db = await instance.database;
    final id = await db.insert('invoices', inv.toMap());
    inv.id = id;
    return inv;
  }

  Future<List<Invoice>> readAllInvoices() async {
    final db = await instance.database;
    final result = await db.query('invoices', orderBy: 'date DESC');
    return result.map((e) => Invoice.fromMap(e)).toList();
  }

  Future<int> updateInvoice(Invoice inv) async {
    final db = await instance.database;
    return db.update('invoices', inv.toMap(), where: 'id = ?', whereArgs: [inv.id]);
  }

  Future<int> deleteInvoice(int id) async {
    final db = await instance.database;
    return db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
