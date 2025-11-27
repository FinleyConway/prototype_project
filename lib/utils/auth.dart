/// @Created on: 13/11/25
/// @Author: Bodoor Albassam, Finley Conway

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'package:sqflite/sqflite.dart'
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

import 'package:prototype_project/models/carer.dart';

class SignUpResult {
  final bool success;
  String error;

  SignUpResult(this.success, this.error);
}

class HashString {
  String hashValue;
  String salt;

  HashString(this.hashValue, this.salt);
}

class Auth {
  /// Hash = SHA-256(password + ":" + salt)
  /// Note: for production consider Argon2/BCrypt/SCrypt.
  /// Here SHA-256 is used for a simple offline prototype.
  static HashString createHashString(String value, [int length = 16]) {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(length, (_) => random.nextInt(256));

    final String salt = base64Url.encode(bytes);
    final String hash = sha256.convert(utf8.encode("$value:$salt")).toString();

    return HashString(hash, salt);
  }

  // Password matching validation check
  static bool validateHashString(String password, String salt, String enteredPassword) {
    return password == sha256.convert(utf8.encode("$enteredPassword:$salt")).toString();
  }

  // Create a new account if email/username are unique.
  static Future<SignUpResult> signUp(String name, String email, String username, String password, bool termsAccepted, Database database) async {
    // check for duplicated carers
    if (await Carer.getByEmail(email, database) != null) {
      return SignUpResult(false, "Email already registered");
    } 

    if (await Carer.getByUsername(username, database) != null) {
      return SignUpResult(false, "Username already taken");
    }

    await Carer.create(name, email, username, password, termsAccepted, database);

    return SignUpResult(true, "");
  }

  // Verify entered password by hashing it with the stored salt.
  static Future<Carer?> checkCredentials(String credentials, String password, Database database) async {
    Carer? carer;

    carer = await Carer.getByEmail(credentials, database);
    carer = await Carer.getByUsername(credentials, database);

    if (carer != null) {
      if (validateHashString(carer.password, carer.salt, password)) {
        return carer;
      }
    }

    return carer; // no carer found, return null
  }

  // ---------- Forgot password (OTP via demo) ----------

  /// Auth data layer:
  /// - All DB reads/writes for users and OTPs
  /// - Passwords are never stored in plain text (salt + SHA256)
  static Future<String> generateOtpFor(String email, Database database) async {
    final String code = (100000 + DateTime.now().millisecond % 900000).toString(); // demo only
    final int expires = DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;

    await database.insert(
      'otp_codes',
      {
        'email': email, 
        'code': code, 
        'expires_at': expires
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return code;         
  }

  /// Validate OTP and expiry time.
  static Future<bool> verifyOtp(String email, String code, Database database) async {
    final rows = await database.query('otp_codes', where: 'email=?', whereArgs: [email], limit: 1);

    if (rows.isEmpty) return false;

    final row = rows.first;
    final ok = row['code'] == code && (row['expires_at'] as int) > DateTime.now().millisecondsSinceEpoch;

    return ok;
  }

  /// After OTP success: set a new salt+hash and cleanup the OTP row.
  static Future<void> updatePasswordByEmail(String email, String newPassword, Database database) async {
    final HashString hash = createHashString(newPassword);

    await database.update('carer', {'password_hash': hash.hashValue, 'salt': hash.salt}, where: 'email=?', whereArgs: [email]);
    await database.delete('otp_codes', where: 'email=?', whereArgs: [email]);
  }
}