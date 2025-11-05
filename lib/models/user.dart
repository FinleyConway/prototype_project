/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name
  });

  Map<String, Object?> toMap() {
    return { "id" : id, "name" : name };
  }

  static User fromMap(Map<String, Object?> map) {
    return User(
      id: map["id"] as int, 
      name: map["name"] as String, 
    );
  }

  // Create a new User entity.
  static Future<int> create(String name, Database database) async {
    return await database.insert(
      "user",
      {
        "name" : name
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Get the User entity by id.
  static Future<User?> get(int userId, Database database) async {
    final result = await database.query(
      "user",
      where: "id = ?",
      whereArgs: [userId]
    );

    return result.isNotEmpty ? fromMap(result.first) : null;
  }

  @override
  bool operator ==(covariant User other) {
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}