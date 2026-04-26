import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/widgets/app_notification_badge.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/notification_providers.dart';
import '../../../../users/data/models/app_user.dart';
import 'overview_design_tokens.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Salon context, date, notifications, and profile (overview body header).
class OverviewPremiumHeader extends ConsumerWidget {
  const OverviewPremiumHeader({
    super.key,
    required this.salonName,
    required this.user,
    required this.locale,
  });

  final String salonName;
  final AppUser user;
  final Locale locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat.yMMMEd(
      locale.toString(),
    ).format(DateTime.now());
    final title = salonName.trim().isNotEmpty
        ? salonName.trim()
        : l10n.ownerDashboardTitle;
    final initials = _initials(user.name);

    final unread = ref.watch(unreadNotificationCountProvider);

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: OwnerOverviewTokens.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const Gap(2),
                Text(
                  dateLabel,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.notificationsInboxTooltip,
            onPressed: () => context.push(AppRoutes.notifications),
            icon: AppNotificationBadge(
              count: unread,
              child: Icon(
                AppIcons.notifications_outlined,
                color: OwnerOverviewTokens.purple.withValues(alpha: 0.9),
              ),
            ),
          ),
          Material(
            color: scheme.surfaceContainerHighest,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(AppRoutes.settings),
              child: SizedBox(
                width: 40,
                height: 40,
                child: user.photoUrl != null && user.photoUrl!.trim().isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: user.photoUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            _InitialsAvatar(initials: initials),
                      )
                    : _InitialsAvatar(initials: initials),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    }
    final a = parts.first.isNotEmpty ? parts.first[0] : '';
    final b = parts.last.isNotEmpty ? parts.last[0] : '';
    return ('$a$b').toUpperCase();
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: OwnerOverviewTokens.purple,
        ),
      ),
    );
  }
}
