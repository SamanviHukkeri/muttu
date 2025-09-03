class Invoice {
  int? id;
  int studentId;
  int feePlanId;
  String date; // yyyy-mm-dd
  double amount;
  double paid;
  String status; // paid/partial/pending

  Invoice({
    this.id,
    required this.studentId,
    required this.feePlanId,
    required this.date,
    required this.amount,
    this.paid = 0.0,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    final map = {
      'studentId': studentId,
      'feePlanId': feePlanId,
      'date': date,
      'amount': amount,
      'paid': paid,
      'status': status,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      studentId: map['studentId'],
      feePlanId: map['feePlanId'],
      date: map['date'],
      amount: map['amount'],
      paid: map['paid'],
      status: map['status'],
    );
  }
}
