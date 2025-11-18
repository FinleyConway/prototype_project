import 'package:flutter/material.dart';
import 'health_log.dart';

class HomePage extends StatefulWidget  {
  const HomePage({super.key});

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
        // Navigate to Calendar, TODO
        break;
      case 1:
        // Navigate to Health Log
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthLogPage()),
        );
        break;
      case 2:
        // home page (current)
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: const Text(
          'Carepanion',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.teal[700], size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCardsSection(),
            const SizedBox(height: 20),
            _buildGridTilesSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildInfoCardsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.access_time,
            title: 'Next Appointment',
            color: Colors.blue[100]!,
            iconColor: Colors.blue[700]!,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.error_outline,
            title: 'Medication Reminder',
            color: Colors.green[100]!,
            iconColor: Colors.green[700]!,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.notes,
            title: 'Latest Notes',
            color: Colors.purple[100]!,
            iconColor: Colors.purple[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTilesSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildGridTile(Icons.calendar_today, Colors.teal[400]!),
        _buildGridTile(Icons.check, Colors.teal[700]!),
        _buildGridTile(Icons.access_time, Colors.teal[400]!),
        _buildGridTile(Icons.warning, Colors.teal[700]!),
      ],
    );
  }

  Widget _buildGridTile(IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: 48),
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