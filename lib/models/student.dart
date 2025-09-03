class Student {
  int? id;
  String name;
  String dob;
  String guardian;
  String phone;
  String studentClass;

  Student({
    this.id,
    required this.name,
    required this.dob,
    required this.guardian,
    required this.phone,
    required this.studentClass,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'dob': dob,
      'guardian': guardian,
      'phone': phone,
      'studentClass': studentClass,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      dob: map['dob'],
      guardian: map['guardian'],
      phone: map['phone'],
      studentClass: map['studentClass'],
    );
  }
}
