/// @Created on: 13/11/25
/// @Author: Bodoor Albassam

import 'package:flutter/material.dart';
import 'package:prototype_project/components/button.dart';
import 'package:prototype_project/models/carer.dart';
import 'package:prototype_project/pages/login/forgot_password_otp.dart';
import 'package:prototype_project/pages/login/theme.dart';
import 'package:prototype_project/pages/login/validators.dart';
import 'package:prototype_project/utils/auth.dart';

import 'package:sqflite/sqflite.dart'
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

/// Step 1 in reset flow: user enters email, we generate OTP (demo)
class ForgotPasswordEmailScreen extends StatefulWidget {
  final Database database;

  const ForgotPasswordEmailScreen({super.key, required this.database});

  @override
  State<ForgotPasswordEmailScreen> createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please enter your email to reset the password.',
                style: TextStyle(color: kSub),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: emailCtrl,
                validator: emailAllowed,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Send OTP',
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;
                  final Carer? exists = await Carer.getByEmail(emailCtrl.text.trim(), widget.database);
                  if (exists == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email not found')),
                    );
                    return;
                  }
                  // Demo only: OTP appears as a SnackBar.
                  final code = await Auth.generateOtpFor(emailCtrl.text.trim(), widget.database);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('OTP (demo): $code')),
                  );
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForgotPasswordOTPScreen(email: emailCtrl.text.trim(), database: widget.database),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
