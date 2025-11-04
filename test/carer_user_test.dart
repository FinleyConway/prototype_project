/// @Created on: 4/11/25
/// @Author: Finley Conway

import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:prototype_project/models/carer.dart';
import 'package:prototype_project/models/user.dart';

// https://github.com/tekartik/sqflite/blob/master/sqflite/doc/testing.md

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

Future<Database> createDatabase() async {
  Database db = await openDatabase(inMemoryDatabasePath); // creates a database within memory

  await db.execute("""
    CREATE TABLE carer(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      password TEXT
    );

    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    );

    CREATE TABLE carer_to_user (
      carer_id INTEGER,
      user_id INTEGER,
      PRIMARY KEY (carer_id, user_id),
      FOREIGN KEY (carer_id) REFERENCES carer(id),
      FOREIGN KEY (user_id) REFERENCES user(id)
    );
  """);

  return db;
}

Future<void> testCreatingCarer() async {
  final Database db = await createDatabase();

  final int carerId = await Carer.create("Finley", "1234", db);
  final Carer? carer = await Carer.getById(carerId, db);

  expect(carer, Carer(id: 1, name: "Finley", password: "1234"));

  await db.close();
}

Future<void> testCreatingUser() async {
  final Database db = await createDatabase();

  final int userId = await User.create("Finley", db);
  final User? user = await User.get(userId, db);

  expect(user, User(id: 1, name: "Finley"));

  await db.close();
}

Future<void> testCarerToUsers() async {
  final Database db = await createDatabase();

  final int carerId = await Carer.create("Finley", "1234", db); // create a carer
  List<int> users = []; 

  // create and assign users to carer
  for (int i = 0; i < 10; i++) {
    final int userId = await User.create("Bob", db);

    users.add(userId);

    Carer.assignUser(carerId, userId, db);
  }

  // get all protential users assigned to carer
  final List<User> potentialUsers = await Carer.getAllUsers(carerId, db);

  // check if they are assigned to carer
  for (int i = 0; i < 10; i++) {
    final User? user = await User.get(users[i], db);

    expect(potentialUsers, contains(user));
  }

  await db.close();
}

void main() {
  sqfliteTestInit();

  test("Creating Carer", testCreatingCarer);
  test("Creating User", testCreatingUser);
  test("Carer To Users", testCarerToUsers);
}