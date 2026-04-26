import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_leading_back.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/user_notification_prefs.dart';
import '../../logic/notification_preferences_controller.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(notificationPreferencesControllerProvider);
    final notifier = ref.read(
      notificationPreferencesControllerProvider.notifier,
    );

    Future<void> update(UserNotificationPrefs next) async {
      await notifier.persist(next);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeadingBack(),
        automaticallyImplyLeading: false,
        title: Text(l10n.notificationsPreferencesTitle),
      ),
      body: AppFadeIn(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.large),
          children: [
            AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.notificationsPrefPushMaster),
                    value: prefs.pushEnabled,
                    onChanged: (v) => update(prefs.copyWith(pushEnabled: v)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.notificationsPrefBookingReminders),
                    value: prefs.bookingReminders,
                    onChanged: (v) =>
                        update(prefs.copyWith(bookingReminders: v)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.notificationsPrefBookingChanges),
                    value: prefs.bookingChanges,
                    onChanged: (v) => update(prefs.copyWith(bookingChanges: v)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.notificationsPrefPayroll),
                    value: prefs.payrollAlerts,
                    onChanged: (v) => update(prefs.copyWith(payrollAlerts: v)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.notificationsPrefViolations),
                    value: prefs.violationAlerts,
                    onChanged: (v) =>
                        update(prefs.copyWith(violationAlerts: v)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.notificationsPrefMarketing),
                    subtitle: Text(l10n.notificationsPrefMarketingHint),
                    value: prefs.marketingEnabled,
                    onChanged: (v) =>
                        update(prefs.copyWith(marketingEnabled: v)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
