/// @Created on: 7/11/25
/// @Author: Finley Conway

import 'package:prototype_project/models/symptom_log.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/context/carer_db.dart';

Future<void> testCreatingSymptomLog() async {
  final Database db = await CarerDb.create();
  
  final User user = await User.create("Finley", db);
  final SymptomLog newSymptomLog = await user.assignSymptomLog(
    Symptom.memoryLoss,
    "sadasdasdasdasdasd",
    DateTime(2025, 11, 7), 
    db
  );

  final List<SymptomLog> allSymptomLogs = await user.getAllLoggedSymptoms(SymptomOrder.ascend, SymptomSortBy.date, db);

  expect(allSymptomLogs.first, newSymptomLog);

  await db.close();
}

Future<void> testQuerySymptomLogTime() async {
  final Database db = await CarerDb.create();
  
  final User user = await User.create("Finley", db);
  final SymptomLog newSymptomLog = await user.assignSymptomLog(
    Symptom.memoryLoss,
    "sadasdasdasdasdasd",
    DateTime(2025, 11, 7), 
    db
  );
  final SymptomLog newSymptomLog1 = await user.assignSymptomLog(
    Symptom.memoryLoss,
    "sadasdasdasdasdasd",
    DateTime(2026, 11, 7), 
    db
  );

  final List<SymptomLog> allSymptomLogs = await user.getAllLoggedSymptoms(SymptomOrder.ascend, SymptomSortBy.date, db);

  expect(allSymptomLogs[0], newSymptomLog);
  expect(allSymptomLogs[1], newSymptomLog1);

  final List<SymptomLog> allSymptomLogs1 = await user.getAllLoggedSymptoms(SymptomOrder.descend, SymptomSortBy.date, db);

  expect(allSymptomLogs1[1], newSymptomLog);
  expect(allSymptomLogs1[0], newSymptomLog1);

  await db.close();
}

Future<void> testQuerySymptomLogSymptom() async {
  final Database db = await CarerDb.create();
  
  final User user = await User.create("Finley", db);
  final SymptomLog newSymptomLog = await user.assignSymptomLog(
    Symptom.memoryLoss,
    "sadasdasdasdasdasd",
    DateTime(2025, 11, 7), 
    db
  );
  final SymptomLog newSymptomLog1 = await user.assignSymptomLog(
    Symptom.moodChanges,
    "sadasdasdasdasdasd",
    DateTime(2026, 11, 7), 
    db
  );

  final List<SymptomLog> allSymptomLogs = await user.getAllLoggedSymptoms(SymptomOrder.ascend, SymptomSortBy.symptomType, db);

  expect(allSymptomLogs[1], newSymptomLog);
  expect(allSymptomLogs[0], newSymptomLog1);

  final List<SymptomLog> allSymptomLogs1 = await user.getAllLoggedSymptoms(SymptomOrder.descend, SymptomSortBy.symptomType, db);

  expect(allSymptomLogs1[0], newSymptomLog);
  expect(allSymptomLogs1[1], newSymptomLog1);

  await db.close();
}

void main() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;

  test("Creating Symptom Log", testCreatingSymptomLog);
  test("Query Symptom Log By Time", testQuerySymptomLogTime);
  test("Query Symptom Log By Symptom", testQuerySymptomLogSymptom);
}