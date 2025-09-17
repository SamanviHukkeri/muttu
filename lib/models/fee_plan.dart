class FeePlan {
  int? id;
  String name;
  double amount;
  String frequency; // monthly/term/one-time

  FeePlan({this.id, required this.name, required this.amount, required this.frequency});

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'amount': amount,
      'frequency': frequency,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory FeePlan.fromMap(Map<String, dynamic> map) {
    return FeePlan(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      frequency: map['frequency'],
    );
  }
}
