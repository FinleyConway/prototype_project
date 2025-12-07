import 'package:flutter/material.dart';
import 'package:prototype_project/models/carer.dart';
import 'package:prototype_project/models/user.dart';

import 'package:prototype_project/pages/calendar_page.dart';
import 'package:prototype_project/pages/health_log.dart';
import 'package:prototype_project/pages/reminder_page.dart';


import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class ResourcesPage extends StatefulWidget {
  final Carer loggedCarer;
  final User currentUser;
  final Database database;

  const ResourcesPage({super.key, required this.database, required this.currentUser, required this.loggedCarer});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  int _selectedIndex = 2;   // current nav index (default)

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
        // home page (default)
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

  // Resource list
  final List<Map<String, String>> resources = [
    {'name': 'Age UK', 'url': 'https://www.ageuk.org.uk'},
    {'name': 'Carer\'s Trust', 'url': 'https://www.carers.org'},
    {'name': 'Carers UK', 'url': 'https://www.carersuk.org'},
    {'name': 'NHS', 'url': 'https://www.nhs.uk'},
    {'name': 'Dementia UK', 'url': 'https://www.dementiauk.org'},
    {'name': 'Citizen Advice UK', 'url': 'https://www.citizensadvice.org.uk'},
    {'name': 'Alzheimer\'s Association', 'url': 'https://www.alz.org'},
    {'name': 'Alzheimer\'s Research UK', 'url': 'https://www.alzheimersresearchuk.org'},
    {'name': 'Alzheimer\'s Society', 'url': 'https://www.alzheimers.org.uk'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resources',
          style: TextStyle(
            color: Color(0xFF81A894),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildResourceItem(
              resources[index]['name']!,
              resources[index]['url']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildResourceItem(String name, String url) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF2C2C2C),
              size: 24,
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