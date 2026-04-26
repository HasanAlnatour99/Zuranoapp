import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../employee_dashboard/application/employee_dashboard_providers.dart';
import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../../../employee_today/data/models/et_attendance_day.dart';
import '../../../employee_today/data/models/et_attendance_punch.dart';
import '../../../employee_today/providers/employee_today_providers.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../employee_today/presentation/widgets/employee_today_bottom_nav.dart';
import '../providers/employee_attendance_providers.dart';
import '../widgets/employee_attendance_greeting_card.dart';
import '../widgets/employee_attendance_header.dart';
import '../widgets/employee_attendance_overview_card.dart';
import '../widgets/employee_punch_action_card.dart';
import '../widgets/employee_recent_attendance_card.dart';
import '../widgets/employee_salon_location_card.dart';
import '../widgets/employee_today_status_card.dart';
import '../widgets/employee_today_timeline_card.dart';
import '../widgets/employee_attendance_shell.dart';

int _liveWorkedMinutes({
  required EtAttendanceDay? day,
  required List<EtAttendancePunch> punches,
  required DateTime now,
}) {
  if (day == null || punches.isEmpty) {
    return 0;
  }
  if (day.status == 'checkedOut') {
    return day.workedMinutes;
  }
  final sorted = List<EtAttendancePunch>.from(punches)
    ..sort((a, b) => a.punchTime.compareTo(b.punchTime));
  final last = sorted.last;
  var base = day.workedMinutes;
  if (last.type == AttendancePunchType.punchIn ||
      last.type == AttendancePunchType.breakIn) {
    base += now.difference(last.punchTime).inMinutes;
  }
  return base;
}

class EmployeeAttendanceScreen extends ConsumerStatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  ConsumerState<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState
    extends ConsumerState<EmployeeAttendanceScreen> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _snack(String m) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = GoRouterState.of(context).uri.path;
    final now = DateTime.now();
    final emp = ref.watch(workspaceEmployeeProvider);
    final settings = ref.watch(etAttendanceSettingsProvider);
    final day = ref.watch(etTodayAttendanceDayProvider);
    final punches = ref.watch(etTodayPunchesProvider);
    final recent = ref.watch(employeeRecentAttendanceDaysProvider);
    final monthly = ref.watch(employeeMonthlyAttendanceStatsProvider);
    final loc = ref.watch(employeeAttendanceLocationProvider);
    final busy = ref.watch(punchBusyTypeProvider);
    final salon = ref.watch(sessionSalonStreamProvider);

    final live = _liveWorkedMinutes(
      day: day.asData?.value,
      punches: punches.asData?.value ?? const [],
      now: now,
    );

    bool? zoneInside;
    double? zoneDist;
    final s0 = settings.asData?.value;
    final l0 = loc.asData?.value;
    if (s0 != null && s0.hasSalonLocationConfigured && l0?.position != null) {
      final p = l0!.position!;
      zoneDist = ref
          .read(locationAttendanceServiceProvider)
          .calculateDistanceMeters(
            salonLat: s0.salonLatitude!,
            salonLng: s0.salonLongitude!,
            userLat: p.latitude,
            userLng: p.longitude,
          );
      zoneInside = zoneDist <= s0.allowedRadiusMeters;
    }

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(gradient: zuranoAttendanceScreenGradient()),
        child: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(etTodayAttendanceDayProvider);
                  ref.invalidate(etTodayPunchesProvider);
                  ref.invalidate(employeeRecentAttendanceDaysProvider);
                  ref.invalidate(employeeMonthlyAttendanceStatsProvider);
                  ref.invalidate(employeeAttendanceLocationProvider);
                  await ref.read(employeeMonthlyAttendanceStatsProvider.future);
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          emp.when(
                            data: (e) => EmployeeAttendanceHeader(
                              employeeName:
                                  e?.name ?? l10n.employeeTodayTeamMemberFallback,
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 12),
                          emp.when(
                            data: (e) => EmployeeAttendanceGreetingCard(
                              employeeName:
                                  e?.name ?? l10n.employeeTodayTeamMemberFallback,
                              now: now,
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 16),
                          settings.when(
                            data: (s) => day.when(
                              data: (d) => punches.when(
                                data: (p) => EmployeeTodayStatusCard(
                                  settings: s,
                                  day: d,
                                  punches: p,
                                  now: now,
                                  liveWorkedMinutes: live,
                                ),
                                loading: () => const _LoadCard(),
                                error: (_, __) => const _ErrCard(),
                              ),
                              loading: () => const _LoadCard(),
                              error: (_, __) => const _ErrCard(),
                            ),
                            loading: () => const _LoadCard(),
                            error: (_, __) => const _ErrCard(),
                          ),
                          const SizedBox(height: 14),
                          settings.when(
                            data: (s) => day.when(
                              data: (d) => EmployeePunchActionCard(
                                settings: s,
                                day: d,
                                busyType: busy,
                                correctionAllowed:
                                    s.allowEmployeeCorrectionRequests,
                                onCorrection: () => context.push(
                                  AppRoutes.employeeAttendanceCorrectionNested,
                                ),
                                onPunch: (t) => submitEmployeeAttendancePunch(
                                  ref,
                                  t,
                                  onMessage: _snack,
                                ),
                              ),
                              loading: () => const _LoadCard(),
                              error: (_, __) => const _ErrCard(),
                            ),
                            loading: () => const _LoadCard(),
                            error: (_, __) => const _ErrCard(),
                          ),
                          const SizedBox(height: 14),
                          settings.when(
                            data: (s) => EmployeeSalonLocationCard(
                              settings: s,
                              salonName: salon.asData?.value?.name ??
                                  l10n.employeeTodaySalonLabel,
                              locationAsync: loc,
                              insideZone: zoneInside,
                              distanceMeters: zoneDist,
                              onRetryLocation: () {
                                ref.invalidate(
                                  employeeAttendanceLocationProvider,
                                );
                              },
                            ),
                            loading: () => const _LoadCard(),
                            error: (_, __) => const _ErrCard(),
                          ),
                          const SizedBox(height: 14),
                          settings.when(
                            data: (s) => day.when(
                              data: (d) => punches.when(
                                data: (p) => EmployeeTodayTimelineCard(
                                  settings: s,
                                  day: d,
                                  punches: p,
                                  correctionAllowed:
                                      s.allowEmployeeCorrectionRequests,
                                  onRequestCorrection: () => context.push(
                                    AppRoutes
                                        .employeeAttendanceCorrectionNested,
                                  ),
                                ),
                                loading: () => const _LoadCard(),
                                error: (_, __) => const _ErrCard(),
                              ),
                              loading: () => const _LoadCard(),
                              error: (_, __) => const _ErrCard(),
                            ),
                            loading: () => const _LoadCard(),
                            error: (_, __) => const _ErrCard(),
                          ),
                          const SizedBox(height: 14),
                          EmployeeAttendanceOverviewCard(
                            stats: monthly.asData?.value,
                            loading: monthly.isLoading,
                            error: monthly.error,
                            onRetry: () => ref.invalidate(
                              employeeMonthlyAttendanceStatsProvider,
                            ),
                            onViewCalendar: () => context.push(
                              AppRoutes.employeeAttendanceCalendar,
                            ),
                          ),
                          const SizedBox(height: 14),
                          EmployeeRecentAttendanceCard(
                            days: recent.asData?.value ?? const [],
                            loading: recent.isLoading,
                            error: recent.error,
                            onRetry: () => ref.invalidate(
                              employeeRecentAttendanceDaysProvider,
                            ),
                            onSeeAll: () => context.push(
                              AppRoutes.employeeAttendanceCalendar,
                            ),
                            onOpenDay: (d) => context.push(
                              '${AppRoutes.employeeAttendance}/${d.id}',
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: EmployeeTodayBottomNav(currentPath: path),
    );
  }
}

class _LoadCard extends StatelessWidget {
  const _LoadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: zuranoAttendanceCardDecoration(),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _ErrCard extends StatelessWidget {
  const _ErrCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: zuranoAttendanceCardDecoration(),
      child: Text(l10n.employeeAttendanceLoadError),
    );
  }
}
