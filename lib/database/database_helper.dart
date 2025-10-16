import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bmi_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bmi_records.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE bmi_records ADD COLUMN gender TEXT NOT NULL DEFAULT "Male"',
      );
      await db.execute(
        'ALTER TABLE bmi_records ADD COLUMN age INTEGER NOT NULL DEFAULT 25',
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE bmi_records ADD COLUMN activityLevel TEXT NOT NULL DEFAULT "Sedentary"',
      );
      await db.execute(
        'ALTER TABLE bmi_records ADD COLUMN bodyComposition TEXT NOT NULL DEFAULT "Balanced"',
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const realType = 'REAL NOT NULL';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE bmi_records (
        id $idType,
        height $realType,
        weight $realType,
        bmi $realType,
        status $textType,
        date $textType,
        gender $textType,
        age $intType,
        activityLevel $textType,
        bodyComposition $textType
      )
    ''');
  }

  Future<int> insertRecord(BmiRecord record) async {
    final db = await database;
    return await db.insert('bmi_records', record.toMap());
  }

  Future<List<BmiRecord>> getAllRecords() async {
    final db = await database;
    const orderBy = 'date DESC';
    final result = await db.query('bmi_records', orderBy: orderBy);
    return result.map((map) => BmiRecord.fromMap(map)).toList();
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete('bmi_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
