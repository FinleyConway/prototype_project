/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:prototype_project/models/event.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UserEvent {
  final int id;
  final int userId;
  final int eventTypeId;
  final Event event;
  final Map<String, dynamic>? eventDetails;

  UserEvent({
    required this.id, 
    required this.userId, 
    required this.eventTypeId, 
    required this.event,
    required this.eventDetails
  });

  static UserEvent fromMap(Map<String, Object?> map) {
    return UserEvent(
      id: map["id"] as int, 
      userId: map["user_id"] as int,
      eventTypeId: map["event_type_id"] as int,
      event: Event(
        title: map["title"] as String,
        message: map["message"] as String,
        isAllDay: (map["is_all_day"] as int) == 1, // convert int back into a bool
        repeatType: EventRepeatType.values[map["repeat_type"] as int],
        reminderTime: _getDateFromUnix(map["reminder_time_unix"] as int)
      ),
      eventDetails: _parseJson(map["event_detail_json"]),
    );
  }

  // Create a User Event entity.
  static Future<int> create(int userId, int eventTypeId, Event event, Database database, [Map<String, dynamic>? eventDetails]) async {
    return await database.insert(
      "user_event",
      {
        "user_id" : userId,
        "title" : event.title,
        "message" : event.message,
        "is_all_day" : event.isAllDay ? 1 : 0, // sqlite doesnt have bool
        "event_type_id" : eventTypeId,
        "repeat_type" : event.repeatType.index,
        "reminder_time_unix" : _getUnixTime(event.reminderTime),
        "event_detail_json" : eventDetails != null ? jsonEncode(eventDetails) : null
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  // Get the User Event entity from user id.
  static Future<List<UserEvent>> getByUserId(int userId, Database database) async {
    final result = await database.query(
      "user_event",
      where: "user_id = ?",
      whereArgs: [userId]
    );

    return result.map((row) => UserEvent.fromMap(row)).toList();
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

  @override
  bool operator ==(covariant UserEvent other) {
    return 
      id == other.id && 
      userId == other.userId &&
      eventTypeId == other.eventTypeId &&
      event == other.event &&
      mapEquals(eventDetails, other.eventDetails);
  }

  @override
  int get hashCode => Object.hash(
    id, 
    userId,
    eventTypeId,
    event,
    eventDetails == null ? null : Object.hashAllUnordered(eventDetails!.entries),
  );
}