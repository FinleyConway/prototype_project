import 'package:flutter/material.dart';
import 'package:prototype_project/models/carer.dart';

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/pages/calendar_page.dart';
import 'package:prototype_project/pages/health_log.dart';
import 'package:prototype_project/pages/reminder_page.dart';
import 'package:prototype_project/pages/profile_page.dart';
import 'package:prototype_project/pages/contact_page.dart';
import 'package:prototype_project/pages/resource_page.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class HomePage extends StatefulWidget  {
  final Carer loggedCarer;
  final User currentUser;
  final Database database;

  const HomePage({super.key, required this.database, required this.currentUser, required this.loggedCarer}); // temp user paramater

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;   // current nav index (home is center)

  // Handle  taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        // Navigate to Calendar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCalendarPage(database: widget.database, currentUser: widget.currentUser, loggedCarer: widget.loggedCarer)),
        );
        break;
      case 1:
        // Navigate to Health Log
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthLogPage(database: widget.database, currentUser: widget.currentUser, loggedCarer: widget.loggedCarer)),
        );
        break;
      case 2:
        // home page (current)
        break;
      case 3:
        // Navigate to Reminder
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyReminderPage(database: widget.database, currentUser: widget.currentUser, loggedCarer: widget.loggedCarer)),
        );
        break;
      case 4:
        // Navigate to Settings, TODO
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications, color: Color(0xFF2C2C2C)),
          onPressed: () {},
        ),
        title: const Text(
          'Carepanion',
          style: TextStyle(
            color: Color(0xFF81A894),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      database: widget.database,
                      currentUser: widget.currentUser,
                      loggedCarer: widget.loggedCarer
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.account_circle,
                color: Color(0xFF81A894),
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today at a glance',
                style: TextStyle(
                  color: Color(0xFF81A894),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DCC4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildTodayItem(
                      icon: Icons.description,
                      iconBgColor: const Color(0xFFB8D4C4),
                      text: '3:30 PM Appointment with\nDr. ABC at 123 Hospital',
                    ),
                    const SizedBox(height: 12),
                    _buildTodayItem(
                      icon: Icons.medication,
                      iconBgColor: const Color(0xFFD4E8D4),
                      text: '10AM 1 x 5ml Donepezil\nafter breakfast',
                    ),
                    const SizedBox(height: 12),
                    _buildTodayItem(
                      icon: Icons.access_time,
                      iconBgColor: const Color(0xFFB8D4C4),
                      text: '12PM Walk the dog',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                icon: Icons.people,
                iconBgColor: const Color(0xFF81A894),
                title: 'Helpful Resources',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => ResourcesPage(database: widget.database, currentUser: widget.currentUser, loggedCarer: widget.loggedCarer)),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSection(
                icon: Icons.warning,
                iconBgColor: const Color(0xFF81A894),
                title: 'Emergency Contacts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => MyContactPage(database: widget.database, currentUser: widget.currentUser)),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayItem({
    required IconData icon,
    required Color iconBgColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2C2C2C),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8DCC4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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