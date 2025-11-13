import 'dart:math';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'app_db.dart';
import 'user.dart';
import 'hash.dart';

/// Auth data layer:
/// - All DB reads/writes for users and OTPs
/// - Passwords are never stored in plain text (salt + SHA256)
class AuthRepository {
  static Future<Database> _db() => AppDb.open();

  /// Create a new account if email/username are unique.
  /// Returns `null` on success, or an error string for the UI.
  static Future<String?> signUp({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required bool termsAccepted,
  }) async {
    final db = await _db();

    // Prevent duplicate identities
    final existingEmail = await db.query('users', where: 'email=?', whereArgs: [email]);
    if (existingEmail.isNotEmpty) return 'Email already registered';
    final existingUser = await db.query('users', where: 'username=?', whereArgs: [username]);
    if (existingUser.isNotEmpty) return 'Username already taken';

    // Salt + hash for secure storage
    final salt = genSalt();
    final hash = hashPassword(password, salt);

    final u = User(
      fullName: fullName,
      email: email,
      username: username,
      passwordHash: hash,
      salt: salt,
      termsAccepted: termsAccepted ? 1 : 0,
    );

    await db.insert('users', u.toMap());
    return null;
  }

  /// Fetch a user by either username OR email.
  static Future<User?> findByUsernameOrEmail(String id) async {
    final db = await _db();
    final res = await db.query('users',
        where: 'username=? OR email=?', whereArgs: [id, id], limit: 1);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  /// Verify entered password by hashing it with the stored salt.
  static Future<User?> checkCredentials(String id, String password) async {
    final user = await findByUsernameOrEmail(id);
    if (user == null) return null;
    final h = hashPassword(password, user.salt);
    if (h == user.passwordHash) return user;
    return null;
  }

  /// Username availability check (used during sign up).
  static Future<bool> usernameAvailable(String username) async {
    final db = await _db();
    final res = await db.query('users', where: 'username=?', whereArgs: [username], limit: 1);
    return res.isEmpty;
  }

  // ---------- Forgot password (OTP via demo) ----------

  /// Returns true if email exists in the system.
  static Future<bool> emailExists(String email) async {
    final db = await _db();
    final res = await db.query('users', where: 'email=?', whereArgs: [email], limit: 1);
    return res.isNotEmpty;
  }

  /// Generate a demo OTP (client-side) and store with expiry.
  /// In production this must come from a backend service via email/SMS.
  static Future<String> generateOtpFor(String email) async {
    final db = await _db();
    final code = (100000 + DateTime.now().millisecond % 900000).toString(); // demo only
    final expires = DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;
    await db.insert(
      'otp_codes',
      {'email': email, 'code': code, 'expires_at': expires},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return code;
  }

  /// Validate OTP and expiry time.
  static Future<bool> verifyOtp(String email, String code) async {
    final db = await _db();
    final rows = await db.query('otp_codes', where: 'email=?', whereArgs: [email], limit: 1);
    if (rows.isEmpty) return false;
    final row = rows.first;
    final ok = row['code'] == code &&
        (row['expires_at'] as int) > DateTime.now().millisecondsSinceEpoch;
    return ok;
  }

  /// After OTP success: set a new salt+hash and cleanup the OTP row.
  static Future<void> updatePasswordByEmail(String email, String newPassword) async {
    final db = await _db();
    final salt = genSalt();
    final hash = hashPassword(newPassword, salt);
    await db.update('users', {'password_hash': hash, 'salt': salt}, where: 'email=?', whereArgs: [email]);
    await db.delete('otp_codes', where: 'email=?', whereArgs: [email]);
  }
}
