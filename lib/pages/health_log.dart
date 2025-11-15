import 'package:flutter/material.dart';
import 'home_page.dart';

class HealthLogPage extends StatefulWidget {
  const HealthLogPage({super.key});
  
  @override
  State<HealthLogPage> createState() => _HealthLogPageState();
}

class _HealthLogPageState extends State<HealthLogPage> {
  int _selectedIndex = 1;   // current nav index (health log)

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
        // health log page (current)
        break;
      case 2:
        // Navigate back to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D3E3F),
        title: const Text(
          'Health Log',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Health Log',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B9B9E),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // navigate to create a note, TODO
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Entry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B9B9E),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: 0, // change with total saved notes / number of notes per page, something like that
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('Entry Title'), // change to whatever, maybe note date? combination of date+mood+symptom? whatever works
                      subtitle: Text('Entry preview...'), // change to whatever
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // navigate to a full note view, TODO
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
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