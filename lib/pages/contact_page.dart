import 'package:flutter/material.dart';

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/contact.dart';
import 'package:prototype_project/pages/create_contact_page.dart';

import 'package:sqflite/sqflite.dart' // mobile sqflite
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

class MyContactPage extends StatefulWidget {
  final User currentUser;
  final Database database;

  const MyContactPage({super.key, required this.database, required this.currentUser});

  @override
  State<MyContactPage> createState() => _MyContactPageState();
}

class _MyContactPageState extends State<MyContactPage> {
  List<Contact> _contacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    _loadContacts();

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _createAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createFakeEmergencyButton(),
            const SizedBox(height: 20),
            _createFakeGPButton(),
            const SizedBox(height: 20),
            _createFakeContactButtons(),
            const SizedBox(height: 20),
            _createContactButton(),
          ],
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
        "Contacts",
        style: TextStyle(
          color: Color(0xFF7FA99B),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _createFakeEmergencyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        // to fake the button press
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE36565),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
        ),
        child: Row(
          children: [
            const Icon(Icons.phone, color: Colors.black, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Emergency Services",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  "CALL 999",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createFakeGPButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD0E5D4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFF6D9C8C)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "GP Practice",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Text(
                "+44 4385930495",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 48,
            height: 48,
            // to fake the button press
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFF6D9C8C),
                padding: EdgeInsets.zero,
                elevation: 2,
              ),
              child: const Icon(Icons.phone, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createFakeContactButtons() {
    return Expanded(
      child: ListView(
        children: [
          for (final Contact contact in _contacts) _createContact(contact),
        ],
      ),
    );
  }

  Widget _createContact(Contact contact) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFDCE6E8),
            child: Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // add contact information
                Text(
                  contact.relation,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                Text(
                  contact.phoneNumber,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                if (contact.secondaryPhoneNumber.isNotEmpty)
                  Text(
                    contact.secondaryPhoneNumber,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                if (contact.notes.isNotEmpty)
                  Text(
                    contact.notes,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            // handle "call"
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFF6D9C8C),
                padding: EdgeInsets.zero,
                elevation: 2,
              ),
              child: const Icon(Icons.phone, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _createContactButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _naviageteToCreateContact,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFF7FA99B),
        ),
        child: const Text(
          "Add Contact",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void _naviageteToCreateContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyCreateContactPage(database: widget.database, currentUser: widget.currentUser)),
    ).then((_) {
      _loadContacts();
    });
  }

  void _loadContacts() async {
    final List<Contact> contacts = await widget.currentUser.getAllContacts(widget.database);

    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }
}
