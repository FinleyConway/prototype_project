import 'package:flutter/material.dart';
import 'package:prototype_project/models/carer.dart';

import 'package:prototype_project/models/user.dart';

import 'package:prototype_project/pages/calendar_page.dart';
import 'package:prototype_project/pages/health_log.dart';
import 'package:prototype_project/pages/reminder_page.dart';
import 'package:prototype_project/utils/auth.dart';


import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite


class ProfilePage extends StatefulWidget {
  final Carer loggedCarer;
  final User currentUser;
  final Database database;

  const ProfilePage({super.key, required this.database, required this.currentUser, required this.loggedCarer});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isPasswordVisible = false;
  int _selectedIndex = 4; // homepage for defualt

  // Handle navbar taps
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
      // Navigate Home
      Navigator.pop(context);
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

  
  // sample profile data - import from DB, probably will need an appropriate method for securely handling sensitive info
  final String _phoneNumber = '+44 7604304326';
  final String _address = '14 Church Street, Newcastle, KN4 6BP';
  final List<String> _careRecipients = ['Mark', 'Susie', 'Alice'];
  final String _emergencyContact = '+44 4869472354';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to edit profile page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile Avatar and Name
              _buildProfileHeader(),
              const SizedBox(height: 32),
              
              // Information Cards
              _buildInfoCard(
                icon: Icons.phone,
                label: 'Phone Number',
                value: _phoneNumber,
                iconColor: const Color(0xFF4CAF50),
              ),
              _buildInfoCard(
                icon: Icons.email,
                label: 'Email',
                value: widget.loggedCarer.email,
              ),
              _buildInfoCard(
                icon: Icons.home,
                label: 'Address',
                value: _address,
                iconColor: const Color(0xFF4CAF50),
              ),
              _buildInfoCard(
                icon: Icons.people,
                label: 'Care Recipients',
                value: _careRecipients.join(', '),
                iconColor: const Color(0xFF4CAF50),
              ),
              _buildInfoCard(
                icon: Icons.warning_amber_rounded,
                label: 'Emergency Contact',
                value: _emergencyContact,
                iconColor: const Color(0xFF4CAF50),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF4CAF50),
              width: 4,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.loggedCarer.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D2D2D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Carepanion",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: iconColor ?? Colors.grey[700],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ],
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