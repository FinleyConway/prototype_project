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

  Map<String, Object?> toMap() {
    return { "id" : id, "name" : name, "password" : password };
  }

  static Carer fromMap(Map<String, Object?> map) {
    return Carer(
      id: map["id"] as int, 
      name: map["name"] as String, 
      password: map["password"] as String
    );
  }



  // Create a new Carer entity.
  static Future<int> create(String name, String password, Database database) async {
    return await database.insert(
      "carer", 
      {
        "name" : name,
        "password" : sha256.convert(utf8.encode(password)).toString() // will probably turn this into a function soon
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  // Get the Carer entity by id.
  static Future<Carer?> getById(int carerId, Database database) async {
    final result = await database.query(
      "carer",
      where: "id = ?",
      whereArgs: [carerId]
    );

    return result.isNotEmpty ? fromMap(result.first) : null;
  }

  // Assign User to Carer by id.
  static Future<void> assignUser(int carerId, int userId, Database database) async {
    CarerToUser.assignCarerToUser(carerId, userId, database);
  }

  // Get all Users assigned to Carer by id.
  static Future<List<User>> getAllUsers(int carerId, Database database) async {
    final result = await database.rawQuery("""
      SELECT user.id, user.name
      FROM user
      INNER JOIN carer_to_user ON user.id = carer_to_user.user_id
      WHERE carer_to_user.carer_id = ?
    """, [carerId]);

    // uses the map iterator to go through each element map it into a user object
    return result.map((row) => User.fromMap(row)).toList();
  }

  @override
  bool operator ==(Object other) {
    // literally has the same problem as python...
    if (other is! Carer) { 
      return false;
    }

    // actual comparison
    return id == other.id && name == other.name && password == other.password;
  }

  @override
  int get hashCode => Object.hash(id, name, password);
}