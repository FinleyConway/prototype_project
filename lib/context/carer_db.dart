/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:sqflite/sqflite.dart'
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class CarerDb {
  static Future<Database> create([String? path]) async
  {
    Database db = await openDatabase(
      path ?? inMemoryDatabasePath, // creates a database within memory or by specific path
      version: 1,
      onCreate: _onCreateTables
    ); 

    return db;
  }

  static Future<void> _onCreateTables(Database database, int version) async {
    await database.execute(_createCarerTable());
    await database.execute(_createOtpCodesTable());
    await database.execute(_createUserTable());
    await database.execute(_createCarerToUserTable());
    await database.execute(_createEventTypeTable());
    await database.execute(_createUserEventTable());
    await database.execute(_createSymptomLogTable());
  }

  static String _createCarerTable() {
    return """
      CREATE TABLE carer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        username TEXT,
        password TEXT,
        salt TEXT,
        terms_accepted INTEGER DEFAULT 0
      );
    """;
  }

  static String _createOtpCodesTable() {
    return """
      CREATE TABLE otp_codes(
        email TEXT PRIMARY KEY,
        code TEXT,
        expires_at INTEGER
      );
    """;
  }

  static String _createUserTable() {
    return """
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      );
    """;
  }

  static String _createCarerToUserTable() {
    return """
      CREATE TABLE carer_to_user (
        carer_id INTEGER,
        user_id INTEGER,
        PRIMARY KEY (carer_id, user_id),
        FOREIGN KEY (carer_id) REFERENCES carer(id),
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
    """;
  }

  static String _createEventTypeTable() {
    return """
      CREATE TABLE event_type (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      );
    """;
  }

  static String _createUserEventTable() {
    return """
      CREATE TABLE user_event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        event_type_id INTEGER,
        title TEXT,
        message TEXT,
        is_all_day INT,
        repeat_type INT,
        reminder_time_unix INT,
        event_detail_json TEXT,
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (event_type_id) REFERENCES event_type(id)
      );
    """;
  }

  static String _createSymptomLogTable() {
    return """
      CREATE TABLE symptom_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        symptom_type INT,
        notes TEXT,
        timestamp_unix INT,
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
    """;
  }
}