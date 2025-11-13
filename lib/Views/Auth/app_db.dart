import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Local SQLite database:
/// - users: stores salted+hashed passwords (never plain text)
/// - otp_codes: temporary OTP store for password reset
class AppDb {
  static Future<Database> open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'carepanion.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        // Users table with security-related columns
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            full_name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            username TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL,
            salt TEXT NOT NULL,
            terms_accepted INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
          );
        ''');

        // OTPs expire by timestamp; rows get overwritten per email
        await db.execute('''
          CREATE TABLE otp_codes(
            email TEXT PRIMARY KEY,
            code TEXT NOT NULL,
            expires_at INTEGER NOT NULL
          );
        ''');
      },
    );
  }
}
