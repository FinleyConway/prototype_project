import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;

/// Generate a cryptographically-secure random salt (Base64).
String genSalt([int length = 16]) {
  final rnd = Random.secure();
  final bytes = List<int>.generate(length, (_) => rnd.nextInt(256));
  return base64Url.encode(bytes);
}

/// Hash = SHA-256(password + ":" + salt)
/// Note: for production consider Argon2/BCrypt/SCrypt.
/// Here SHA-256 is used for a simple offline prototype.
String hashPassword(String password, String salt) {
  final bytes = utf8.encode('$password:$salt');
  final digest = crypto.sha256.convert(bytes);
  return digest.toString();
}
