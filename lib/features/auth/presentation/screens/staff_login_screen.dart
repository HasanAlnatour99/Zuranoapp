import 'package:flutter/material.dart';

import '../widgets/credentials_portal_login_view.dart';

/// Staff / employee username sign-in (no customer signup or social stack).
class StaffLoginScreen extends StatelessWidget {
  const StaffLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CredentialsPortalLoginView(customerPortal: false);
  }
}
