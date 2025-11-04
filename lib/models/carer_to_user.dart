/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class CarerToUser {
  final int carerId;
  final int userId;

  CarerToUser({
    required this.carerId,
    required this.userId
  });

  // Assign User to Carer by id.
  static Future<void> assignCarerToUser(int carerId, int userId, Database database) async {
    await database.insert(
      "carer_to_user",
      {
        "carer_id" : carerId,
        "user_id" : userId
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}