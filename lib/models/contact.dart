import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Contact {
  final int id;
  final int userId;
  final String name;
  final String relation;
  final String phoneNumber;
  final String secondaryPhoneNumber;
  final String notes;

  Contact({
    required this.id, 
    required this.userId,
    required this.name, 
    required this.relation, 
    required this.phoneNumber, 
    required this.secondaryPhoneNumber, 
    required this.notes}
  );

  static Future<Contact> create(int userId, String name, String relation, String phoneNumber, String secondaryPhoneNumber, String notes, Database database) async {
    final int id = await database.insert(
      "contact",
      {
        "user_id" : userId,
        "name" : name,
        "relation" : relation,
        "phone_number" : phoneNumber,
        "secondary_phone_number" : secondaryPhoneNumber,
        "notes" : notes
      },
    );

    return Contact(
      id: id, 
      userId: userId,
      name: name, 
      relation: relation, 
      phoneNumber: phoneNumber, 
      secondaryPhoneNumber: secondaryPhoneNumber, 
      notes: notes
    );
  }

  static Future<List<Contact>> getAllByUserId(int userId, Database database) async {
    final result = await database.query(
      "contact",
      where: "user_id = ?",
      whereArgs: [userId]
    );

    return result.map((row) => _fromMap(row)).toList();
  }

  static Contact _fromMap(Map<String, Object?> map) {
    return Contact(
      id: map["id"] as int, 
      userId: map["user_id"] as int,
      name: map["name"] as String,
      relation: map["relation"] as String,
      phoneNumber: map["phone_number"] as String,
      secondaryPhoneNumber: map["secondary_phone_number"] as String,
      notes: map["notes"] as String, 
    );
  }

  @override
  bool operator ==(covariant Contact other) {
    return
      other.id == id &&
      other.userId == userId &&
      other.name == name &&
      other.relation == relation &&
      other.phoneNumber == phoneNumber &&
      other.secondaryPhoneNumber == secondaryPhoneNumber &&
      other.notes == notes;
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    relation,
    phoneNumber,
    secondaryPhoneNumber,
    notes,
  );
}