import 'package:flutter/material.dart';
import '../pages/login/theme.dart';

/// Reusable input with:
/// - Optional validator
/// - Toggle show/hide for passwords (eye icon)
/// - Helper text under the field (multi-line)
/// - Multi-line error messages
class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hinText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscure;      // If true -> start obscured (password)
  final String? helperText; // Optional permanent hint below the field

  const InputField({
    super.key,
    required this.controller,
    required this.hinText,
    required this.icon,
    this.validator,
    this.obscure = false,
    this.helperText,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscured = false; // Tracks eye toggle

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscured,
        validator: widget.validator,
        decoration: inputDec(widget.hinText, icon: widget.icon).copyWith(
          // Password show/hide eye
          suffixIcon: widget.obscure
              ? IconButton(
            onPressed: () => setState(() => _obscured = !_obscured),
            icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
          )
              : null,

          // Helper (static) + allow multiple lines for readability
          helperText: widget.helperText,
          helperMaxLines: 3,
          helperStyle: const TextStyle(fontSize: 12, color: kSub),

          // Error (dynamic) with multiple lines to avoid clipping
          errorMaxLines: 3,
          errorStyle: const TextStyle(fontSize: 12, color: Colors.red),

          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
