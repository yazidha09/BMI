class BmiRecord {
  final int? id;
  final double height;
  final double weight;
  final double bmi;
  final String status;
  final DateTime date;

  BmiRecord({
    this.id,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'status': status,
      'date': date.toIso8601String(),
    };
  }

  factory BmiRecord.fromMap(Map<String, dynamic> map) {
    return BmiRecord(
      id: map['id'] as int?,
      height: map['height'] as double,
      weight: map['weight'] as double,
      bmi: map['bmi'] as double,
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}
