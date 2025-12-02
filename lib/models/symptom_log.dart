/// @Created on: 7/11/25
/// @Author: Finley Conway

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

enum SymptomType {
  symptom1,
  symptom2,
  symptom3
}

enum MoodType {
  mood1,
  mood2,
  mood3
}

enum CategoryType {
  category1,
  category2,
  category3
}

enum SymptomOrder {
  ascend,
  descend
}

enum SymptomSortBy {
  date,
  symptomType,
}

class Log {
  final SymptomType symptomType;
  final int symptomSeverity;
  final MoodType moodType;
  final String trigger;
  final String responseTaken;
  final CategoryType categoryType;
  final String notes;

  Log({
    required this.symptomType, 
    required this.symptomSeverity, 
    required this.moodType, 
    required this.trigger, 
    required this.responseTaken, 
    required this.categoryType, 
    required this.notes
  });

  @override
  bool operator ==(covariant Log other) {
    return 
      symptomType == other.symptomType && 
      symptomSeverity == other.symptomSeverity && 
      moodType == other.moodType &&
      trigger == other.trigger &&
      responseTaken == other.responseTaken && 
      categoryType == other.categoryType &&
      notes == other.notes;
  }
  
  @override
  int get hashCode => Object.hash(
    symptomType, 
    symptomSeverity, 
    moodType, trigger, 
    responseTaken, 
    categoryType, 
    notes
  );
}

class SymptomLog {
  final int id;
  final int userId;
  final Log log;
  final DateTime timestamp;

  SymptomLog({
    required this.id, 
    required this.userId, 
    required this.log,
    required this.timestamp
  });

  static Future<SymptomLog> create(int userId, Log log, DateTime timestamp, Database database) async {
    final int id = await database.insert(
      "symptom_log",
      {
        "user_id" : userId,
        "symptom_type" : log.symptomType.index,
        "symptom_severity" : log.symptomSeverity,
        "mood_type" : log.moodType.index,
        "trigger" : log.trigger,
        "response_taken" : log.responseTaken,
        "category_type" : log.categoryType.index,
        "notes" : log.notes,
        "timestamp_unix" : _getUnixTime(timestamp)
      },
    );

    return SymptomLog(id: id, userId: userId, log: log, timestamp: timestamp);
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
      log: Log (
        symptomType: SymptomType.values[map["symptom_type"] as int],
        symptomSeverity: map["symptom_severity"] as int,
        moodType: MoodType.values[map["mood_type"] as int],
        trigger: map["trigger"] as String,
        responseTaken: map["response_taken"] as String,
        categoryType: CategoryType.values[map["category_type"] as int],
        notes: map["notes"] as String
      ),
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
      userId == other.userId && 
      log == other.log &&
      timestamp == other.timestamp;
  }
  
  @override
  int get hashCode => Object.hash(id, userId, log, timestamp);
}