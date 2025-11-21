/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/context/carer_db.dart';
import 'package:prototype_project/models/carer.dart';
import 'package:prototype_project/models/user.dart';

// https://github.com/tekartik/sqflite/blob/master/sqflite/doc/testing.md

Future<void> testCreatingCarer() async {
  final Database db = await CarerDb.create();

  final Carer newCarer = await Carer.create("Finley", "1234", db);
  final Carer? carer = await Carer.getById(newCarer.id, db);

  expect(carer, newCarer);

  await db.close();
}

Future<void> testCreatingUser() async {
  final Database db = await CarerDb.create();

  final User newUser = await User.create("Finley", db);
  final User? user = await User.get(newUser.id, db);

  expect(user, newUser);

  await db.close();
}

Future<void> testCarerToUsers() async {
  final Database db = await CarerDb.create();

  final Carer carer = await Carer.create("Finley", "1234", db); 
  List<User> users = []; 

  // create and assign users to carer
  for (int i = 0; i < 10; i++) {
    final User user = await User.create("Bob", db);

    users.add(user);
    carer.assignUser(user.id, db);
  }

  // get all protential users assigned to carer
  final List<User> potentialUsers = await carer.getAllUsers(db);

  // check if they are assigned to carer
  for (int i = 0; i < 10; i++) {
    expect(potentialUsers, contains(users[i]));
  }

  await db.close();
}

void main() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;

  test("Creating Carer", testCreatingCarer);
  test("Creating User", testCreatingUser);
  test("Carer To Users", testCarerToUsers);
}