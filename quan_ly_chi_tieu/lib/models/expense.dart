
class Expense {
  String id;
  String title;
  double amount;
  DateTime date;
  String category;
  String type;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(), // Chuyển đổi kiểu dữ liệu amount sang double
      date: DateTime.parse(map['date']),
      category: map['category'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type,
    };
  }
}
