/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/models/event_type.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user_event.dart';
import 'package:prototype_project/context/carer_db.dart';

Future<void> testCreatingEventType() async {
  final Database db = await CarerDb.create();
  
  final int eventTypeId = await EventType.create("Appointment", db);
  final EventType? eventType = await EventType.getById(eventTypeId, db);

  expect(eventType, EventType(id: 1, name: "Appointment"));

  await db.close();
}

Future<void> testCreatingUserEvent() async {
  final Database db = await CarerDb.create();

  final User user = await User.create("Finley", db);
  final int eventTypeId = await EventType.create("Appointment", db);
  final Event event = Event(
    title: "Wake up", 
    message: "Blah blah blah", 
    isAllDay: false, 
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0)
  );

  final UserEvent createdUserEvent = await user.assignEvent(eventTypeId, event, db);
  final List<UserEvent?> protentialEvent = await user.getAllEvents(db);

  expect(protentialEvent.length, 1);
  expect(protentialEvent.first, createdUserEvent);

  await db.close();
}

Future<void> testCreatingUserEventWithData() async {
  final Database db = await CarerDb.create();

  final User user = await User.create("Finley", db);
  final int eventTypeId = await EventType.create("Appointment", db);
  final Event event = Event(
    title: "Wake up", 
    message: "Blah blah blah", 
    isAllDay: false, 
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0)
  );

  // create an user event and search for it by user id
  final UserEvent createdUserEvent = await user.assignEvent(eventTypeId, event, db, {
    "Medication" : "Healing Stimpak",
    "Dosage" : "200ml",
    "HasBeenTaken" : true
  });
  final List<UserEvent?> protentialEvent = await user.getAllEvents(db);

  expect(protentialEvent.length, 1);
  expect(protentialEvent.first, createdUserEvent);

  await db.close();
}

void main() {
  test("Creating Event Type", testCreatingEventType);
  test("Creating User Event", testCreatingUserEvent);
  test("Creating User Event With Data", testCreatingUserEventWithData);
}