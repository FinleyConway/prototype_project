import 'package:flutter/material.dart';

import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/models/contact.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold();
  }
  
  void _loadContacts() async {
    final List<Contact> contacts = await widget.currentUser.getAllContacts(widget.database);

    setState(() {
      _contacts = contacts;
      _loading = false;
    });
  }
}