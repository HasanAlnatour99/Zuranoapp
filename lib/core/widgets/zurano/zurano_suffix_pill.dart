import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';

class ZuranoSuffixPill extends StatelessWidget {
  const ZuranoSuffixPill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: ZuranoTokens.lightPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: ZuranoTokens.primary,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}
