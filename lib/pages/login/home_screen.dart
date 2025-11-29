// import 'package:flutter/material.dart';
// import '../../components/button.dart';
// import 'theme.dart';
// import 'login.dart';
// import 'signup.dart';

// /// Landing page with logo and quick navigation to Sign In / Sign Up.
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBg,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               const Text(
//                 'Welcome',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: kTeal),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Please sign in or create a new account.',
//                 style: TextStyle(color: Color(0xFF9AA3AF)),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: Center(
//                   child: Image.asset('assets/images/logo.png', width: 260, fit: BoxFit.contain),
//                 ),
//               ),
//               AppButton(
//                 label: 'Sign In',
//                 icon: Icons.login,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 ),
//               ),
//               AppButton(
//                 label: 'Sign Up',
//                 outlined: true,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const SignUpScreen()),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
