import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_countries.dart';
import '../../../../core/utils/contact_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../employees/data/models/employee.dart';
import '../../../salon/data/models/salon.dart';
import '../../../team/data/models/team_member_model.dart';
import '../../../team/data/models/team_member_today_summary_model.dart';
import '../../../team/presentation/widgets/team_member_action_row.dart';
import '../../../team/presentation/widgets/team_member_info_section.dart';
import '../../../team/presentation/widgets/team_member_profile_header.dart';
import '../../../team/presentation/widgets/team_member_summary_cards.dart';
import '../../../team/providers/team_member_profile_providers.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../logic/team_management_providers.dart';

/// Premium profile overview for a salon team member (Firestore-backed).
class BarberOverviewTab extends ConsumerWidget {
  const BarberOverviewTab({
    super.key,
    required this.data,
    required this.currencyCode,
  });

  final BarberDetailsData data;
  final String currencyCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final salonAsync = ref.watch(sessionSalonStreamProvider);
    final salon = salonAsync.asData?.value;
    final dialDigits = _dialDigitsForSalon(salon);

    final args = TeamMemberProfileArgs(
      salonId: data.employee.salonId,
      employeeId: data.employee.id,
      currencyCode: currencyCode,
    );

    final memberAsync = ref.watch(teamMemberProfileStreamProvider(args));
    final member =
        memberAsync.asData?.value ??
        TeamMemberModel.fromEmployee(data.employee, currencyCode: currencyCode);

    final summaryAsync = ref.watch(teamMemberTodaySummaryProvider(args));
    final phoneForContact = member.phoneE164 ?? member.phone;
    final canContact =
        phoneForContact != null && phoneForContact.trim().isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(teamMemberTodaySummaryProvider(args));
        ref.invalidate(teamMemberProfileStreamProvider(args));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TeamMemberProfileHeader(
              member: member,
              l10n: l10n,
              localeName: locale,
            ),
            const SizedBox(height: 16),
            TeamMemberActionRow(
              canContact: canContact,
              canBook: member.canBeBooked,
              callLabel: l10n.teamProfileActionCall,
              whatsappLabel: l10n.customerDetailsWhatsApp,
              bookingLabel: l10n.teamProfileActionAddBooking,
              onCall: () => ContactLauncher.callPhone(
                context,
                member.phoneE164 ?? member.phone,
                unavailableMessage: l10n.teamProfilePhoneMissingSnack,
                launchErrorMessage: l10n.teamProfileDialerErrorSnack,
              ),
              onWhatsApp: () => ContactLauncher.openWhatsApp(
                context,
                member.phoneE164 ?? member.phone,
                message: '${l10n.teamProfileActionCall} ${member.fullName}',
                defaultCountryCallingCode: dialDigits,
                unavailableMessage: l10n.teamProfilePhoneMissingSnack,
                unavailableAppMessage: l10n.teamProfileWhatsAppUnavailableSnack,
              ),
              onAddBooking: () {
                if (!member.canBeBooked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.teamProfileBookingUnavailableSnack),
                    ),
                  );
                  return;
                }
                context.push(
                  '${AppRoutes.bookingsNew}?barberId=${Uri.encodeComponent(member.employeeId)}',
                );
              },
            ),
            const SizedBox(height: 16),
            summaryAsync.when(
              loading: () => TeamMemberSummaryCards.loading(
                salesTitle: l10n.teamProfileTodaySalesLabel,
                servicesTitle: l10n.teamProfileServicesLabel,
                attendanceTitle: l10n.teamProfileAttendanceLabel,
              ),
              error: (_, _) => TeamMemberSummaryCards.error(
                salesTitle: l10n.teamProfileTodaySalesLabel,
                servicesTitle: l10n.teamProfileServicesLabel,
                attendanceTitle: l10n.teamProfileAttendanceLabel,
              ),
              data: (summary) => TeamMemberSummaryCards(
                todaySales: summary.todaySales,
                servicesCount: summary.servicesCount,
                attendanceLabel: _attendanceSummaryLabel(l10n, member, summary),
                currencyCode: member.currencyCode,
                salesTitle: l10n.teamProfileTodaySalesLabel,
                servicesTitle: l10n.teamProfileServicesLabel,
                attendanceTitle: l10n.teamProfileAttendanceLabel,
              ),
            ),
            const SizedBox(height: 18),
            TeamMemberInfoSection(
              title: l10n.teamProfileSectionContact,
              rows: [
                TeamMemberInfoRowData(
                  icon: Icons.phone_outlined,
                  label: l10n.teamFieldPhone,
                  value: member.phone?.trim().isNotEmpty == true
                      ? member.phone!.trim()
                      : l10n.teamValueNotAvailable,
                  trailingIcon: Icons.phone_outlined,
                  showChevron: false,
                  onTap: () => ContactLauncher.callPhone(
                    context,
                    member.phoneE164 ?? member.phone,
                    unavailableMessage: l10n.teamProfilePhoneMissingSnack,
                    launchErrorMessage: l10n.teamProfileDialerErrorSnack,
                  ),
                ),
                TeamMemberInfoRowData(
                  icon: Icons.email_outlined,
                  label: l10n.teamFieldEmail,
                  value: () {
                    final e = member.email?.trim() ?? '';
                    return e.isNotEmpty ? e : l10n.teamValueNotAvailable;
                  }(),
                  showChevron: false,
                ),
              ],
            ),
            const SizedBox(height: 18),
            TeamMemberInfoSection(
              title: l10n.teamProfileSectionWorkSettings,
              rows: [
                TeamMemberInfoRowData(
                  icon: Icons.event_available_outlined,
                  label: l10n.teamFieldAttendanceRequired,
                  value: member.attendanceRequired
                      ? l10n.teamValueYes
                      : l10n.teamValueNo,
                  showChevron: true,
                ),
                TeamMemberInfoRowData(
                  icon: Icons.percent_outlined,
                  label: l10n.teamDetailsCommissionRate,
                  value: _commissionSummary(l10n, locale, data.employee),
                  showChevron: true,
                ),
                TeamMemberInfoRowData(
                  icon: Icons.calendar_month_outlined,
                  label: l10n.teamDetailsBookableLater,
                  value: member.bookableLater
                      ? l10n.teamValueEnabled
                      : l10n.teamValueDisabled,
                  showChevron: true,
                ),
                TeamMemberInfoRowData(
                  icon: Icons.person_outline,
                  label: l10n.teamDetailsStatusLabel,
                  value: _workSettingsStatusLabel(l10n, member),
                  valueColor: member.isActive && !member.isFrozen
                      ? const Color(0xFF16A34A)
                      : null,
                  showChevron: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _workSettingsStatusLabel(
    AppLocalizations l10n,
    TeamMemberModel member,
  ) {
    if (member.isFrozen) return l10n.teamProfileStatusFrozen;
    if (!member.isActive) return l10n.teamStatusInactive;
    return l10n.teamStatusActive;
  }

  static String _attendanceSummaryLabel(
    AppLocalizations l10n,
    TeamMemberModel member,
    TeamMemberTodaySummaryModel summary,
  ) {
    if (!member.attendanceRequired) {
      return l10n.teamProfileAttendanceNotRequiredSummary;
    }
    return switch (summary.attendanceDay) {
      TeamMemberAttendanceDaySummary.notCheckedIn =>
        l10n.teamMemberNotCheckedIn,
      TeamMemberAttendanceDaySummary.checkedIn => l10n.teamStatusCheckedIn,
      TeamMemberAttendanceDaySummary.checkedOut => l10n.barberAttendanceOut,
      TeamMemberAttendanceDaySummary.absent =>
        l10n.barberAttendanceStatusAbsent,
    };
  }

  static String? _dialDigitsForSalon(Salon? salon) {
    final code = salon?.countryCode?.trim();
    if (code == null || code.isEmpty) return null;
    final upper = code.toUpperCase();
    for (final c in AppCountries.choices) {
      if (c.code.toUpperCase() == upper) {
        return c.dialCode.replaceAll(RegExp(r'\D'), '');
      }
    }
    return null;
  }

  static String _commissionSummary(
    AppLocalizations l10n,
    String localeName,
    Employee employee,
  ) {
    final nf = NumberFormat.decimalPattern(localeName);
    switch (employee.commissionType) {
      case EmployeeCommissionTypes.percentage:
        return l10n.teamCommissionPercentValue(
          employee.resolvedCommissionPercentage.toStringAsFixed(0),
        );
      case EmployeeCommissionTypes.fixed:
        return l10n.teamCommissionSummaryFixed(
          nf.format(employee.resolvedCommissionFixedAmount),
        );
      case EmployeeCommissionTypes.percentagePlusFixed:
        return l10n.teamCommissionSummaryMixed(
          employee.resolvedCommissionPercentage.toStringAsFixed(0),
          nf.format(employee.resolvedCommissionFixedAmount),
        );
      default:
        return l10n.teamValueNotAvailable;
    }
  }
}
