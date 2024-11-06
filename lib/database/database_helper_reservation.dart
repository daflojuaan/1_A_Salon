import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'reservations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE reservations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            service TEXT,
            barber TEXT,
            time TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertReservation(DateTime date, String service, String barber, String time) async {
    final db = await database;
    await db.insert(
      'reservations',
      {
        'date': date.toIso8601String(),
        'service': service,
        'barber': barber,
        'time': time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getReservations() async {
    final db = await database;
    return await db.query('reservations', orderBy: 'date ASC');
  }

  Future<void> deleteReservation(int id) async {
    final db = await database;
    await db.delete(
      'reservations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
