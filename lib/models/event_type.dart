/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class EventType {
  final int id;
  final String name;

  EventType({
    required this.id, 
    required this.name
  });

  static EventType fromMap(Map<String, Object?> map) {
    return EventType(
      id: map["id"] as int, 
      name: map["name"] as String, 
    );
  }

  // Create a new Event Type entity.
  static Future<int> create(String eventName, Database database) async {
    return await database.insert(
      "event_type",
      {
        "name" : eventName
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Get the Event Type entity by id.
  static Future<EventType?> getById(int eventId, Database database) async {
    final result = await database.query(
      "event_type",
      where: "id = ?",
      whereArgs: [eventId]
    );

    return result.isNotEmpty ? fromMap(result.first) : null;
  }

  // Get all Event Type entitles.
  static Future<List<EventType>> getAll(Database database) async {
    final result = await database.query("event_type");

    return result.map((row) => EventType.fromMap(row)).toList();
  }

  @override
  bool operator ==(covariant EventType other) {
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}