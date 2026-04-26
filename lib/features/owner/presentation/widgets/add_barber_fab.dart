import 'package:flutter/material.dart';

import 'package:barber_shop_app/core/ui/app_icons.dart';

class AddBarberFab extends StatelessWidget {
  const AddBarberFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'owner_add_barber_fab',
      onPressed: onPressed,
      backgroundColor: const Color(0xFF7C3AED),
      foregroundColor: Colors.white,
      elevation: 10,
      shape: const CircleBorder(),
      child: const Icon(AppIcons.person_add_alt_1_outlined, size: 28),
    );
  }
}
