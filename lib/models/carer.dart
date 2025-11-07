/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'dart:async';
import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:crypto/crypto.dart';

import 'package:prototype_project/models/carer_to_user.dart';
import 'package:prototype_project/models/user.dart';

class Carer {
  final int id;
  final String name;
  final String password;

  Carer({
    required this.id,
    required this.name,
    required this.password
  });

  // Create a new Carer entity.
  static Future<Carer> create(String name, String password, Database database) async {
    final String hashedPassword = sha256.convert(utf8.encode(password)).toString() ;
    final int id = await database.insert(
      "carer", 
      {
        "name" : name,
        "password" : hashedPassword
      },
    );

    return Carer(id: id, name: name, password: hashedPassword);
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
      password: map["password"] as String
    );
  }

  @override
  bool operator ==(covariant Carer other) {
    return id == other.id && name == other.name && password == other.password;
  }

  @override
  int get hashCode => Object.hash(id, name, password);
}