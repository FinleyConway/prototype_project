/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user_event.dart';
import 'package:prototype_project/context/carer_db.dart';

Future<void> testCreatingUserEvent() async {
  final Database db = await CarerDb.create();

  final User user = await User.create("Finley", db);

  final Event event = Event(
    title: "Wake up", 
    location: "Here",
    eventType: EventType.appointments,
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0),
    notes: "Blah blah blah",
    completed: false
  );

  final UserEvent createdUserEvent = await user.assignEvent(event, db);
  final List<UserEvent?> protentialEvent = await user.getAllEvents(db);

  expect(protentialEvent.length, 1);
  expect(protentialEvent.first, createdUserEvent);

  await db.close();
}

Future<void> testCreatingUserEventWithData() async {
  final Database db = await CarerDb.create();

  final User user = await User.create("Finley", db);

  final Event event = Event(
    title: "Wake up", 
    location: "Here",
    eventType: EventType.appointments,
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0),
    notes: "Blah blah blah",
    completed: false
  );

  // create an user event and search for it by user id
  final UserEvent createdUserEvent = await user.assignEvent(event, db, {
    "Medication" : "Healing Stimpak",
    "Dosage" : "200ml",
    "HasBeenTaken" : true
  });
  final List<UserEvent?> protentialEvent = await user.getAllEvents(db);

  expect(protentialEvent.length, 1);
  expect(protentialEvent.first, createdUserEvent);

  await db.close();
}

Future<void> testUpdatingUserEvent() async {
  final Database db = await CarerDb.create();

  final User user = await User.create("Finley", db);

  final Event event = Event(
    title: "Wake up", 
    location: "Here",
    eventType: EventType.appointments,
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0),
    notes: "Blah blah blah",
    completed: false
  );

  final UserEvent createdUserEvent = await user.assignEvent(event, db);

  final Event updatedEvent = Event(
    title: "Wake up NOW", 
    location: "Here!!!",
    eventType: EventType.medications,
    repeatType: EventRepeatType.weekly, 
    reminderTime: DateTime(2025, 4, 7, 0),
    notes: "No talking!",
    completed: true
  );

  await user.updateEvent(createdUserEvent.id, updatedEvent, db);

  final List<UserEvent?> protentialEvent = await user.getAllEvents(db);

  expect(protentialEvent.first?.event, updatedEvent);

  await db.close();
}

void main() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;

  test("Creating User Event", testCreatingUserEvent);
  test("Creating User Event With Data", testCreatingUserEventWithData);
  test("Updating User Event", testUpdatingUserEvent);
}