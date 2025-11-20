import 'package:flutter/material.dart';

class MyCreateContactPage extends StatefulWidget {
  const MyCreateContactPage({super.key});

  @override
  State<MyCreateContactPage> createState() => _MyCreateContactPageState();
}

class _MyCreateContactPageState extends State<MyCreateContactPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _secondaryPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _createAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _createTextBox("Name", "e,g John Doe", _nameController, "Please enter a name", false),
              const SizedBox(height: 20),
              _createTextBox("Relation", "e,g Parent", _relationController, "Please enter a relation", false),
              const SizedBox(height: 20),
              _createTextBox("Phone Number", "+44", _phoneController, "Please enter a phone number", false),
              const SizedBox(height: 20),
              _createTextBox("Secondary Phone Number (Optional)", "+44", _secondaryPhoneController, "", true),
              const SizedBox(height: 20),
              _createParagraphBox("Notes (Optional)", "+44", _notesController),
              const SizedBox(height: 20),
              _createNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // Hide back button
      title: const Text(
        "Add Contact",
        style: TextStyle(
          color: Color(0xFF7FA99B),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _createTextBox(
    String name,
    String hint,
    TextEditingController controller,
    String error,
    bool optional,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
          validator: (value) {
            if (optional) return null;

            if (value == null || value.trim().isEmpty) {
              return error;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _createParagraphBox(
    String name,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            fillColor: Colors.grey[300],
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }

  Widget _createNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _naviageteBack,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          ),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _navigateBackCreated,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF7FA99B),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          ),
          child: const Text(
            'Add Contact',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _naviageteBack() {
    Navigator.of(context).pop();
  }

  void _navigateBackCreated() {
    if (_formKey.currentState!.validate()) {
      // do backend stuff

      _naviageteBack();
    }
  }
}
