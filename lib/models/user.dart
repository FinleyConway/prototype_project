/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

import 'package:prototype_project/models/user_event.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/symptom_log.dart';
import 'package:prototype_project/models/contact.dart';

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
    return UserEvent.getByUserId(id, database, date: date);
  }

  Future<List<UserEvent>> getAllEventsOfType(EventType eventType, Database database) {
    return UserEvent.getByUserId(id, database, reminderType: eventType);
  }

  Future<UserEvent> assignEvent(Event event, Database database, [Map<String, dynamic>? eventDetails]) {
    return UserEvent.create(id, event, database);
  }

  Future<UserEvent> updateEvent(int eventId, Event event, Database database) {
    return UserEvent.update(eventId, id, event, database);
  }

  Future<List<SymptomLog>> getAllLoggedSymptoms(SymptomOrder order, SymptomSortBy sort, Database database) {
    return SymptomLog.getAll(id, order, sort, database);
  }

  Future<SymptomLog> assignSymptomLog(Log log, DateTime timestamp, Database database) {
    return SymptomLog.create(id, log, timestamp, database);
  }

  Future<Contact> assignContact(String name, String relation, String phoneNumber, String secondaryPhoneNumber, String notes, Database database) {
    return Contact.create(id, name, relation, phoneNumber, secondaryPhoneNumber, notes, database);
  }

  Future<List<Contact>> getAllContacts(Database database) {
    return Contact.getAllByUserId(id, database);
  }

  @override
  bool operator ==(covariant User other) {
    return id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}