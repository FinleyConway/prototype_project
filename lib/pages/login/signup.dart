import 'package:flutter/material.dart';
import 'package:prototype_project/components/button.dart';
import 'package:prototype_project/components/text_field.dart';
import 'package:prototype_project/models/carer.dart';
import 'package:prototype_project/pages/login/terms_page.dart';
import 'package:prototype_project/pages/login/theme.dart';
import 'package:prototype_project/pages/login/validators.dart';
import 'package:prototype_project/utils/auth.dart';
import 'package:sqflite/sqflite.dart';

/// Registration with:
/// - Full name (>= 6)
/// - Email restricted to gmail/outlook (for this prototype)
/// - Live username availability check
/// - Strong password policy + confirmation
/// - Terms & Privacy checkbox linking to local HTML
class SignUpScreen extends StatefulWidget {
  final Database database;

  const SignUpScreen({super.key, required this.database});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool agreed = false;
  bool checkingUser = false; // shows spinner in the suffix
  String? usernameError;     // set when username already exists

  // Debounced-ish availability check (simple version)
  Future<void> _checkUsername(String v) async {
    setState(() {
      checkingUser = true;
      usernameError = null;
    });
    final ok = await Carer.getByUsername(v.trim(), widget.database);
    setState(() {
      checkingUser = false;
      usernameError = ok == null ? null : 'Username already taken';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 6),
                Image.asset('assets/images/logo.png', width: 110, height: 110),
                const SizedBox(height: 8),
                const Text(
                  'REGISTER',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 10),

                // Full name (human-like, min 6)
                InputField(
                  controller: fullNameController,
                  hinText: 'Full name',
                  icon: Icons.person,
                  validator: (v) {
                    final r = requiredText(v, field: 'Full name');
                    if (r != null) return r;
                    return minLen(v, 6, field: 'Full name');
                  },
                ),

                // Email (only gmail/outlook for the prototype)
                InputField(
                  controller: emailController,
                  hinText: 'Email',
                  icon: Icons.email,
                  validator: emailAllowed,
                ),

                // Username with live availability feedback
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: inputDec('Username', icon: Icons.account_circle_rounded).copyWith(
                      errorText: usernameError,
                      suffixIcon: checkingUser
                          ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                          : null,
                    ),
                    onChanged: (v) {
                      if (v.trim().isNotEmpty) _checkUsername(v);
                    },
                    validator: (v) {
                      final r = requiredText(v, field: 'Username');
                      if (r != null) return r;
                      if (usernameError != null) return usernameError;
                      return null;
                    },
                  ),
                ),

                // Strong password rule (with visible helper)
                InputField(
                  controller: passwordController,
                  hinText: 'Password',
                  icon: Icons.lock,
                  obscure: true,
                  helperText:
                  'Password must be 8+ chars with upper, lower, number & special character.',
                  validator: strongPassword,
                ),

                // Confirm same password
                InputField(
                  controller: confirmPasswordController,
                  hinText: 'Re-enter password',
                  icon: Icons.lock,
                  obscure: true,
                  validator: (v) => confirm(v, passwordController.text, field: 'Passwords'),
                ),

                // Terms & Privacy with links to our local HTML
                Row(
                  children: [
                    Checkbox(
                      value: agreed,
                      activeColor: kTeal,
                      onChanged: (v) => setState(() => agreed = v ?? false),
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          const Text('By signing up you agree to our '),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermsPage()),
                            ),
                            child: const Text('Terms and Conditions',
                                style: TextStyle(color: kTeal, fontWeight: FontWeight.w600)),
                          ),
                          const Text(' and '),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermsPage()),
                            ),
                            child: const Text('Privacy Policy',
                                style: TextStyle(color: kTeal, fontWeight: FontWeight.w600)),
                          ),
                          const Text('.'),
                        ],
                      ),
                    ),
                  ],
                ),

                // Submit
                AppButton(
                  label: 'REGISTER',
                  onTap: () async {
                    if (!formKey.currentState!.validate()) return;
                    if (!agreed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please accept Terms & Privacy')),
                      );
                      return;
                    }

                    final err = await Auth.signUp(
                      fullNameController.text.trim(),
                      emailController.text.trim().toLowerCase(),
                      usernameController.text.trim(),
                      passwordController.text,
                      true,
                      widget.database
                    );

                    if (!mounted) return;
                    if (!err.success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.error)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account created. You can sign in now.')),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),

                // Already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(' Sign In here',
                          style: TextStyle(fontWeight: FontWeight.bold, color: kText)),
                    )
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
