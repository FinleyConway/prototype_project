import 'package:flutter/material.dart';

import 'package:prototype_project/models/event.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/user_event.dart';

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
          onPressed: () {}, // TODO: Go to create event page
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
      tabs: const <Widget> [ // this can expand on later if we decided to have custom events
        Tab(text: "Appointments"),
        Tab(text: "Medications"),
        Tab(text: "Routine")
      ],
    );
  }

  Widget _buildTab() {
    if (_loadingData) return const Center(child: CircularProgressIndicator());

    return ListView( // TODO: list all events from type

    );
  }

  Widget _createReminderCard() {
    return Container();
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

    _events = await widget.currentUser.getAllEventsOfType(type, widget.database);

    setState(() {
      _loadingData = false;
    });
  }
}
