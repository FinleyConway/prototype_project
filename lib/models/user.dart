/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:prototype_project/models/symptom_log.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/models/user_event.dart';
import 'package:prototype_project/models/event.dart';

class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name
  });

  static User fromMap(Map<String, Object?> map) {
    return User(
      id: map["id"] as int, 
      name: map["name"] as String, 
    );
  }

  // Create a new User entity.
  static Future<User> create(String name, Database database) async {
    final int id = await database.insert(
      "user",
      {
        "name" : name
      },
    );

    return User(id: id, name: name);
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

  Future<List<UserEvent>> getAllEvents(Database database) {
    return UserEvent.getByUserId(id, database);
  }

  Future<List<UserEvent>> getAllEventsOn(DateTime date, Database database) {
    return UserEvent.getByUserId(id, database, date);
  }

  Future<UserEvent> assignEvent(int eventTypeId, Event event, Database database, [Map<String, dynamic>? eventDetails]) {
    return UserEvent.create(id, eventTypeId, event, database);
  }

  Future<List<SymptomLog>> getAllLoggedSymptoms(SymptomOrder order, SymptomSortBy sort, Database database) {
    return SymptomLog.getAll(id, order, sort, database);
  }

  Future<SymptomLog> assignSymptomLog(Symptom symptom, String notes, DateTime timestamp, Database database) {
    return SymptomLog.create(id, symptom, notes, timestamp, database);
  }

  @override
  bool operator ==(covariant User other) {
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}