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

  final int carerId = await Carer.create("Finley", "1234", db);
  final Carer? carer = await Carer.getById(carerId, db);

  expect(carer, Carer(id: 1, name: "Finley", password: "1234"));

  await db.close();
}

Future<void> testCreatingUser() async {
  final Database db = await CarerDb.create();

  final int userId = await User.create("Finley", db);
  final User? user = await User.get(userId, db);

  expect(user, User(id: 1, name: "Finley"));

  await db.close();
}

Future<void> testCarerToUsers() async {
  final Database db = await CarerDb.create();

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
  test("Creating Carer", testCreatingCarer);
  test("Creating User", testCreatingUser);
  test("Carer To Users", testCarerToUsers);
}