import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../shared/widgets/zurano_add_sale_fab.dart';
import '../../../../providers/session_provider.dart';
import '../../../employee_dashboard/application/employee_dashboard_providers.dart';
import '../../../employee_dashboard/data/models/attendance_event_model.dart';
import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../../../employee_dashboard/domain/services/attendance_location_service.dart';
import '../../../employee_dashboard/presentation/widgets/salon_zone_map_preview.dart';
import '../../../employee_dashboard/presentation/widgets/today_activity_timeline.dart';
import '../../../sales/presentation/providers/salon_sales_settings_provider.dart';
import '../../data/attendance_exception.dart';
import '../../data/models/et_attendance_day.dart';
import '../../data/models/et_attendance_settings.dart';
import '../../providers/employee_today_providers.dart';
import '../employee_today_theme.dart';
import '../widgets/employee_today_bottom_nav.dart';
import '../widgets/employee_today_widgets.dart';

class EmployeeTodayScreen extends ConsumerStatefulWidget {
  const EmployeeTodayScreen({super.key});

  @override
  ConsumerState<EmployeeTodayScreen> createState() =>
      _EmployeeTodayScreenState();
}

class _EmployeeTodayScreenState extends ConsumerState<EmployeeTodayScreen> {
  final _location = AttendanceLocationService();
  LatLng? _empPos;
  bool? _inside;
  double? _distM;
  AttendancePunchType? _busy;

  String _punchLabel(AppLocalizations l10n, AttendancePunchType t) {
    switch (t) {
      case AttendancePunchType.punchIn:
        return l10n.employeeTodayPunchIn;
      case AttendancePunchType.punchOut:
        return l10n.employeeTodayPunchOut;
      case AttendancePunchType.breakOut:
        return l10n.employeeTodayBreakOut;
      case AttendancePunchType.breakIn:
        return l10n.employeeTodayBreakIn;
    }
  }

  Future<void> _syncLocation(EtAttendanceSettings s) async {
    try {
      final p = await _location.getCurrentPosition();
      if (!mounted) {
        return;
      }
      setState(() {
        _empPos = LatLng(p.latitude, p.longitude);
        if (s.hasSalonLocationConfigured) {
          _distM = _location.calculateDistanceMeters(
            fromLat: p.latitude,
            fromLng: p.longitude,
            toLat: s.salonLatitude!,
            toLng: s.salonLongitude!,
          );
          _inside = _location.isInsideZone(
            employeeLat: p.latitude,
            employeeLng: p.longitude,
            salonLat: s.salonLatitude!,
            salonLng: s.salonLongitude!,
            radiusMeters: s.allowedRadiusMeters.toDouble(),
          );
        }
      });
    } on Object catch (_) {
      if (mounted) {
        setState(() {
          _empPos = null;
          _inside = null;
          _distM = null;
        });
      }
    }
  }

  Future<void> _punch(AttendancePunchType type) async {
    final online = ref.read(connectivityStatusProvider).asData?.value ?? true;
    if (!online) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.employeeTodayOfflinePunch)));
      }
      return;
    }

    final scope = ref.read(employeeWorkspaceScopeProvider);
    final emp = await ref.read(workspaceEmployeeProvider.future);
    final user = ref.read(sessionUserProvider).asData?.value;
    if (scope == null || emp == null || user == null) {
      return;
    }

    final settings = await ref.read(etAttendanceSettingsProvider.future);

    setState(() => _busy = type);
    try {
      Position? pos;
      if (emp.attendanceRequired && settings.gpsRequired) {
        pos = await _location.getCurrentPosition();
      } else {
        try {
          pos = await _location.getCurrentPosition();
        } on Object {
          pos = null;
        }
      }

      await ref
          .read(employeeTodayAttendanceRepositoryProvider)
          .createPunch(
            uid: user.uid,
            salonId: scope.salonId,
            employeeId: scope.employeeId,
            employeeName: emp.name,
            employeeActive: emp.isActive,
            attendanceRequired: emp.attendanceRequired,
            type: type,
            position: pos,
            settings: settings,
          );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.employeeTodayPunchRecorded(_punchLabel(l10n, type)),
            ),
          ),
        );
      }
      await _syncLocation(settings);
    } on AttendanceException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              e.message ?? AppLocalizations.of(context)!.employeeRequestFailed,
            ),
          ),
        );
      }
    } on Object catch (e) {
      final msg = e.toString();
      if (msg.contains('permanently denied') && mounted) {
        await openAppSettings();
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = null);
      }
    }
  }

  List<Widget> _actionButtons(
    AppLocalizations l10n,
    EtAttendanceDay? day,
    EtAttendanceSettings s,
  ) {
    final seq = day?.punchSequence ?? const <String>[];
    if (seq.isEmpty) {
      return [
        EtPrimaryGradientButton(
          label: _punchLabel(l10n, AttendancePunchType.punchIn),
          icon: Icons.login_rounded,
          loading: _busy == AttendancePunchType.punchIn,
          onPressed: () => _punch(AttendancePunchType.punchIn),
        ),
      ];
    }
    if (seq.last == AttendancePunchType.punchOut.name) {
      return [
        Text(
          l10n.employeeTodayCompletedForToday,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: EmployeeTodayColors.deepText,
          ),
        ),
      ];
    }
    if (seq.last == AttendancePunchType.breakOut.name) {
      return [
        EtPrimaryGradientButton(
          label: _punchLabel(l10n, AttendancePunchType.breakIn),
          icon: Icons.coffee_rounded,
          loading: _busy == AttendancePunchType.breakIn,
          onPressed: () => _punch(AttendancePunchType.breakIn),
        ),
      ];
    }
    return [
      EtPrimaryGradientButton(
        label: _punchLabel(l10n, AttendancePunchType.punchOut),
        icon: Icons.logout_rounded,
        loading: _busy == AttendancePunchType.punchOut,
        onPressed: () => _punch(AttendancePunchType.punchOut),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: _busy != null
            ? null
            : () => _punch(AttendancePunchType.breakOut),
        icon: const Icon(Icons.free_breakfast_outlined),
        label: Text(_punchLabel(l10n, AttendancePunchType.breakOut)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final settingsAsync = ref.watch(etAttendanceSettingsProvider);
    final dayAsync = ref.watch(etTodayAttendanceDayProvider);
    final punchesAsync = ref.watch(etTodayPunchesProvider);
    final summaryAsync = ref.watch(employeeTodaySummaryProvider);
    final correctionsAsync = ref.watch(etEmployeeCorrectionRequestsProvider);
    final empAsync = ref.watch(workspaceEmployeeProvider);
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(sessionUserProvider).asData?.value;
    final salesPosSettings = ref
        .watch(salonSalesSettingsStreamProvider)
        .asData
        ?.value;
    final showAddSaleFab =
        session != null &&
        (salesPosSettings?.allowEmployeeAddSale ?? true) &&
        session.role.trim() != UserRoles.readonly;

    return Scaffold(
      backgroundColor: EmployeeTodayColors.backgroundSoft,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showAddSaleFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 88),
              child: ZuranoAddSaleFab(
                heroTag: 'employee_add_sale_fab_today',
                onPressed: () => context.pushNamed(
                  AppRouteNames.addSale,
                  queryParameters: const {'source': 'employee'},
                ),
              ),
            )
          : null,
      bottomNavigationBar: EmployeeTodayBottomNav(currentPath: path),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(etTodayAttendanceDayProvider);
            ref.invalidate(etTodayPunchesProvider);
            ref.invalidate(employeeTodaySummaryProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
                  child: empAsync.when(
                    data: (e) => Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: EmployeeTodayColors.primaryPurple
                              .withValues(alpha: 0.15),
                          child: Text(
                            (e?.name.isNotEmpty == true)
                                ? e!.name.substring(0, 1).toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: EmployeeTodayColors.primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e?.name ?? l10n.employeeTodayTeamMemberFallback,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: EmployeeTodayColors.deepText,
                                ),
                              ),
                              Text(
                                l10n.employeeTodayWorkspaceSubtitle,
                                style: const TextStyle(
                                  color: EmployeeTodayColors.mutedText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.push(AppRoutes.notifications),
                          icon: const Icon(Icons.notifications_none_rounded),
                        ),
                        IconButton(
                          onPressed: () => context.push(AppRoutes.settings),
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      ],
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: settingsAsync.when(
                    data: (s) {
                      return dayAsync.when(
                        data: (day) {
                          final statusLabel = day == null
                              ? l10n.employeeTodayStatusNotCheckedIn
                              : (day.status == 'checkedOut'
                                    ? l10n.employeeTodayStatusCheckedOut
                                    : day.status == 'onBreak'
                                    ? l10n.employeeTodayStatusOnBreak
                                    : day.status == 'notStarted'
                                    ? l10n.employeeTodayStatusNotCheckedIn
                                    : l10n.employeeTodayStatusCheckedIn);
                          final chips = <Widget>[
                            EtStatusChip(
                              icon: Icons.fact_check_rounded,
                              label: statusLabel,
                              color: EmployeeTodayColors.success,
                            ),
                            const SizedBox(width: 8),
                            EtStatusChip(
                              icon: Icons.location_on_outlined,
                              label: _inside == true
                                  ? l10n.employeeTodayZoneInside
                                  : l10n.employeeTodayZoneOutside,
                              color: _inside == true
                                  ? EmployeeTodayColors.success
                                  : EmployeeTodayColors.amber,
                            ),
                          ];
                          return Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  EmployeeTodayColors.heroGradientStart,
                                  EmployeeTodayColors.heroGradientEnd,
                                ],
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 22,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: EmployeeTodayColors.cardBorder,
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.employeeTodayAttendanceTitle,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.employeeTodayAttendanceTagline,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: chips,
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => context.push(
                                        AppRoutes.employeeAttendancePolicy,
                                      ),
                                      icon: const Icon(
                                        Icons.policy_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: Text(
                                        l10n.employeeTodayViewPolicy,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: _actionButtons(l10n, day, s),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () => const EtPremiumCard(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => EtPremiumCard(child: Text('$e')),
                      );
                    },
                    loading: () => const EtPremiumCard(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => EtPremiumCard(child: Text('$e')),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: settingsAsync.maybeWhen(
                    data: (s) {
                      if (!s.hasSalonLocationConfigured) {
                        return EtPremiumCard(
                          child: Text(l10n.employeeTodaySalonLocationMissing),
                        );
                      }
                      return EtPremiumCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: SalonZoneMapPreview(
                                salonLat: s.salonLatitude!,
                                salonLng: s.salonLongitude!,
                                radiusMeters: s.allowedRadiusMeters.toDouble(),
                                employeeLat: _empPos?.latitude,
                                employeeLng: _empPos?.longitude,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.employeeTodaySalonLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    s.salonAddress?.trim().isNotEmpty == true
                                        ? s.salonAddress!.trim()
                                        : l10n.employeeTodayAddressOnFile,
                                    style: const TextStyle(
                                      color: EmployeeTodayColors.mutedText,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (_distM != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.employeeTodayDistanceMeters(
                                        _distM!.round(),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: EtPremiumCard(
                    child: Row(
                      children: [
                        const Icon(Icons.edit_document, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.employeeTodayAttendanceRequestTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.employeeTodayAttendanceRequestSubtitle,
                                style: const TextStyle(
                                  color: EmployeeTodayColors.mutedText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        correctionsAsync.when(
                          data: (list) {
                            final pending = list
                                .where((r) => r.status == 'pending')
                                .length;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => context.push(
                                    AppRoutes
                                        .employeeAttendanceCorrectionNested,
                                  ),
                                  child: Text(
                                    l10n.employeeTodayRequestCorrection,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.employeeTodayPendingCount(pending),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: EmployeeTodayColors.mutedText,
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: summaryAsync.when(
                    data: (sum) {
                      final hours = dayAsync.maybeWhen(
                        data: (d) => d == null
                            ? '0.0'
                            : (d.workedMinutes / 60).toStringAsFixed(1),
                        orElse: () => '0.0',
                      );
                      return Row(
                        children: [
                          Expanded(
                            child: EtPremiumCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.schedule, size: 20),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.employeeTodayHoursLabel(hours),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: EtPremiumCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.employeeTodaySalesAmount(
                                      sum.salesTotal.toStringAsFixed(2),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: EtPremiumCard(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.content_cut, size: 20),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.employeeTodayServicesCount(
                                      sum.servicesCount,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('$e'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: punchesAsync.when(
                    data: (punches) {
                      final uid =
                          ref.read(sessionUserProvider).asData?.value?.uid ??
                          '';
                      if (punches.isEmpty) {
                        return EtPremiumCard(
                          child: Text(l10n.employeeTodayNoActivity),
                        );
                      }
                      final events = punches
                          .map(
                            (p) => AttendanceEventModel(
                              eventId: p.id,
                              salonId: p.salonId,
                              attendanceId: p.attendanceDayId,
                              employeeId: p.employeeId,
                              employeeUid: uid,
                              type: p.type,
                              createdAt: p.punchTime,
                              location: AttendanceEventLocation(
                                latitude: p.latitude ?? 0,
                                longitude: p.longitude ?? 0,
                                accuracy: 0,
                              ),
                              distanceMeters: p.distanceFromSalonMeters ?? 0,
                              insideZone: p.insideZone,
                              source: p.source,
                            ),
                          )
                          .toList();
                      return EtPremiumCard(
                        child: TodayActivityTimeline(events: events),
                      );
                    },
                    loading: () => const EtPremiumCard(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => EtPremiumCard(child: Text('$e')),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  child: EtPremiumCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: EmployeeTodayColors.primaryPurple.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.employeeTodayPrivacyNote,
                            style: const TextStyle(
                              fontSize: 13,
                              color: EmployeeTodayColors.mutedText,
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
        ),
      ),
    );
  }
}
