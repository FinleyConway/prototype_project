/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/models/event_type.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user_event.dart';

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

Future<Database> createDatabase() async {
  Database db = await openDatabase(inMemoryDatabasePath); // creates a database within memory

  await db.execute("""
    CREATE TABLE carer(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      password TEXT
    );

    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    );

    CREATE TABLE carer_to_user (
      carer_id INTEGER,
      user_id INTEGER,
      PRIMARY KEY (carer_id, user_id),
      FOREIGN KEY (carer_id) REFERENCES carer(id),
      FOREIGN KEY (user_id) REFERENCES user(id)
    );

    CREATE TABLE event_type (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    );

    CREATE TABLE user_event (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      event_type_id INTEGER,
      title TEXT,
      message TEXT,
      is_all_day INT,
      repeat_type INT,
      reminder_time_unix INT,
      event_detail_json TEXT,
      FOREIGN KEY (user_id) REFERENCES user(id)
      FOREIGN KEY (event_type_id) REFERENCES event_type(id)
    );
  """);

  return db;
}

Future<void> testCreatingEventType() async {
  final Database db = await createDatabase();

  final int eventTypeId = await EventType.create("Appointment", db);
  final EventType? eventType = await EventType.getById(eventTypeId, db);

  expect(eventType, EventType(id: 1, name: "Appointment"));

  await db.close();
}

Future<void> testCreatingUserEvent() async {
  final Database db = await createDatabase();

  final int userId = await User.create("Finley", db);
  final int eventTypeId = await EventType.create("Appointment", db);

  final Event event = Event(
    title: "Wake up", 
    message: "Blah blah blah", 
    isAllDay: false, 
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0)
  );

  await UserEvent.create(userId, eventTypeId, event, db);
  final List<UserEvent?> protentialEvent = await UserEvent.getByUserId(userId, db);

  expect(protentialEvent.length, 1);
  expect(protentialEvent.first, UserEvent(
    id: 1, 
    userId: userId, 
    eventTypeId: eventTypeId, 
    event: event,
    eventDetails: null
  ));

  await db.close();
}

Future<void> testCreatingUserEventWithData() async {
  final Database db = await createDatabase();

  // create a temp user and a event type
  final int userId = await User.create("Finley", db);
  final int eventTypeId = await EventType.create("Appointment", db);

  final Event event = Event(
    title: "Wake up", 
    message: "Blah blah blah", 
    isAllDay: false, 
    repeatType: EventRepeatType.daily, 
    reminderTime: DateTime(2025, 4, 7, 0)
  );

  // create an user event and search for it by user id
  await UserEvent.create(userId, eventTypeId, event, db, {
    "Medication" : "Healing Stimpak",
    "Dosage" : "200ml",
    "HasBeenTaken" : true
  });
  final List<UserEvent?> protentialEvent = await UserEvent.getByUserId(userId, db);

  // check if it actually matches
  expect(protentialEvent.length, 1);
  expect(protentialEvent.first, UserEvent(
    id: 1, 
    userId: userId, 
    eventTypeId: eventTypeId, 
    event: event,
    eventDetails: {
      "Medication" : "Healing Stimpak",
      "Dosage" : "200ml",
      "HasBeenTaken" : true
    }
  ));

  await db.close();
}

void main() {
  sqfliteTestInit();

  test("Creating Event Type", testCreatingEventType);
  test("Creating User Event", testCreatingUserEvent);
  test("Creating User Event With Data", testCreatingUserEventWithData);
}