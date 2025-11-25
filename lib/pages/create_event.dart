import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/event.dart';

class CreateEventPage extends StatefulWidget {
  final User currentUser;
  final Database database;

  const CreateEventPage({super.key, required this.database, required this.currentUser});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // Form values, can be changed
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _eventType = 'Appointment';
  String _repeatType = 'Never';
  String _shareWith = 'None';
  String _alertType = 'None';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Save event to DB, backend TODO
  // feel free to change the structure
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Combine date and time
      final eventDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      
      final Event createdEvent = Event(
        title: _titleController.text,
        location: _locationController.text,
        repeatType: _getRepeatTypeFromText(_repeatType),
        eventType: _getEventTypeFromText(_eventType),
        reminderTime: eventDateTime,
        notes: _notesController.text, 
        completed: false
        // TODO MAYBE: sharedWith:
        // TODO MAYBE: alertType:
      );

      widget.currentUser.assignEvent(createdEvent, widget.database);

      // Create Event object and save to DB
      // For now, just show success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7FA99B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create an Event',
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
              // Date and Time Section
              const Text(
                'Date and Time:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Date picker
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          DateFormat('MMM d, yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Time picker
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Type of Event
              _buildLabel('Type of Event'),
              _buildDropdown(
                value: _eventType,
                items: ['Appointment', 'Medication', 'Other'], // just a guess for now, change to match design plans
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Title
              _buildLabel('Title'),
              _buildTextField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Location
              _buildLabel('Location'),
              _buildTextField(
                controller: _locationController,
              ),
              const SizedBox(height: 20),

              // Repeat
              _buildLabel('Repeat'),
              _buildDropdown(
                value: _repeatType,
                items: ['Never', 'Daily', 'Weekly', 'Monthly', 'Yearly'], // just a guess for now, change to match design plans
                onChanged: (value) {
                  setState(() {
                    _repeatType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Share with
              _buildLabel('Share with'),
              _buildDropdown(
                value: _shareWith,
                items: ['None', 'All Caregivers', 'Specific Caregiver'], // just a guess for now, change to match design plans
                onChanged: (value) {
                  setState(() {
                    _shareWith = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Alert
              _buildLabel('Alert'),
              _buildDropdown(
                value: _alertType,
                items: ['None', '5 minutes before', '15 minutes before', '1 hour before', '1 day before'], // just a guess for now, change to match design
                onChanged: (value) {
                  setState(() {
                    _alertType = value!;
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
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7FA99B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Event',
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

  EventRepeatType _getRepeatTypeFromText(String text) {
    switch (text) {
      case "Daily":
        return EventRepeatType.daily;
      case "Weekly":
        return EventRepeatType.weekly;
      case "Monthly":
        return EventRepeatType.monthly;
      case "Yearly":
        return EventRepeatType.yearly;
      case "":
      case "Never":
        return EventRepeatType.never;
      default:
        throw ArgumentError("Unknown repeat type: $text");
    }
  }

  EventType _getEventTypeFromText(String text) {
    switch (text) {
      case "Appointment":
        return EventType.appointments;
      case "Medication":
        return EventType.medications;
      case "Routine":
        return EventType.routine;
      default:
        throw ArgumentError("Unknown event type: $text");
    }
  }
}