/// App user model mapped to 'users' table.
/// Note: password is stored as salted+hashed (no plain text).
class User {
  final int? id;
  final String fullName;
  final String email;
  final String username;
  final String passwordHash;
  final String salt;
  final int termsAccepted; // 0/1

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.passwordHash,
    required this.salt,
    required this.termsAccepted,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'username': username,
    'password_hash': passwordHash,
    'salt': salt,
    'terms_accepted': termsAccepted,
    'created_at': DateTime.now().toIso8601String(),
  };

  static User fromMap(Map<String, Object?> m) => User(
    id: m['id'] as int?,
    fullName: m['full_name'] as String,
    email: m['email'] as String,
    username: m['username'] as String,
    passwordHash: m['password_hash'] as String,
    salt: m['salt'] as String,
    termsAccepted: (m['terms_accepted'] as int),
  );
}
