/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:sqflite/sqflite.dart' // mobile sqflite
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
    await database.execute(_createUserTable());
    await database.execute(_createCarerToUserTable());
    await database.execute(_createUserEventTable());
    await database.execute(_createSymptomLogTable());
    await database.execute(_createContactTable());
  }

  static String _createCarerTable() {
    return """
      CREATE TABLE carer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        password TEXT
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

  static String _createUserEventTable() {
    return """
      CREATE TABLE user_event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT,
        location TEXT,
        event_type INTEGER,
        repeat_type INTEGER,
        reminder_time_unix INTEGER,
        notes TEXT,
        completed INT,
        event_detail_json TEXT,
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
    """;
  }

  static String _createSymptomLogTable() {
    return """
      CREATE TABLE symptom_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        symptom_type INTEGER,
        notes TEXT,
        timestamp_unix INTEGER,
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
    """;
  }

  static String _createContactTable() {
    return """
      CREATE TABLE contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        name TEXT,
        relation TEXT,
        phone_number TEXT,
        secondary_phone_number TEXT,
        notes TEXT,
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
    """;
  }
}