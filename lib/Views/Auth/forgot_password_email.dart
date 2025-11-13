import 'package:flutter/material.dart';
import '../../Components/button.dart';
import 'theme.dart';
import 'validators.dart';
import 'auth_repository.dart';
import 'forgot_password_otp.dart';

/// Step 1 in reset flow: user enters email, we generate OTP (demo)
class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

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
                  final exists = await AuthRepository.emailExists(emailCtrl.text.trim());
                  if (!exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email not found')),
                    );
                    return;
                  }
                  // Demo only: OTP appears as a SnackBar.
                  final code = await AuthRepository.generateOtpFor(emailCtrl.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('OTP (demo): $code')),
                  );
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForgotPasswordOTPScreen(email: emailCtrl.text.trim()),
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
