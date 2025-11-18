/// @Created on: 7/11/25
/// @Author: Finley Conway

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user_event.dart';

// https://pub.dev/packages/table_calendar

class MyCalendarPage extends StatefulWidget {
  final User currentUser;
  final Database database;

  const MyCalendarPage({super.key, required this.database, required this.currentUser});

  @override
  State<MyCalendarPage> createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  List<UserEvent> _events = [];
  List<UserEvent> _todayEvents = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    // since i cant call async future in initState, we have to wait before loading the ui
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

  Future<void> _loadEvents() async {
    final events = await widget.currentUser.getAllEvents(widget.database);
  
    final todayEvents = events
      .where((e) => e.event.occursOn(DateTime.now()))
      .toList();

    setState(() {
      _events = events;
      _todayEvents = todayEvents;
      _loading = false;
    });
  }

  List<Event> _populateDay(DateTime day) {
    List<Event> occurringSomeDayEvents = [];

    for (final userEvent in _events) {
      final Event event = userEvent.event;

      if (event.occursOn(day)) {
        occurringSomeDayEvents.add(event);
      }
    }

    return occurringSomeDayEvents;
  }
}