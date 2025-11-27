import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Password must be at least 6 characters', () {
    String password = '12345';
    bool valid = password.length >= 6;
    expect(valid, false);
  });

  test('Email should contain @ symbol', () {
    String email = 'user@example.com';
    bool valid = email.contains('@');
    expect(valid, true);
  });

  test('Username should not be empty', () {
    String username = '';
    bool valid = username.isNotEmpty;
    expect(valid, false);
  });
}
