import 'package:flutter/material.dart';
import 'package:prototype_project/models/carer.dart';
import 'package:prototype_project/models/user.dart';

import 'package:prototype_project/pages/calendar_page.dart';
import 'package:prototype_project/pages/home_page.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class CreateHealthLogPage extends StatefulWidget {
  final Carer loggedCarer;
  final User currentUser;
  final Database database;

  const CreateHealthLogPage({super.key, required this.currentUser, required this.database, required this.loggedCarer});

  @override
  State<CreateHealthLogPage> createState() => _CreateHealthLogPageState();
}

class _CreateHealthLogPageState extends State<CreateHealthLogPage> {
  final _formKey = GlobalKey<FormState>();

  int _selectedIndex = 1;   // current nav index (health log)
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
        // health log page (current)
        break;
      case 2:
        // Navigate back to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(database: widget.database, currentUser: widget.currentUser, loggedCarer: widget.loggedCarer)),
        );
      case 3:
        // Navigate to Social, TODO
        break;
      case 4:
        // Navigate to Settings, TODO
        break;
    }
  }

  // Form field controllers
  final TextEditingController _triggerController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Form values, can be changed
  String _selectedSymptom = 'Select symptom';
  double _symptomSeverity = 0.5;
  String _selectedMood = 'Select mood';
  double _moodStrength = 0.5;
  String _selectedCategory = 'Select category';

  // Dropdown options
  final List<String> _symptoms = [
    'Select symptom',
    'Delusions',
    'Hallucinations',
    'Agitation/Aggression',
    'Depression/Dysphoria',
    'Anxiety',
    'Elation/Euphoria',
    'Apathy/Indifference',
    'Disinhibition',
    'Irritability/Lability',
    'Aberrant Motor Behaviours',
    'Sleep and Nighttime Behaviours',
    'Appetite and Eating Disorders',
  ];

  final List<String> _moods = [
    'Select mood',
    'Happy',
    'Calm',
    'Anxious',
    'Sad',
    'Frustrated',
    'Confused',
    'Fearful',
    'Irritable',
  ];

  final List<String> _categories = [
    'Select category',
    'Cognitive',
    'Behavioural',
    'Physical',
    'Emotional',
    'Sleep',
    'Nutrition',
    'Social',
  ];

  @override
  void dispose() {
    _triggerController.dispose();
    _responseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Save log to DB, backend TODO
  // feel free to change the structure
  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      // TODO: Create HealthLog object and save to DB
      // For now, just show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log entry created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7FA99B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create a Log',
          style: TextStyle(
            color: Color(0xFF7FA99B),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Symptom dropdown
              _buildLabel('Symptom'),
              _buildDropdown(
                value: _selectedSymptom,
                items: _symptoms,
                onChanged: (value) {
                  setState(() {
                    _selectedSymptom = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Symptom Severity slider
              _buildLabel('Symptom Severity'),
              _buildSlider(
                value: _symptomSeverity,
                onChanged: (value) {
                  setState(() {
                    _symptomSeverity = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Mood dropdown
              _buildLabel('Mood'),
              _buildDropdown(
                value: _selectedMood,
                items: _moods,
                onChanged: (value) {
                  setState(() {
                    _selectedMood = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Mood Strength slider
              _buildLabel('Mood Strength'),
              _buildSlider(
                value: _moodStrength,
                onChanged: (value) {
                  setState(() {
                    _moodStrength = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Trigger / Cause
              _buildLabel('Trigger / Cause'),
              _buildTextField(
                controller: _triggerController,
              ),
              const SizedBox(height: 20),

              // Response taken
              _buildLabel('Response taken'),
              _buildTextField(
                controller: _responseController,
              ),
              const SizedBox(height: 20),

              // Category Tag
              _buildLabel('Category Tag'),
              _buildDropdown(
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Notes
              _buildLabel('Notes (optional)'),
              _buildTextField(
                controller: _notesController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7FA99B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Entry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required void Function(double) onChanged,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: const Color(0xFF81A894),
        inactiveTrackColor: const Color(0xFFD5E5DC),
        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        trackHeight: 8,
      ),
      child: Slider(
        value: value,
        min: 0,
        max: 1,
        onChanged: onChanged,
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