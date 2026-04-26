import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/constants/app_countries.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/booking_statuses.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/bookings/data/models/booking.dart';
import '../../../../features/users/data/models/app_user.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/app_settings_providers.dart'
    show appLocalePreferenceProvider;
import '../../../../providers/customer_salon_streams_provider.dart';
import '../../../../providers/onboarding_providers.dart';
import '../../../../providers/session_provider.dart';
import '../widgets/zurano/app_settings_actions_card.dart';
import '../widgets/zurano/country_dropdown_card.dart';
import '../widgets/zurano/language_option_tile.dart';
import '../widgets/zurano/settings_section_card.dart';
import '../widgets/zurano/zurano_info_banner.dart';
import '../widgets/zurano/zurano_page_scaffold.dart';
import '../widgets/zurano/zurano_top_bar.dart';
import '../utils/zurano_sign_out_dialog.dart';
import '../../../../core/widgets/customer_app_footer.dart';
import '../../../../core/widgets/customer_profile_header_card.dart';
import '../../../../core/widgets/customer_settings_tile_card.dart';
import '../../../../core/widgets/customer_stats_strip_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

({int total, int salons, int upcoming}) _customerBookingStatCounts(
  List<Booking> bookings,
) {
  final now = DateTime.now().toUtc();
  final kept = bookings
      .where((b) => b.status != BookingStatuses.cancelled)
      .toList(growable: false);
  final total = kept.length;
  final salons = kept.map((b) => b.salonId).toSet().length;
  final upcoming = kept.where((b) {
    if (b.status == BookingStatuses.cancelled) {
      return false;
    }
    if (!(b.status == BookingStatuses.pending ||
        b.status == BookingStatuses.confirmed ||
        b.status == BookingStatuses.rescheduled)) {
      return false;
    }
    return b.startAt.toUtc().isAfter(now);
  }).length;
  return (total: total, salons: salons, upcoming: upcoming);
}

/// Language + country (local prefs). Works signed in or out.
class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  bool _showInfoBanner = true;

  void _onSettingsBack(BuildContext context, AppUser? user) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final role = user?.role.trim() ?? '';
    if (role == UserRoles.owner || role == UserRoles.admin) {
      context.go(AppRoutes.ownerOverview);
    } else {
      context.go(AppRoutes.roleSelection);
    }
  }

  Future<void> _pickCountry(BuildContext context, String? currentCode) async {
    final l10n = AppLocalizations.of(context)!;
    final uiLocale = Localizations.localeOf(context);
    final onboarding = ref.read(onboardingPrefsProvider);
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.appSettingsCountrySection,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              for (final country in AppCountries.choices)
                ListTile(
                  title: Text(
                    uiLocale.languageCode == 'ar'
                        ? country.nameAr
                        : country.nameEn,
                  ),
                  trailing: currentCode == country.code
                      ? Icon(
                          Icons.check_rounded,
                          color: Theme.of(ctx).colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(ctx).pop(country.code),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !context.mounted) {
      return;
    }
    final notifier = ref.read(onboardingPrefsProvider.notifier);
    if (onboarding.countryCompleted) {
      await notifier.updateCountryCode(picked);
    } else {
      await notifier.completeCountrySelection(picked);
    }
  }

  Widget? _customerProfileArea(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final sessionAsync = ref.watch(sessionUserProvider);
    final bookingsAsync = ref.watch(customerBookingsForProfileStreamProvider);
    return sessionAsync.maybeWhen(
      data: (u) {
        if (u == null || u.role != UserRoles.customer) {
          return null;
        }
        final stats = bookingsAsync.when(
          data: _customerBookingStatCounts,
          loading: () => (total: 0, salons: 0, upcoming: 0),
          error: (_, _) => (total: 0, salons: 0, upcoming: 0),
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.customerProfileTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: ZuranoPremiumUiColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CustomerProfileHeaderCard(displayName: u.name, email: u.email),
            const SizedBox(height: 16),
            CustomerStatsStripCard(
              items: [
                CustomerStatStripItem(
                  value: '${stats.total}',
                  label: l10n.customerStatBookings,
                ),
                CustomerStatStripItem(
                  value: '${stats.salons}',
                  label: l10n.customerStatSalonsVisited,
                ),
                CustomerStatStripItem(
                  value: '${stats.upcoming}',
                  label: l10n.customerStatUpcoming,
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomerSettingsGroupCard(
              children: [
                CustomerSettingsTile(
                  icon: AppIcons.notifications_outlined,
                  title: l10n.customerNotificationsTooltip,
                  subtitle: l10n.customerSettingsTileNotificationsSubtitle,
                  onTap: () => context.push(AppRoutes.notifications),
                ),
                CustomerSettingsTile(
                  icon: AppIcons.event_note_outlined,
                  title: l10n.customerMyBookings,
                  subtitle: l10n.customerSettingsTileBookingsSubtitle,
                  onTap: () => context.push(AppRoutes.customerMyBookings),
                ),
              ],
            ),
          ],
        );
      },
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = ref.watch(appLocalePreferenceProvider);
    final onboarding = ref.watch(onboardingPrefsProvider);
    final uiLocale = Localizations.localeOf(context);
    final sessionAsync = ref.watch(sessionUserProvider);
    final user = sessionAsync.asData?.value;

    final languageOptions = <(Locale locale, String label)>[
      (const Locale('en'), l10n.onboardingLanguageEnglish),
      (const Locale('ar'), l10n.onboardingLanguageArabic),
    ];

    String countryLabel() {
      final code = onboarding.countryCode;
      if (code == null || !AppCountries.choices.any((c) => c.code == code)) {
        return l10n.appSettingsCountryLabel;
      }
      final row = AppCountries.choices.firstWhere((c) => c.code == code);
      return uiLocale.languageCode == 'ar' ? row.nameAr : row.nameEn;
    }

    final customerArea = _customerProfileArea(context, l10n, theme);

    /// Single entry for zone + punch rules + grace + corrections + violations.
    final attendanceSettingsTile = sessionAsync.maybeWhen(
      data: (AppUser? u) {
        if (u == null) {
          return null;
        }
        final salonOk = u.salonId != null && u.salonId!.trim().isNotEmpty;
        final canManage =
            u.role == UserRoles.owner || u.role == UserRoles.admin;
        if (!canManage || !salonOk) {
          return null;
        }
        return SettingsOptionTile(
          icon: Icons.fact_check_outlined,
          title: l10n.ownerAttendanceSettingsTitle,
          subtitle: l10n.ownerAttendanceSettingsSubtitle,
          onTap: () => context.pushNamed(AppRouteNames.ownerAttendanceSettings),
        );
      },
      orElse: () => null,
    );

    final customerBookingTile = sessionAsync.maybeWhen(
      data: (AppUser? u) {
        if (u == null) {
          return null;
        }
        final salonOk = u.salonId != null && u.salonId!.trim().isNotEmpty;
        final canManage =
            u.role == UserRoles.owner || u.role == UserRoles.admin;
        if (!canManage || !salonOk) {
          return null;
        }
        return SettingsOptionTile(
          icon: Icons.calendar_month_outlined,
          title: l10n.ownerCustomerBookingTileTitle,
          subtitle: l10n.ownerCustomerBookingTileSubtitle,
          onTap: () => context.push(AppRoutes.ownerSettingsCustomerBooking),
        );
      },
      orElse: () => null,
    );

    final ownerSettingsTiles = <Widget>[
      ?customerBookingTile,
      ?attendanceSettingsTile,
    ];

    final accountActionChildren = <Widget>[
      if (sessionAsync.hasValue && sessionAsync.value != null)
        SettingsOptionTile(
          icon: Icons.logout_rounded,
          title: l10n.customerSignOut,
          subtitle: l10n.signOutSubtitle,
          danger: true,
          showChevron: false,
          onTap: () => unawaited(showZuranoSignOutConfirmDialog(context)),
        ),
      SettingsOptionTile(
        icon: Icons.info_outline_rounded,
        title: l10n.appSettingsMoreSectionTitle,
        subtitle: l10n.appSettingsMoreActionSubtitle,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.appSettingsMoreSectionBody)),
          );
        },
      ),
    ];

    final body = CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ZuranoTopBar(
            title: l10n.appSettingsTitle,
            onBack: () => _onSettingsBack(context, user),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                l10n.appSettingsIntroBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: ZuranoPremiumUiColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              if (customerArea != null) ...[
                customerArea,
                const SizedBox(height: 20),
              ],
              if (ownerSettingsTiles.isNotEmpty) ...[
                AppSettingsActionsCard(children: ownerSettingsTiles),
                const SizedBox(height: 16),
              ],
              SettingsSectionCard(
                icon: Icons.language_rounded,
                title: l10n.appSettingsLanguageSection,
                subtitle: l10n.appSettingsLanguageSubtitle,
                child: Column(
                  children: [
                    for (var i = 0; i < languageOptions.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      LanguageOptionTile(
                        title: languageOptions[i].$2,
                        selected: locale == languageOptions[i].$1,
                        onTap: () {
                          ref
                              .read(appLocalePreferenceProvider.notifier)
                              .setLocale(languageOptions[i].$1);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SettingsSectionCard(
                icon: Icons.location_on_outlined,
                title: l10n.appSettingsCountrySection,
                subtitle: l10n.appSettingsCountrySubtitle,
                child: CountryDropdownCard(
                  label: countryLabel(),
                  onTap: () =>
                      unawaited(_pickCountry(context, onboarding.countryCode)),
                ),
              ),
              const SizedBox(height: 16),
              if (_showInfoBanner) ...[
                ZuranoInfoBanner(
                  text: l10n.appSettingsChangeAnytimeBanner,
                  onClose: () => setState(() => _showInfoBanner = false),
                ),
                const SizedBox(height: 16),
              ],
              AppSettingsActionsCard(children: accountActionChildren),
              const SizedBox(height: 24),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snap) {
                  final v = snap.data?.version ?? '1.0.0';
                  return Center(
                    child: CustomerAppFooter(
                      text: l10n.customerAppFooterVersion(l10n.appTitle, v),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: ZuranoPremiumUiColors.background,
      body: SafeArea(child: ZuranoPageScaffold(child: body)),
    );
  }
}
