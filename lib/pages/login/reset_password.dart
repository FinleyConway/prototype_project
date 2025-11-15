/// @Created on: 13/11/25
/// @Author: Bodoor Albassam

import 'package:flutter/material.dart';
import 'package:prototype_project/components/button.dart';
import 'package:prototype_project/components/text_field.dart';
import 'package:prototype_project/pages/login/theme.dart';
import 'package:prototype_project/pages/login/validators.dart';
import 'package:prototype_project/utils/auth.dart';

import 'package:sqflite/sqflite.dart';

/// Step 3: set a new strong password after OTP verification.
class ResetPasswordScreen extends StatefulWidget {
  final Database database;
  final String email;

  const ResetPasswordScreen({super.key, required this.email, required this.database});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final p1 = TextEditingController();
  final p2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(title: const Text('Set a new password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Strong password with helper text that explains the rules
              InputField(
                controller: p1,
                hinText: 'New Password',
                icon: Icons.lock,
                obscure: true,
                helperText:
                'Password must be 8+ chars with upper, lower, number & special character.',
                validator: strongPassword,
              ),

              // Must match the first field
              InputField(
                controller: p2,
                hinText: 'Confirm Password',
                icon: Icons.lock,
                obscure: true,
                validator: (v) => confirm(v, p1.text, field: 'Passwords'),
              ),

              const SizedBox(height: 10),

              AppButton(
                label: 'Update Password',
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;
                  await Auth.updatePasswordByEmail(widget.email, p2.text, widget.database);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset successful')),
                  );
                  // Return all the way to the first route (home)
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
