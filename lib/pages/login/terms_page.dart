import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';

/// Shows our local HTML (assets/terms.html) inside a scrollable page.
/// Keeping it local keeps the prototype fully offline and simple.
class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  String _html = '<p>Loading…</p>';

  @override
  void initState() {
    super.initState();
    // Load HTML from assets once the widget is ready
    rootBundle.loadString('assets/terms.html').then((v) {
      if (mounted) setState(() => _html = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Privacy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Html(data: _html),
      ),
    );
  }
}
