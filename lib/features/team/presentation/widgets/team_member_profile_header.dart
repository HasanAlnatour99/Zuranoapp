import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/formatting/staff_role_localized.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/team_member_model.dart';

class TeamMemberProfileHeader extends StatelessWidget {
  const TeamMemberProfileHeader({
    super.key,
    required this.member,
    required this.l10n,
    required this.localeName,
  });

  final TeamMemberModel member;
  final AppLocalizations l10n;
  final String localeName;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final joinDateText = _joinDateText(context);

    final rawUrl = member.profileImageUrl?.trim();
    final hasPhoto = rawUrl != null && rawUrl.isNotEmpty;
    final resolvedUrl = hasPhoto ? rawUrl : '';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            scheme.surface,
            scheme.primaryContainer.withValues(alpha: 0.35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: scheme.primaryContainer,
                backgroundImage: hasPhoto
                    ? CachedNetworkImageProvider(resolvedUrl)
                    : null,
                child: !hasPhoto
                    ? Text(
                        member.initials,
                        style: textTheme.headlineSmall?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : null,
              ),
              Positioned(
                right: 3,
                bottom: 3,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: member.isActive && !member.isFrozen
                        ? const Color(0xFF22C55E)
                        : scheme.outline,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.surface, width: 4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  localizedStaffRole(l10n, _roleString(member)),
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                _StatusBadge(
                  label: _statusLabel(l10n),
                  isPositive: member.isActive && !member.isFrozen,
                  scheme: scheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        joinDateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _roleString(TeamMemberModel m) {
    return switch (m.profileRole) {
      TeamMemberProfileRole.owner => 'owner',
      TeamMemberProfileRole.admin => 'admin',
      TeamMemberProfileRole.barber => 'barber',
      TeamMemberProfileRole.teamMember => 'readonly',
    };
  }

  String _statusLabel(AppLocalizations l10n) {
    if (member.isFrozen) return l10n.teamProfileStatusFrozen;
    if (!member.isActive) return l10n.teamStatusInactive;
    return l10n.teamStatusActive;
  }

  String _joinDateText(BuildContext context) {
    final ts = member.createdAt;
    if (ts == null) return l10n.teamProfileJoinDateMissing;
    final date = ts.toDate();
    return DateFormat.yMMMd(localeName).format(date.toLocal());
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.isPositive,
    required this.scheme,
    required this.textTheme,
  });

  final String label;
  final bool isPositive;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final fg = isPositive ? const Color(0xFF16A34A) : scheme.onSurfaceVariant;
    final bg = isPositive
        ? const Color(0xFFE7F8EF)
        : scheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
