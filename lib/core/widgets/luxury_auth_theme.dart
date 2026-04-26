import 'package:flutter/material.dart';
import '../../features/auth/presentation/widgets/auth_shell.dart';

/// Wraps children in the premium purple/dark luxury theme (AuthShell).
/// Used for auth and onboarding to ensure consistent brand feel.
class LuxuryAuthTheme extends StatelessWidget {
  const LuxuryAuthTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AuthShell(child: child);
  }
}
