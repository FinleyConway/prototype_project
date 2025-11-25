import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/user_event.dart';
import 'package:prototype_project/pages/create_event.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class MyReminderPage extends StatefulWidget {
  final User currentUser;
  final Database database;

  const MyReminderPage({
    super.key,
    required this.database,
    required this.currentUser,
  });

  @override
  State<MyReminderPage> createState() => _MyReminderPageState();
}

class _MyReminderPageState extends State<MyReminderPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  List<UserEvent> _events = [];
  bool _loadingData =  true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      
      _loadTabData(_tabController.index);
    });

    _loadTabData(0); // set a default state
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _createAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: <Widget> [
          _buildTab(), // appointment tab
          _buildTab(), // medication tab
          _buildTab(), // rountine tab
        ],
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        "Reminders",
        style: TextStyle(
          color: Color(0xFF7FA99B),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: Color(0xFF7BAE9F)),
          onPressed: _naviageteToCreateEvent,
        ),
      ],
      bottom: _createTabBar()
    );
  }

  TabBar _createTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Color(0xFF7FA99B),
      unselectedLabelColor: Colors.black87,
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      indicatorColor: Color(0xFF7FA99B),
      indicatorWeight: 2,
      tabs: const <Widget> [ // this could expand on later if we decided to have custom events
        Tab(text: "Appointments"),
        Tab(text: "Medications"),
        Tab(text: "Routine")
      ],
    );
  }

  Widget _buildTab() {
    if (_loadingData) return const Center(child: CircularProgressIndicator());
    if (_events.isEmpty) return const Center(child: Text("No reminders"));

    // display every event
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final UserEvent userEvent in _events) ...[
          _createReminderCard(
            userEvent.id,
            userEvent.event.title, 
            userEvent.event.reminderTime, 
            userEvent.event.location,
            userEvent.event.notes, 
            userEvent.event.completed,
            _toggleCompleteReminder
          ),
          const SizedBox(height: 16),
        ]
      ]
    );
  }

  Widget _createReminderCard(int id, String title, DateTime dateTime, String location, String note, bool completed, void Function(int id) onToggleCompleted) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // complete check box
          InkWell(
            onTap: () => onToggleCompleted(id),
            child: Icon(
              completed ? Icons.check_box : Icons.check_box_outline_blank,
              color: completed ? const Color(0xFF7BAE9F) : Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          // the set date
          Text(
            DateFormat('EEEE, d MMMM').format(dateTime),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4), 
          // the set time
          Text(
            DateFormat('HH:mm').format(dateTime),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          // the event location
          Text(
            location,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          // the optional note
          Text(
            note,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTabData(int tabIndex) async {
    setState(() {
      _loadingData = true;
    });

    EventType type;

    switch (tabIndex) {
      case 0: type = EventType.appointments; break;
      case 1: type = EventType.medications; break;
      case 2: type = EventType.routine; break;
      default: type = EventType.appointments;
    }

    // fetch backend data
    _events = await widget.currentUser.getAllEventsOfType(type, widget.database);

    // update ui when fetched
    setState(() {
      _loadingData = false;
    });
  }

  void _toggleCompleteReminder(int eventId) {
    final int index = _events.indexWhere((e) => e.id == eventId);

    if (index == -1) return;

    final Event changedEvent = _events[index].event; 
    changedEvent.completed = !changedEvent.completed;

    // update backend
    widget.currentUser.updateEvent(eventId, changedEvent, widget.database);

    // update user interface
    setState(() {
      _events[index].event.completed = changedEvent.completed;
    });
  }

  void _naviageteToCreateEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventPage(database: widget.database, currentUser: widget.currentUser)),
    ).then((_) {
      _loadTabData(0);
    });
  }
}
