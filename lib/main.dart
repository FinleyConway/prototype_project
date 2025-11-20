import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prototype_project/pages/contact_page.dart';
import 'package:window_size/window_size.dart';

import 'pages/home_page.dart';

void main() {
  // create a phone like experience on the desktop
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // based on the google pixel 6 pro scaled down
    const double sizeX = 1440 / 4;
    const double sizeY = 3120 / 4;

    setWindowMaxSize(const Size(sizeX, sizeY));
    setWindowMinSize(const Size(sizeX, sizeY));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caregiver App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyContactPage(),
    );
  }
}