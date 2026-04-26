import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/text/personalized_greeting.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_notification_badge.dart';
import '../../../../features/owner/logic/owner_overview_controller.dart';
import '../../../../features/owner/logic/owner_overview_state.dart';
import '../../../../features/users/data/models/app_user.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/notification_providers.dart';

String _heroUserInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }
  final a = parts.first.isNotEmpty ? parts.first[0] : '';
  final b = parts.last.isNotEmpty ? parts.last[0] : '';
  return ('$a$b').toUpperCase();
}

String _resolveDisplayName(AppUser user, OwnerOverviewState state) {
  final fromUser = user.name.trim();
  if (fromUser.isNotEmpty) return fromUser;
  return (state.ownerName ?? '').trim();
}

/// Standalone finance header (purple gradient + search). When the Money tab is
/// embedded under [OwnerDashboardHeroTabScaffold], the shared hero is shown instead.
class FinanceTopHeader extends ConsumerWidget {
  const FinanceTopHeader({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ownerOverviewControllerProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final startAlign = isRtl
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final textAlign = isRtl ? TextAlign.right : TextAlign.left;

    final displayName = _resolveDisplayName(user, state);
    final formattedName = displayName.trim().toUpperCaseFirst();
    final headline = formattedName.isEmpty
        ? getGreeting(l10n)
        : '${getGreeting(l10n)}, $formattedName';
    final salonLabel = (state.salonName ?? '').trim();
    final salonTitle = salonLabel.isNotEmpty
        ? salonLabel
        : l10n.ownerDashboardTitle;
    final initials = _heroUserInitials(user.name);
    final photo = user.photoUrl?.trim();
    final unread = ref.watch(unreadNotificationCountProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 252),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FinanceDashboardColors.headerGradientStart,
                  FinanceDashboardColors.headerGradientMid,
                  FinanceDashboardColors.headerGradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    bottom: -30,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.12,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 40,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.08,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: startAlign,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.push(AppRoutes.settings),
                              customBorder: const CircleBorder(),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.22,
                                ),
                                backgroundImage:
                                    photo != null && photo.isNotEmpty
                                    ? CachedNetworkImageProvider(photo)
                                    : null,
                                child: photo == null || photo.isEmpty
                                    ? Text(
                                        initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: startAlign,
                              children: [
                                Text(
                                  headline,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: textAlign,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        salonTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: textAlign,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.78,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white.withValues(
                                        alpha: 0.82,
                                      ),
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _SquareHeaderIcon(
                            onTap: () =>
                                context.push(AppRoutes.ownerDashboardAssistant),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: FinanceDashboardColors.primaryPurple,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _SquareHeaderIcon(
                            onTap: () => context.push(AppRoutes.notifications),
                            light: true,
                            child: AppNotificationBadge(
                              count: unread,
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              context.push(AppRoutes.ownerBentoDashboard),
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.28),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search_rounded,
                                  color: Colors.white.withValues(alpha: 0.92),
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    l10n.moneyDashboardSearchHint,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: isRtl
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareHeaderIcon extends StatelessWidget {
  const _SquareHeaderIcon({
    required this.onTap,
    this.light = false,
    required this.child,
  });

  final VoidCallback onTap;
  final bool light;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: light ? Colors.white.withValues(alpha: 0.18) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: light ? 0.25 : 0),
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
