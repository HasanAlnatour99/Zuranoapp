import 'package:flutter/material.dart';

import '../widgets/credentials_portal_login_view.dart';

/// Customer email-first sign-in (light theme; separate from staff UI).
class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CredentialsPortalLoginView(customerPortal: true);
  }
}
