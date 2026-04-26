import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class EmployeeSalesHeader extends StatelessWidget {
  const EmployeeSalesHeader({
    super.key,
    required this.displayName,
    this.photoUrl,
  });

  final String displayName;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    String ch(String s) =>
        s.isNotEmpty ? String.fromCharCode(s.runes.first).toUpperCase() : '';
    final initials = parts.isEmpty
        ? '?'
        : (parts.length == 1
              ? ch(parts.first)
              : '${ch(parts.first)}${ch(parts[1])}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.employeeSalesTitle,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.employeeSalesSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFF4ECFF),
                backgroundImage:
                    (photoUrl != null && photoUrl!.trim().isNotEmpty)
                    ? NetworkImage(photoUrl!.trim())
                    : null,
                child: (photoUrl == null || photoUrl!.trim().isEmpty)
                    ? Text(
                        initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7C3AED),
                        ),
                      )
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
