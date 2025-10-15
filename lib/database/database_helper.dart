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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const realType = 'REAL NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE bmi_records (
        id $idType,
        height $realType,
        weight $realType,
        bmi $realType,
        status $textType,
        date $textType
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
