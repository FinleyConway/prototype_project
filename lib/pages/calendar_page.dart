import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user_event.dart';
import 'package:prototype_project/pages/create_event.dart';
import 'package:prototype_project/pages/health_log.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class MyCalendarPage extends StatefulWidget {
  final User currentUser;
  final Database database;

  const MyCalendarPage({super.key, required this.database, required this.currentUser});

  @override
  State<MyCalendarPage> createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  List<UserEvent> _events = [];
  bool _loading = true;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  int _selectedIndex = 0; // current nav index (calendar)

  @override
  void initState() {
    super.initState();
    
    _loadEvents();
  }

  // Handle navbar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Calendar 
        break;
      case 1:
        // Navigate to Health Log
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthLogPage(database: widget.database, currentUser: widget.currentUser)),
        );
        break;
      case 2:
        // Navigate Home
        Navigator.pop(context);
        break;
      case 3:
        // Navigate to Social, TODO
        break;
      case 4:
        // Navigate to Settings, TODO
        break;
    }
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hide back button
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Color(0xFF7FA99B),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Date header with buttons
          _buildDateHeader(),

          // Calendar widget
          _buildCalendar(),

          // Events list for selected day
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFD4E5DF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEE, MMM d').format(_selectedDay),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black87),
                onPressed: _navigateToCreateEvent,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.black87),
                onPressed: () {
                  // Navigate to edit mode, TODO
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E5DF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar<Event>(
        firstDay: DateTime(1970),
        lastDay: DateTime(3000),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        eventLoader: _populateDay,

        // Calendar styling
        calendarStyle: CalendarStyle(
          // Today's date styling
          todayDecoration: BoxDecoration(
            color: const Color(0xFF7FA99B).withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),

          // Selected date styling
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF7FA99B),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          // Default day styling
          defaultTextStyle: const TextStyle(
            color: Colors.black87,
          ),

          // Weekend styling (faded)
          weekendTextStyle: const TextStyle(
            color: Colors.black54,
          ),

          // Days from a different month (very faded)
          outsideTextStyle: const TextStyle(
            color: Colors.black26,
          ),

          // Event marker styling
          markerDecoration: const BoxDecoration(
            color: Color(0xFF5A8A7A),
            shape: BoxShape.circle,
          ),
          markerSize: 6,
          markerMargin: const EdgeInsets.symmetric(horizontal: 1),
        ),

        // Header styling
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: Colors.black87,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.black87,
          ),
        ),

        // Styling for the calendar header: Sun, Mon, Tue... ect
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Event callbacks
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },

        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Future<void> _loadEvents() async {
    final events = await widget.currentUser.getAllEvents(widget.database);

    setState(() {
      _events = events;
      _loading = false;
    });
  }
  
  Widget _buildEventsList() {
    final eventsForDay = _populateDay(_selectedDay);

    if (eventsForDay.isEmpty) {
      return Center(
        child: Text(
          'No events for this day',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: eventsForDay.length,
      itemBuilder: (context, index) {
        final event = eventsForDay[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Event event) {
    // Determine card colour based on event type
    Color cardColour = Colors.white;
    IconData iconData = Icons.event;

    // events + colours
    if (event.title.toLowerCase().contains('medication')) {
      cardColour = const Color(0xFFE8F5E9);
      iconData = Icons.medication;
    } else if (event.title.toLowerCase().contains('appointment')) {
      cardColour = const Color(0xFFE3F2FD);
      iconData = Icons.local_hospital;
    } else if (event.title.toLowerCase().contains('note')) {
      cardColour = const Color(0xFFF3E5F5);
      iconData = Icons.note;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColour,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7FA99B).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                iconData,
                color: const Color(0xFF7FA99B),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time
                  Text(
                    event.isAllDay
                        ? 'All Day'
                        : DateFormat('h:mm a').format(event.reminderTime),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  // Message
                  if (event.message.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],

                  // Repeat indicator
                  if (event.repeatType != EventRepeatType.never) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getRepeatTypeText(event.repeatType),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Action button
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // TODO: Show event options (edit, delete)
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getRepeatTypeText(EventRepeatType type) {
    switch (type) {
      case EventRepeatType.daily:
        return 'Daily';
      case EventRepeatType.weekly:
        return 'Weekly';
      case EventRepeatType.monthly:
        return 'Monthly';
      case EventRepeatType.yearly:
        return 'Yearly';
      case EventRepeatType.never:
        return '';
    }
  }

  void _navigateToCreateEvent() {
    // Navigate to create event page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventPage()),
    );
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

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal[700],
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
        const BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/notextLogo.png',
            height: 28,
            color: _selectedIndex == 2 ? Colors.teal[700] : Colors.grey,
          ),
          label: '',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
        const BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
      ],
    );
  }
}