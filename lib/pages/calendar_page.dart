/// @Created on: 7/11/25
/// @Author: Finley Conway

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:sqflite/sqflite.dart'
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/context/carer_db.dart';
import 'package:prototype_project/models/user_event.dart';

// https://pub.dev/packages/table_calendar

class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key});

 @override
  State<MyCalendarPage> createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();

    _onUserEventFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
      ),
      body: TableCalendar<Event>(
        focusedDay: DateTime.now(),
        firstDay: DateTime(1970),
        lastDay: DateTime(3000),
        eventLoader: _populateDay,
      )
    );
  }

  Future<void> _onUserEventFetch() async {
    // temp database setup
    Database database = await CarerDb.create();
    final User user = await User.create("Bob", database);

    await UserEvent.create(user.id, 1, Event(
      title: "Test",
      message: "A Message",
      isAllDay: false,
      repeatType: EventRepeatType.weekly,
      reminderTime: DateTime(2025, 11, 7)
    ), database);

    //  -- end of temp

    // get all events for user and arranged them into a map
    final List<UserEvent> events = await UserEvent.getByUserId(user.id, database);
    Map<DateTime, List<Event>> fetchedEvents = {};

    for (final UserEvent userEvent in events) {
      final DateTime reminder = userEvent.event.reminderTime;

      fetchedEvents.putIfAbsent(_getAbsoluteDate(reminder), () => []).add(userEvent.event);
    }

    // update ui
    setState(() {
      _events = fetchedEvents;
    });
  }

  List<Event> _populateDay(DateTime day) {
    List<Event> occurringSomeDayEvents = [];

    // checks all events in the map
    for (final eventList in _events.values) {
      for (final event in eventList) {
        if (event.occursOn(day)) {
          occurringSomeDayEvents.add(event);
        }
      }
    }

    return occurringSomeDayEvents;
  }

  DateTime _getAbsoluteDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}