import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_project/main.dart';
import 'package:prototype_project/pages/homepage.dart';

void main() {
  group('Homepage Widget Tests', () {
    
    testWidgets('Homepage displays app bar with logo and profile icon', (WidgetTester tester) async {
      // Build app
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Verify app bar
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify logo 
      expect(find.byType(Image), findsOneWidget);
      
      // Verify title text
      expect(find.text('Home'), findsOneWidget);
      
      // Verify profile icon 
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Homepage displays all three information cards', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Verify all three information cards
      expect(find.text('Next Appointment'), findsOneWidget);
      expect(find.text('Medication Reminder'), findsOneWidget);
      expect(find.text('Latest Notes'), findsOneWidget);
    });

    testWidgets('Information cards display correct icons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Verify information card
      expect(find.byIcon(Icons.access_time), findsWidgets); 
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byIcon(Icons.notes), findsOneWidget);
    });

    testWidgets('Homepage displays exactly four navigation grid tiles', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Verify GridView exists
      expect(find.byType(GridView), findsOneWidget);
      
      // Verify grid tile icons
      expect(find.byIcon(Icons.calendar_today), findsWidgets);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
      
    });

    testWidgets('Homepage displays bottom navigation bar with five items', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Verify bottom navigation bar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Verify all five navigation icons 
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.people), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Homepage home icon in bottom nav is selected by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Find BottomNavigationBar
      final bottomNavBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      
      // Verify the home icon is selected
      expect(bottomNavBar.currentIndex, 0);
    });

    testWidgets('Homepage is scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
      // Verify scrollability
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  // =========================================  
  // Homepage inteactivity, TODO
  // =========================================
    // profile icon clicking
    testWidgets('Profile icon is tappable and navigates to profile page', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
   // await tester.tap(profileIcon);
    });

    // next appointment 
    testWidgets('Next Appointment card is tappable and navigates to appointment details', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      
    // await tester.tap(appointmentCard);
    
    });

    // medication reminder
    testWidgets('Medication Reminder card is tappable and navigates to medication details', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // await tester.tap(medicationCard);
    });

    // latest notes
    testWidgets('Latest Notes card is tappable and navigates to notes list', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // await tester.tap(notesCard);
    });

    // calander
    testWidgets('Calendar grid tile is tappable and navigates to calendar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // await tester.tap(calendarGridTile);
    });

    // checkmark
    testWidgets('Checkmark grid tile is tappable and navigates to ???', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // await tester.tap(checkTile);
    });

    // clock
    testWidgets('Clock grid tile is tappable and navigates to ?????', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // await tester.tap(clockGridTile);
    });

    // warning
    testWidgets('Warning grid tile is tappable and navigates to ????', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // await tester.tap(warningTile);
    });

    // nav bar
    testWidgets('Bottom navigation items are tappable and navigate correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
  
    // navbar items for test
    final navItems = [
      {'index': 0, 'icon': Icons.home, 'page': 'HomePage'},
      {'index': 1, 'icon': Icons.calendar_today, 'page': 'CalendarPage'},
      {'index': 2, 'icon': Icons.chat_bubble_outline, 'page': 'SocialPage'},
      {'index': 3, 'icon': Icons.people, 'page': 'CaregiversPage'},
      {'index': 4, 'icon': Icons.settings, 'page': 'SettingsPage'},
    ];
    
    for (final item in navItems) {
      // await tester.tap(find.byIcon(item['icon'] as IconData));
      
  });
  });

  // ========================================================================
  // FUTURE FEATURE TESTS - Calendar 
  // ========================================================================
  group('Calendar Widget Tests', () {
    
    // testWidgets('Calendar displays month view', (WidgetTester tester) async {
    //   // Test calendar widget renders correctly
    // });
    
    // testWidgets('Calendar allows caregiver to create events', (WidgetTester tester) async {
    //   // Test event creation functionality
    // });
    
    // testWidgets('Calendar displays medication reminders', (WidgetTester tester) async {
    //   // Test medication tracking display
    // });
    
    // testWidgets('Calendar shows multiple caregiver coordination', (WidgetTester tester) async {
    //   // Test multi-caregiver event viewing
    // });
  });

  // ========================================================================
  // FUTURE FEATURE TESTS - Symptom Log
  // ========================================================================
  group('Symptom Log Tests', () {
    
    // testWidgets('Symptom log displays entry form', (WidgetTester tester) async {
    //   // Test symptom entry form UI
    // });
    
    // testWidgets('Symptom log allows severity selection', (WidgetTester tester) async {
    //   // Test severity dropdown/slider
    // });
    
    // testWidgets('Symptom log displays categorised symptom groups', (WidgetTester tester) async {
    //   // Test symptom category display
    // });
    
    // testWidgets('Symptom log shows logged entries list', (WidgetTester tester) async {
    //   // Test viewing past symptom entries
    // });
    
    // testWidgets('Symptom log search and filter functionality works', (WidgetTester tester) async {
    //   // Test search/filter by date, type, caregiver
    // });
  });

  // ========================================================================
  // FUTURE FEATURE TESTS - Social Features
  // ========================================================================
  group('Social Features Tests', () {
    
    // TODO: Add tests when social features page is implemented
    // testWidgets('Social page displays links to external support groups', (WidgetTester tester) async {
    //   // Test external link buttons
    // });
    
    // testWidgets('Social page allows caregiver contact requests', (WidgetTester tester) async {
    //   // Test contact request functionality
    // });
    
  });

  // ========================================================================
  // FUTURE FEATURE TESTS - Educational Resources
  // ========================================================================
  group('Edu Resource Tests', () {
    
    // testWidgets('Educational page displays links to external info', (WidgetTester tester) async {
    //   // Test external resource links
    // });
    
    // testWidgets('Educational page shows info library', (WidgetTester tester) async {
    //   // Test library display
    // });
    
    // testWidgets('Educational resources are categorised by dementia stage', (WidgetTester tester) async {
    //   // Test stage filtering
    // });
    
    // testWidgets('Educational page bookmark functionality works', (WidgetTester tester) async {
    //   // Test bookmark/save feature
    // });
    
    
  });
}