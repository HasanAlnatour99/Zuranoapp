import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/text/personalized_greeting.dart';
import '../../../../../core/widgets/app_notification_badge.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/notification_providers.dart';
import '../../../../users/data/models/app_user.dart';
import '../../../logic/owner_overview_controller.dart';
import '../../../logic/owner_overview_state.dart';

/// Matches overview body canvas (light purple-gray).
const Color kOwnerDashboardHeroCanvas = Color(0xFFF7F4FF);

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

Widget _buildAiHeroButton(BuildContext context, AppLocalizations l10n) {
  return Tooltip(
    message: l10n.ownerAiAssistantTooltip,
    child: InkWell(
      onTap: () => context.push(AppRoutes.ownerDashboardAssistant),
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Color(0xFF7B3FF2),
          size: 24,
        ),
      ),
    ),
  );
}

Widget _buildHeroNotificationButton({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
}) {
  final unread = ref.watch(unreadNotificationCountProvider);
  return Tooltip(
    message: l10n.notificationsInboxTooltip,
    child: InkWell(
      onTap: () => context.push(AppRoutes.notifications),
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Center(
          child: AppNotificationBadge(
            count: unread,
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildOwnerQuickActionBar(BuildContext context, AppLocalizations l10n) {
  final isRtl = Directionality.of(context) == TextDirection.rtl;

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => context.push(AppRoutes.ownerBentoDashboard),
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.manage_search_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.ownerOverviewHeroSearchHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Purple gradient hero (greeting, salon, AI, notifications, quick search) used on
/// owner overview and other owner shell tabs (Team, Customers, Finance).
class OwnerDashboardHeroHeader extends ConsumerWidget {
  const OwnerDashboardHeroHeader({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ownerOverviewControllerProvider);
    final salonLabel = (state.salonName ?? '').trim();
    return _buildOwnerHeroHeader(
      context: context,
      ref: ref,
      user: user,
      state: state,
      l10n: l10n,
      salonLabel: salonLabel,
    );
  }
}

Widget _buildOwnerHeroHeader({
  required BuildContext context,
  required WidgetRef ref,
  required AppUser user,
  required OwnerOverviewState state,
  required AppLocalizations l10n,
  required String salonLabel,
}) {
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  final displayName = _resolveDisplayName(user, state);
  final formattedName = displayName.trim().toUpperCaseFirst();
  final headline = formattedName.isEmpty
      ? getGreeting(l10n)
      : '${getGreeting(l10n)}, $formattedName';
  final trimmedSalon = salonLabel.trim();
  final salonTitle = trimmedSalon.isNotEmpty
      ? trimmedSalon
      : l10n.ownerDashboardTitle;
  final initials = _heroUserInitials(user.name);
  final photo = user.photoUrl?.trim();

  final startAlign = isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  final textAlign = isRtl ? TextAlign.right : TextAlign.left;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF5B2BE0), Color(0xFF7B3FF2), Color(0xFFA77BFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(34),
        bottomRight: Radius.circular(34),
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: Column(
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
                    radius: 26,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    backgroundImage: photo != null && photo.isNotEmpty
                        ? CachedNetworkImageProvider(photo)
                        : null,
                    child: photo == null || photo.isEmpty
                        ? Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 14),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            salonTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: textAlign,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white.withValues(alpha: 0.82),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildAiHeroButton(context, l10n),
              const SizedBox(width: 8),
              _buildHeroNotificationButton(
                context: context,
                ref: ref,
                l10n: l10n,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildOwnerQuickActionBar(context, l10n),
        ],
      ),
    ),
  );
}

/// Owner shell tab layout: hero + overlapping scroll body (same as overview).
class OwnerDashboardHeroTabScaffold extends StatelessWidget {
  const OwnerDashboardHeroTabScaffold({
    super.key,
    required this.user,
    required this.body,
    this.bodyScaffoldBackgroundColor,
    this.enableBodyOverlap = true,
  });

  final AppUser user;
  final Widget body;

  /// When set (e.g. Finance tab), tints the scroll canvas under the hero.
  final Color? bodyScaffoldBackgroundColor;
  final bool enableBodyOverlap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyScaffoldBackgroundColor ?? kOwnerDashboardHeroCanvas,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OwnerDashboardHeroHeader(user: user),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, enableBodyOverlap ? -18 : 0),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
