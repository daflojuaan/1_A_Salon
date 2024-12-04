import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperReservasi{
  // Database name and version
  static const _databaseName = 'reservasi.db';
  static const _databaseVersion = 1;

  // TABLE DAN KOLOM
  static const table = 'reservations';
  static const columnId = 'id';
  static const columnDate = 'date';
  static const columnTime = 'time';
  static const columnBarber = 'barber';
  static const columnService = 'service';
  static const columnStatus = 'status';

  // Singleton pattern
  DatabaseHelperReservasi._privateConstructor();
  static final DatabaseHelperReservasi instance =
      DatabaseHelperReservasi._privateConstructor();

  // Database reference
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnDate TEXT NOT NULL,
      $columnTime TEXT NOT NULL,
      $columnBarber TEXT NOT NULL,
      $columnService TEXT NOT NULL,
      $columnStatus TEXT NOT NULL
    )
  ''');
  }

  // Insert RESERVASI
  Future<int> insertReservation(Map<String, dynamic> reservation) async {
    Database db = await database;
    return await db.insert(table, reservation);
  }

  // Get all active reservations
  Future<List<Map<String, dynamic>>> getActiveReservations() async {
    Database db = await database;
    return await db.query(
      table,
      where: '$columnStatus = ?',
      whereArgs: ['Booked'],
      orderBy: '$columnDate DESC',
    );
  }

  // Get reservation by ID
  Future<Map<String, dynamic>?> getReservation(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update RESERVASI
  Future<int> updateReservation(Map<String, dynamic> reservation) async {
    Database db = await database;
    int id = reservation[columnId];
    return await db.update(
      table,
      reservation,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete RESERVASI
  Future<int> deleteReservation(int id) async {
    Database db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

// update reservasi di riwayat menjadi cancel
Future<int> cancelReservation(int id) async {
  Database db = await database;
  return await db.update(
    table,
    {columnStatus: 'Canceled'}, 
    where: '$columnId = ?',
    whereArgs: [id],
  );
}

// all cancel
Future<List<Map<String, dynamic>>> getCanceledReservations() async {
  Database db = await database;
  return await db.query(
    table,
    where: '$columnStatus = ?',
    whereArgs: ['Canceled'],
    orderBy: '$columnDate DESC',
  );
}

  // Close database connection
  Future close() async {
    Database db = await database;
    db.close();
  }
}
