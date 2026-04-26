import 'package:flutter/material.dart';

import 'customer_gradient_scaffold.dart';

class CustomerBookingConfirmButton extends StatelessWidget {
  const CustomerBookingConfirmButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: CustomerPrimaryButtonStyle.filled(context),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
