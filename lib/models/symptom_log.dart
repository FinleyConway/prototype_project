/// @Created on: 7/11/25
/// @Author: Finley Conway

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

enum Symptom {
  moodChanges,
  memoryLoss
  //...
}

enum SymptomOrder {
  ascend,
  descend
}

enum SymptomSortBy {
  date,
  symptomType,
}

class SymptomLog {
  final int id;
  final int userId;
  final Symptom symptomType;
  final String notes;
  final DateTime timestamp;

  SymptomLog({
    required this.id, 
    required this.userId, 
    required this.symptomType, 
    required this.notes, 
    required this.timestamp
  });

  static Future<SymptomLog> create(int userId, Symptom symptom, String notes, DateTime timestamp, Database database) async {
    final int id = await database.insert(
      "symptom_log",
      {
        "user_id" : userId,
        "symptom_type" : symptom.index,
        "notes" : notes,
        "timestamp_unix" : _getUnixTime(timestamp)
      },
    );

    return SymptomLog(id: id, userId: userId, symptomType: symptom, notes: notes, timestamp: timestamp);
  }

  static Future<List<SymptomLog>> getAll(int userId, SymptomOrder order, SymptomSortBy sort, Database database) async {
    String sortBy;

    switch (sort) {
      case SymptomSortBy.date: sortBy = "timestamp_unix"; break;
      case SymptomSortBy.symptomType: sortBy = "symptom_type"; break;
    }

    String orderBy = order == SymptomOrder.ascend ? "ASC" : "DESC";

    final result = await database.query(
      "symptom_log",
      orderBy: "$sortBy $orderBy",
      where: "user_id = ?",
      whereArgs: [userId]
    );

    return result.map((row) => SymptomLog._fromMap(row)).toList();
  }

  static SymptomLog _fromMap(Map<String, Object?> map) {
    return SymptomLog(
      id: map["id"] as int, 
      userId: map["user_id"] as int,
      symptomType: Symptom.values[map["symptom_type"] as int],
      notes: map["notes"] as String,
      timestamp: _getDateFromUnix(map["timestamp_unix"] as int)
    );
  }

  static int _getUnixTime(DateTime time) {
    return time.toUtc().millisecondsSinceEpoch;
  }

  static DateTime _getDateFromUnix(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();
  }

  @override
  bool operator ==(covariant SymptomLog other) {
    return 
      id == other.id && 
      userId== other.userId && 
      symptomType == other.symptomType && 
      notes == other.notes && 
      timestamp == other.timestamp;
  }
  
  @override
  int get hashCode => Object.hash(id, userId, symptomType, notes, timestamp);
}