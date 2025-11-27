import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/models/user.dart'; // temp
import 'package:prototype_project/context/carer_db.dart';
import 'pages/login/login.dart';

void main() async {
  // create a phone like experience on the desktop
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // based on the google pixel 6 pro scaled down
    const double sizeX = 1440 / 4;
    const double sizeY = 3120 / 4;

    setWindowMaxSize(const Size(sizeX, sizeY));
    setWindowMinSize(const Size(sizeX, sizeY));
  }

  // init desktop only database setup
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    // Initialize ffi implementation
    sqfliteFfiInit();
    // Set global factory
    databaseFactory = databaseFactoryFfi;
  }

  // create database context
  Database database = await CarerDb.create();

  // -- temp --
  // creates a temp person with dementia 
  User user = await User.create("PeterPrototype", database); // need a way of creating of globally creating a user and selecting a user
  // -- temp --

  runApp(MyApp(database: database, user: user));
}

class MyApp extends StatelessWidget {
  final User user; // temp
  final Database database;

  const MyApp({super.key, required this.database, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caregiver App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: LoginScreen(database: database),
    );
  }
}