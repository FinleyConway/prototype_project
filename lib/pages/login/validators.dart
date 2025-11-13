/// Simple synchronous validators shared across screens.

final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

// At least 8 chars, with 1 lower, 1 upper, 1 number, 1 special
final _passwordRegex =
RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');

String? requiredText(String? v, {String field = 'This field'}) {
  if (v == null || v.trim().isEmpty) return '$field is required';
  return null;
}

String? minLen(String? v, int len, {String field = 'This field'}) {
  if ((v ?? '').trim().length < len) return '$field must be at least $len characters';
  return null;
}

String? confirm(String? v, String target, {String field = 'Values'}) {
  if ((v ?? '') != target) return '$field don’t match';
  return null;
}

/// Only allow proper format + selected domains for the prototype.
String? emailAllowed(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  final s = v.trim().toLowerCase();
  final validPattern = _emailRegex.hasMatch(s);
  final allowed = s.endsWith('@gmail.com') || s.endsWith('@outlook.com');
  if (!validPattern || !allowed) {
    return 'Please enter a valid @gmail.com or @outlook.com email';
  }
  return null;
}

/// Strong password policy used in SignUp and Reset Password.
String? strongPassword(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (!_passwordRegex.hasMatch(v)) {
    return 'Password must be 8+ chars with upper, lower, number & symbol';
  }
  return null;
}
