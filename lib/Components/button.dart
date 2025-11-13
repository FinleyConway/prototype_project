import 'package:flutter/material.dart';
import '../Views/Auth/theme.dart';

/// Reusable app button with:
/// - Gradient fill (solid when outlined=false)
/// - Outline style (outlined=true)
/// - Press animation + loading spinner
/// - Optional leading icon
class AppButton extends StatefulWidget {
  final String label;       // Text on the button
  final VoidCallback onTap; // Button action
  final bool outlined;      // If true -> transparent with teal border
  final bool loading;       // If true -> shows spinner and disables taps
  final IconData? icon;     // Optional leading icon
  final bool expand;        // If true -> expand to full width

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.loading = false,
    this.icon,
    this.expand = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false; // For the small scale animation on press

  @override
  Widget build(BuildContext context) {
    final child = _ButtonContent(
      label: widget.label,
      icon: widget.icon,
      loading: widget.loading,
      outlined: widget.outlined,
    );

    // Scale + decoration animation for subtle tactile feedback
    final button = AnimatedScale(
      duration: const Duration(milliseconds: 100),
      scale: _pressed ? 0.98 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: widget.outlined
            ? BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kTeal, width: 1.4),
        )
            : BoxDecoration(
          gradient: kPrimaryGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: kSoftShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: widget.loading ? null : widget.onTap,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 54),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );

    // Expand horizontally when desired
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: widget.expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

// Internal: builds the text/icon/spinner content
class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool loading;
  final bool outlined;

  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.loading,
    required this.outlined,
  });

  @override
  Widget build(BuildContext context) {
    // Loading state -> spinner only
    if (loading) {
      return const SizedBox(
        height: 22, width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    final style = TextStyle(
      color: outlined ? kTeal : Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      letterSpacing: .2,
    );

    if (icon == null) return Text(label, style: style);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: outlined ? kTeal : Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(label, style: style),
      ],
    );
  }
}
