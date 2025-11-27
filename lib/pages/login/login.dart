/// @Created on: 13/11/25
/// @Author: Bodoor Albassam

import 'package:flutter/material.dart';
import 'package:prototype_project/components/button.dart';
import 'package:prototype_project/components/text_field.dart';
import 'package:prototype_project/models/user.dart';
import 'package:prototype_project/pages/home_page.dart';
import 'package:prototype_project/pages/login/forgot_password_email.dart';
import 'package:prototype_project/pages/login/signup.dart';
import 'package:prototype_project/pages/login/theme.dart';
import 'package:prototype_project/pages/login/validators.dart';
import 'package:prototype_project/utils/auth.dart';

import 'package:sqflite/sqflite.dart'
if (dart.library.ffi) 'package:sqflite_common_ffi/sqflite_ffi.dart'; // desktop sqflite

/// Sign-in screen: accepts either username or email + password
/// and validates against stored salted+hashed credentials.
class LoginScreen extends StatefulWidget {
  final User currentUser; // prototype temp
  final Database database;

  const LoginScreen({super.key, required this.database, required this.currentUser});

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
                        MaterialPageRoute(builder: (_) => ForgotPasswordEmailScreen(database: widget.database)),
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
                    final user = await Auth.checkCredentials(
                      usernameOrEmailController.text.trim(),
                      passwordController.text,
                      widget.database
                    );
                    setState(() => loading = false);
                    if (!mounted) return;
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Welcome, ${user.username}!')),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(database: widget.database, currentUser: widget.currentUser)),
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
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUpScreen(database: widget.database))
                        );
                      },
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
