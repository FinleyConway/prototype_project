import 'package:flutter_test/flutter_test.dart';

import 'package:prototype_project/models/contact.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/context/carer_db.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> testCreatingContact() async {
  final Database db = await CarerDb.create();
  
  final User user = await User.create("Finley", db);
  final Contact newContact = await user.assignContact("bob", "bro", "+44123", "", "", db);

  final List<Contact> contacts = await user.getAllContacts(db);

  expect(contacts.first, newContact);

  await db.close();
}

void main() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;

  test("Creating Contact", testCreatingContact);
}