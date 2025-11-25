/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

import 'package:prototype_project/models/event.dart';

class UserEvent {
  final int id;
  final int userId;
  final Event event;
  final Map<String, dynamic>? eventDetails;

  UserEvent({
    required this.id, 
    required this.userId, 
    required this.event,
    required this.eventDetails
  });

  // Create a User Event entity.
  static Future<UserEvent> create(int userId, Event event, Database database, [Map<String, dynamic>? eventDetails]) async {
    final int id = await database.insert(
      "user_event",
      {
        "user_id" : userId,
        "title" : event.title,
        "location" : event.location,
        "event_type" : event.eventType.index,
        "repeat_type" : event.repeatType.index,
        "reminder_time_unix" : _getUnixTime(event.reminderTime),
        "notes" : event.notes,
        "completed" : event.completed ? 1 : 0,
        "event_detail_json" : eventDetails != null ? jsonEncode(eventDetails) : null
      },
    );

    return UserEvent(id: id, userId: userId, event: event, eventDetails: eventDetails);
  }

  static Future<UserEvent> update(int id, int userId, Event event, Database database, [Map<String, dynamic>? eventDetails]) async {
    await database.update(
      "user_event",
      {
        "user_id" : userId,
        "title" : event.title,
        "location" : event.location,
        "event_type" : event.eventType.index,
        "repeat_type" : event.repeatType.index,
        "reminder_time_unix" : _getUnixTime(event.reminderTime),
        "notes" : event.notes,
        "completed" : event.completed ? 1 : 0,
        "event_detail_json" : eventDetails != null ? jsonEncode(eventDetails) : null
      },
      where: "id = ?",
      whereArgs: [id]
    );

    return UserEvent(id: id, userId: userId, event: event, eventDetails: eventDetails);
  } 

  // Get the User Event entity from user id.
  static Future<List<UserEvent>> getByUserId(int userId, Database database, {DateTime? date, EventType? reminderType}) async {
    String where = "user_id = ?";
    List<dynamic> whereArgs = [userId];

    if (date != null) {
      where += " AND reminder_time_unix = ?";
      whereArgs.add(_getUnixTime(date));
    }

    if (reminderType != null) {
      where += " AND event_type = ?";
      whereArgs.add(reminderType.index);
    }

    final result = await database.query(
      "user_event",
      where: where,
      whereArgs: whereArgs
    );

    return result.map((row) => UserEvent._fromMap(row)).toList();
  }

  static int _getUnixTime(DateTime time) {
    return time.toUtc().millisecondsSinceEpoch;
  }

  static DateTime _getDateFromUnix(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();
  }

  static Map<String, dynamic>? _parseJson(Object? jsonObject) {
    return jsonObject != null ? jsonDecode(jsonObject as String) as Map<String, dynamic> : null;
  }

  static UserEvent _fromMap(Map<String, Object?> map) {
    return UserEvent(
      id: map["id"] as int, 
      userId: map["user_id"] as int,
      event: Event(
        title: map["title"] as String,
        location: map["location"] as String,
        eventType: EventType.values[map["event_type"] as int],
        repeatType: EventRepeatType.values[map["repeat_type"] as int],
        reminderTime: _getDateFromUnix(map["reminder_time_unix"] as int),
        notes: map["notes"] as String,
        completed: (map["completed"] as int) == 1,
      ),
      eventDetails: _parseJson(map["event_detail_json"]),
    );
  }

  @override
  bool operator ==(covariant UserEvent other) {
    return 
      id == other.id && 
      userId == other.userId &&
      event == other.event &&
      mapEquals(eventDetails, other.eventDetails);
  }

  @override
  int get hashCode => Object.hash(
    id, 
    userId,
    event,
    eventDetails == null ? null : Object.hashAllUnordered(eventDetails!.entries),
  );
}