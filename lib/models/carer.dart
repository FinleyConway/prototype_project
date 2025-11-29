/// @Created on: 4/11/25
/// @Author: Bodoor Albassam, Finley Conway

import 'dart:async';


import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

import 'package:prototype_project/models/carer_to_user.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/utils/auth.dart';

class Carer {
  final int id;
  final String name;
  final String email;
  final String username;
  final String password;
  final String salt;
  final bool termsAccepted;

  Carer({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.salt,
    required this.termsAccepted
  });

  // Create a new Carer entity.
  static Future<Carer> create(String name, String email, String username, String password, bool termsAccepted, Database database) async {
    final HashString hash = Auth.createHashString(password);
    final int id = await database.insert(
      "carer", 
      {
        "name" : name,
        "email" : email,
        "username" : username,
        "password" : hash.hashValue,
        "salt" : hash.salt,
        "terms_accepted" : termsAccepted ? 1 : 0
      },
    );

    return Carer(id: id, name: name, email: email, username: username, password: hash.hashValue, salt: hash.salt, termsAccepted: termsAccepted);
  }
  
  // Get the Carer entity by id.
  static Future<Carer?> getById(int carerId, Database database) async {
    final result = await database.query(
      "carer",
      where: "id = ?",
      whereArgs: [carerId]
    );

    return result.isNotEmpty ? _fromMap(result.first) : null;
  }

  // Get the Carer entity by username.
  static Future<Carer?> getByUsername(String carerUsername, Database database) async {
    final result = await database.query(
      "carer",
      where: "username = ?",
      whereArgs: [carerUsername]
    );

    return result.isNotEmpty ? _fromMap(result.first) : null;
  }

  // Get the Carer entity by username.
  static Future<Carer?> getByEmail(String carerEmail, Database database) async {
    final result = await database.query(
      "carer",
      where: "email = ?",
      whereArgs: [carerEmail]
    );

    return result.isNotEmpty ? _fromMap(result.first) : null;
  }

  // Assign User to Carer by id.
  Future<void> assignUser(int userId, Database database) async {
    CarerToUser.assignCarerToUser(id, userId, database);
  }

  // Get all Users assigned to Carer by id.
  Future<List<User>> getAllUsers(Database database) async {
    final result = await database.rawQuery("""
      SELECT user.id, user.name
      FROM user
      INNER JOIN carer_to_user ON user.id = carer_to_user.user_id
      WHERE carer_to_user.carer_id = ?
    """, [id]);

    // uses the map iterator to go through each element map it into a user object
    return result.map((row) => User.fromMap(row)).toList();
  }

  static Carer _fromMap(Map<String, Object?> map) {
    return Carer(
      id: map["id"] as int,
      name: map["name"] as String,
      email: map["email"] as String,
      username: map["username"] as String,
      password: map["password"] as String,
      salt: map["salt"] as String,
      termsAccepted: (map["terms_accepted"] as int) == 1, 
    );
  }

  
  @override
  bool operator ==(covariant Carer other) {
    return 
      id == other.id &&
      name == other.name &&
      email == other.email &&
      username == other.username &&
      password == other.password &&
      salt == other.salt &&
      termsAccepted == other.termsAccepted;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    username,
    password,
    salt,
    termsAccepted,
  );
}