import 'package:flutter/material.dart';

class TeamMemberActionRow extends StatelessWidget {
  const TeamMemberActionRow({
    super.key,
    required this.canContact,
    required this.canBook,
    required this.callLabel,
    required this.whatsappLabel,
    required this.bookingLabel,
    required this.onCall,
    required this.onWhatsApp,
    required this.onAddBooking,
  });

  final bool canContact;
  final bool canBook;
  final String callLabel;
  final String whatsappLabel;
  final String bookingLabel;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onAddBooking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.phone_rounded,
            label: callLabel,
            enabled: canContact,
            accent: scheme.primary,
            onTap: onCall,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.chat_rounded,
            label: whatsappLabel,
            enabled: canContact,
            accent: scheme.primary,
            onTap: onWhatsApp,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.event_available_rounded,
            label: bookingLabel,
            enabled: canBook,
            accent: scheme.primary,
            onTap: onAddBooking,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = enabled ? accent : scheme.outline;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: enabled ? onTap : null,
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: enabled
                  ? accent.withValues(alpha: 0.28)
                  : scheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: enabled ? scheme.onSurface : scheme.outline,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
