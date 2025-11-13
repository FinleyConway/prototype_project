import 'package:flutter/material.dart';
import '../../components/button.dart';
import 'theme.dart';
import '../../Views/Auth/auth_repository.dart';
import 'reset_password.dart';

/// Step 2: user types the OTP received (demo)
class ForgotPasswordOTPScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordOTPScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOTPScreen> createState() => _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  final codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "We sent a 6-digit code to ${widget.email}",
              style: const TextStyle(color: kSub),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP Code'),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Verify',
              onTap: () async {
                final ok = await AuthRepository.verifyOtp(widget.email, codeCtrl.text.trim());
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid/expired code')),
                  );
                  return;
                }
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResetPasswordScreen(email: widget.email),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
