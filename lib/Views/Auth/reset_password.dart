import 'package:flutter/material.dart';
import '../../Components/button.dart';
import '../../Components/text_field.dart';
import 'theme.dart';
import 'validators.dart';
import 'auth_repository.dart';

/// Step 3: set a new strong password after OTP verification.
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

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
                  await AuthRepository.updatePasswordByEmail(widget.email, p2.text);
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
