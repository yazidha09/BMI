class BmiRecord {
  final int? id;
  final double height;
  final double weight;
  final double bmi;
  final String status;
  final DateTime date;
  final String gender;
  final int age;
  final String activityLevel;
  final String bodyComposition;

  BmiRecord({
    this.id,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.status,
    required this.date,
    required this.gender,
    required this.age,
    required this.activityLevel,
    required this.bodyComposition,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'status': status,
      'date': date.toIso8601String(),
      'gender': gender,
      'age': age,
      'activityLevel': activityLevel,
      'bodyComposition': bodyComposition,
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
      gender: map['gender'] as String,
      age: map['age'] as int,
      activityLevel: map['activityLevel'] as String,
      bodyComposition: map['bodyComposition'] as String,
    );
  }
}
