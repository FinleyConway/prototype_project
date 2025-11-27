import 'package:flutter/material.dart';

/// Centralized theme vars for consistent colors/shadows/inputs.
const kBg = Color(0xFFF9FAFB);
const kTeal = Color(0xFF4FB79A);
const kTealDark = Color(0xFF2B6F62);
const kText = Color(0xFF0F172A);
const kSub = Color(0xFF94A3B8);

const LinearGradient kPrimaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF58C2A8), Color(0xFF3CA58F)],
);

final List<BoxShadow> kSoftShadow = [
  BoxShadow(
    color: const Color(0xFF3CA58F).withOpacity(.22),
    blurRadius: 14,
    offset: const Offset(0, 6),
  ),
];

/// Base decoration for most text fields in the app.
InputDecoration inputDec(String label, {IconData? icon}) => InputDecoration(
  labelText: label,
  prefixIcon: icon == null ? null : Icon(icon, color: kTeal),
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: kTeal),
  ),
);
