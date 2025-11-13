import 'package:carepanion/Views/Auth/home_screen.dart';
import 'package:flutter/material.dart';
import '../../Components/button.dart';
import 'validators.dart';
import 'auth_repository.dart';
import 'forgot_password_email.dart';
import 'package:carepanion/Views/Auth/theme.dart';
import '../../Components/text_field.dart';

/// Sign-in screen: accepts either username or email + password
/// and validates against stored salted+hashed credentials.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3E7C75)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Image.asset('assets/images/login.png', width: 310),
                const SizedBox(height: 10),
                const Text('Sign In',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kText)),
                const SizedBox(height: 6),
                const Text('Welcome back! Please sign in to continue.', style: TextStyle(color: kSub)),
                const SizedBox(height: 10),
                InputField(
                  controller: usernameOrEmailController,
                  hinText: 'Username or Email',
                  icon: Icons.person,
                  validator: (v) => requiredText(v, field: 'Username or Email'),
                ),
                InputField(
                  controller: passwordController,
                  hinText: 'Password',
                  icon: Icons.lock,
                  obscure: true,
                  validator: (v) => requiredText(v, field: 'Password'),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordEmailScreen()),
                      );
                    },
                    child: const Text('Forgot password?'),
                  ),
                ),
                AppButton(
                  label: 'Sign In',
                  loading: loading,
                  onTap: () async {
                    if (!formKey.currentState!.validate()) return;
                    setState(() => loading = true);
                    final user = await AuthRepository.checkCredentials(
                      usernameOrEmailController.text.trim(),
                      passwordController.text,
                    );
                    setState(() => loading = false);
                    if (!mounted) return;
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Welcome, ${user.username}!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid credentials')),
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text(
                        'Sign Up here',
                        style: TextStyle(fontWeight: FontWeight.bold, color: kText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
