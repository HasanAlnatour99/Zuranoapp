import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/formatting/staff_role_localized.dart';
import '../../../../core/motion/app_motion_widgets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../logic/team_management_providers.dart';
import '../screens/barber_details_screen.dart';
import 'add_barber_fab.dart';
import 'add_barber_sheet.dart';
import '../../../attendance/data/models/attendance_record.dart';
import '../../../team/presentation/widgets/team_empty_state_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class TeamOperationsModule extends ConsumerStatefulWidget {
  const TeamOperationsModule({super.key, required this.salonId});

  final String salonId;

  @override
  ConsumerState<TeamOperationsModule> createState() =>
      _TeamOperationsModuleState();
}

class _TeamOperationsModuleState extends ConsumerState<TeamOperationsModule> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('✅ NEW TeamOperationsModule rendering');
    }
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(teamSummaryProvider);
    final analyticsAsync = ref.watch(teamAnalyticsProvider);
    final allCardsAsync = ref.watch(teamBarberCardsProvider);
    final cardsAsync = ref.watch(filteredTeamBarberCardsProvider);
    final selectedFilter = ref.watch(teamFilterProvider);
    final searchQuery = ref.watch(teamSearchQueryProvider);
    final currencyCode =
        ref.watch(sessionSalonStreamProvider).asData?.value?.currencyCode ??
        'USD';

    final hasError =
        summaryAsync.hasError || allCardsAsync.hasError || cardsAsync.hasError;
    final isLoading =
        summaryAsync.isLoading ||
        allCardsAsync.isLoading ||
        cardsAsync.isLoading;
    final hasTeamMembers = allCardsAsync.asData?.value.isNotEmpty ?? false;
    final hasNoEmployees = (allCardsAsync.asData?.value.isEmpty) ?? false;
    final hasNoFilteredResults =
        hasTeamMembers && (cardsAsync.asData?.value.isEmpty ?? false);
    final filterLabel = selectedFilter == TeamFilter.all
        ? null
        : _filterLabel(l10n, selectedFilter);
    final trimmedSearchQuery = searchQuery.trim();

    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        AppMotionPlayback(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.large,
              AppSpacing.large,
              136,
            ),
            children: [
              _TeamTitleRow(
                onAnalyticsPressed: () =>
                    _showAnalyticsSheet(context, analyticsAsync, currencyCode),
              ),
              const SizedBox(height: AppSpacing.large),
              if (isLoading)
                const _TeamModuleLoadingState()
              else if (hasError)
                AppEmptyState(
                  title: l10n.teamLoadErrorTitle,
                  message: l10n.genericError,
                  icon: AppIcons.groups_outlined,
                  centerContent: true,
                )
              else ...[
                AppEntranceMotion(
                  motionId: 'team-summary-strip',
                  child: _TeamStatsRow(
                    summary: summaryAsync.requireValue,
                    currencyCode: currencyCode,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                _TeamFilterChips(
                  selectedFilter: selectedFilter,
                  onSelected: (value) =>
                      ref.read(teamFilterProvider.notifier).setFilter(value),
                ),
                const SizedBox(height: AppSpacing.medium),
                _TeamSearchRow(
                  controller: _searchController,
                  onChanged: (value) => ref
                      .read(teamSearchQueryProvider.notifier)
                      .setQuery(value),
                  onFilterPressed: () => _showFiltersSheet(
                    context,
                    selectedFilter: ref.read(teamFilterProvider),
                    onSelected: (value) =>
                        ref.read(teamFilterProvider.notifier).setFilter(value),
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                AppFadeThroughSwitcher(
                  transitionKey: 'team-filter-${selectedFilter.name}',
                  child: hasNoEmployees
                      ? SafeArea(
                          top: false,
                          child: TeamEmptyStateCard(
                            key: const ValueKey<String>('team-empty-first-use'),
                            isSearchMode: false,
                            searchQuery: '',
                            onPrimaryAction: () => showAddBarberSheet(
                              context,
                              salonId: widget.salonId,
                            ),
                            onSecondaryAction: () =>
                                _showTeamGuideSheet(context),
                          ),
                        )
                      : hasNoFilteredResults
                      ? SafeArea(
                          top: false,
                          child: TeamEmptyStateCard(
                            key: const ValueKey<String>(
                              'team-empty-search-no-results',
                            ),
                            isSearchMode: true,
                            searchQuery: trimmedSearchQuery,
                            activeFilterLabel: trimmedSearchQuery.isEmpty
                                ? filterLabel
                                : null,
                            onPrimaryAction: () {
                              _searchController.clear();
                              ref
                                  .read(teamSearchQueryProvider.notifier)
                                  .setQuery('');
                              ref
                                  .read(teamFilterProvider.notifier)
                                  .setFilter(TeamFilter.all);
                            },
                            onSecondaryAction: () => showAddBarberSheet(
                              context,
                              salonId: widget.salonId,
                            ),
                          ),
                        )
                      : _TeamCardCollection(
                          key: ValueKey<String>(
                            'team-list-${selectedFilter.name}',
                          ),
                          cards: cardsAsync.requireValue,
                          currencyCode: currencyCode,
                          salonId: widget.salonId,
                          onMarkAttendance: (data) =>
                              _markAttendance(context, ref, data),
                          onToggleActive: (data) =>
                              _toggleActiveState(context, ref, data),
                        ),
                ),
              ],
            ],
          ),
        ),
        if (hasTeamMembers && !hasNoFilteredResults && !hasNoEmployees)
          Positioned(
            left: 0,
            right: 0,
            bottom: 10 + safeBottom,
            child: Center(
              child: AddBarberFab(
                onPressed: () =>
                    showAddBarberSheet(context, salonId: widget.salonId),
              ),
            ),
          ),
      ],
    );
  }

  void _showTeamGuideSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Text(
              AppLocalizations.of(context)!.teamGuideDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }

  void _showFiltersSheet(
    BuildContext context, {
    required TeamFilter selectedFilter,
    required ValueChanged<TeamFilter> onSelected,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.large,
            0,
            AppSpacing.large,
            AppSpacing.large,
          ),
          child: Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              for (final filter in _visibleTeamFilters)
                ChoiceChip(
                  label: Text(_filterLabel(l10n, filter)),
                  selected: selectedFilter == filter,
                  onSelected: (_) {
                    onSelected(filter);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnalyticsSheet(
    BuildContext context,
    AsyncValue<TeamAnalyticsData> analyticsAsync,
    String currencyCode,
  ) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: analyticsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Text(l10n.genericError),
              data: (data) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.teamAnalyticsAction,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  _sheetMetric(
                    l10n.teamSummaryTotalMembers,
                    '${data.totalMembers}',
                  ),
                  _sheetMetric(
                    l10n.teamAnalyticsActiveInactiveLabel,
                    '${data.activeMembers} / ${data.inactiveMembers}',
                  ),
                  _sheetMetric(
                    l10n.teamSummaryWorkingNow,
                    '${data.workingNow}',
                  ),
                  _sheetMetric(
                    l10n.teamSummaryAbsentToday,
                    '${data.absentToday}',
                  ),
                  _sheetMetric(
                    l10n.teamSalesRevenueMonth,
                    formatAppMoney(
                      data.totalRevenueThisMonth,
                      currencyCode,
                      locale,
                    ),
                  ),
                  _sheetMetric(
                    l10n.teamSalesServicesMonth,
                    '${data.servicesThisMonth}',
                  ),
                  _sheetMetric(
                    l10n.teamAnalyticsTopPerformerLabel,
                    data.topPerformerName,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleActiveState(
    BuildContext context,
    WidgetRef ref,
    TeamBarberCardData data,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref
          .read(employeeRepositoryProvider)
          .setEmployeeActiveState(
            salonId: data.employee.salonId,
            employeeId: data.employee.id,
            isActive: !data.employee.isActive,
          );
      if (context.mounted) {
        showAppSuccessSnackBar(
          context,
          data.employee.isActive
              ? l10n.teamMemberDeactivated(data.employee.name)
              : l10n.teamMemberActivated(data.employee.name),
        );
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to toggle team member active state',
        name: 'team.module',
        error: error,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.teamSaveErrorGeneric)));
      }
    }
  }

  Future<void> _markAttendance(
    BuildContext context,
    WidgetRef ref,
    TeamBarberCardData data,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(attendanceRepositoryProvider);
    try {
      if (data.todayAttendance == null) {
        final now = DateTime.now();
        final workDate = DateTime(now.year, now.month, now.day);
        await repo.createAttendanceRecord(
          data.employee.salonId,
          AttendanceRecord(
            id: '',
            salonId: data.employee.salonId,
            employeeId: data.employee.id,
            employeeName: data.employee.name,
            workDate: workDate,
            status: 'present',
            checkInAt: now,
          ),
        );
        if (context.mounted) {
          showAppSuccessSnackBar(context, l10n.teamAttendanceMarkedSuccess);
        }
        return;
      }
      if (data.todayAttendance?.checkOutAt == null) {
        await repo.checkOut(
          salonId: data.employee.salonId,
          attendanceId: data.todayAttendance!.id,
        );
        if (context.mounted) {
          showAppSuccessSnackBar(context, l10n.teamAttendanceCheckoutSuccess);
        }
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.teamAttendanceAlreadyCompleted)),
        );
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to mark attendance from team module',
        name: 'team.module',
        error: error,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.teamAttendanceMarkError)));
      }
    }
  }
}

class _TeamTitleRow extends StatelessWidget {
  const _TeamTitleRow({required this.onAnalyticsPressed});

  final VoidCallback onAnalyticsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.teamManagementTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.teamManagementSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );

    final analyticsButton = FilledButton.tonalIcon(
      onPressed: onAnalyticsPressed,
      icon: const Icon(AppIcons.query_stats_rounded, size: 16),
      label: Text(
        l10n.teamAnalyticsAction,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: FilledButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: const StadiumBorder(),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 390) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock,
              const SizedBox(height: AppSpacing.medium),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: analyticsButton,
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleBlock),
            const SizedBox(width: AppSpacing.medium),
            Flexible(flex: 0, child: analyticsButton),
          ],
        );
      },
    );
  }
}

class _TeamStatsRow extends StatelessWidget {
  const _TeamStatsRow({required this.summary, required this.currencyCode});

  final TeamSummaryData summary;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 620
            ? (constraints.maxWidth - (AppSpacing.small * 3)) / 4
            : 136.0;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TeamStatCard(
                width: cardWidth,
                icon: AppIcons.groups_2_outlined,
                iconColor: const Color(0xFF7C3AED),
                iconBackground: const Color(0xFFF1ECFF),
                label: l10n.teamSummaryTotalMembers,
                value: '${summary.totalMembers}',
                helper: l10n.teamSummaryTotalMembersHelper,
              ),
              const SizedBox(width: AppSpacing.small),
              _TeamStatCard(
                width: cardWidth,
                icon: AppIcons.how_to_reg_outlined,
                iconColor: const Color(0xFF2E9D45),
                iconBackground: const Color(0xFFEAF8ED),
                label: l10n.teamSummaryWorkingNow,
                value: '${summary.checkedInToday}',
                helper: l10n.teamSummaryWorkingNowHelper(summary.totalMembers),
              ),
              const SizedBox(width: AppSpacing.small),
              _TeamStatCard(
                width: cardWidth,
                icon: AppIcons.event_busy_outlined,
                iconColor: const Color(0xFFC8752D),
                iconBackground: const Color(0xFFFFF3E8),
                label: l10n.teamSummaryAbsentToday,
                value: '${summary.absentToday}',
                helper: l10n.teamSummaryAbsentTodayHelper,
              ),
              const SizedBox(width: AppSpacing.small),
              _TeamStatCard(
                width: cardWidth,
                icon: AppIcons.payments_outlined,
                iconColor: const Color(0xFF336BD8),
                iconBackground: const Color(0xFFEAF0FF),
                label: l10n.teamSummaryRevenueToday,
                value: formatAppMoney(summary.salesToday, currencyCode, locale),
                helper: l10n.teamSummaryRevenueTodayHelper,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamStatCard extends StatelessWidget {
  const _TeamStatCard({
    required this.width,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
    required this.helper,
  });

  final double width;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;
  final String helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        color: scheme.surface,
        shadowColor: scheme.shadow.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(height: 14),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                helper,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamFilterChips extends StatelessWidget {
  const _TeamFilterChips({
    required this.selectedFilter,
    required this.onSelected,
  });

  final TeamFilter selectedFilter;
  final ValueChanged<TeamFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: _visibleTeamFilters.length,
        separatorBuilder: (_, index) => const SizedBox(width: AppSpacing.small),
        itemBuilder: (context, index) {
          final filter = _visibleTeamFilters[index];
          return ChoiceChip(
            label: Text(_filterLabel(l10n, filter)),
            selected: selectedFilter == filter,
            onSelected: (_) => onSelected(filter),
            avatar: filter == TeamFilter.topSellers
                ? const Icon(AppIcons.workspace_premium_outlined, size: 16)
                : null,
          );
        },
      ),
    );
  }
}

class _TeamSearchRow extends StatelessWidget {
  const _TeamSearchRow({
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.teamSearchHint,
              prefixIcon: const Icon(AppIcons.search_rounded),
              filled: true,
              fillColor: scheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.55),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Material(
          color: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: IconButton(
            tooltip: l10n.teamFilterAction,
            onPressed: onFilterPressed,
            icon: const Icon(AppIcons.tune_rounded),
            style: IconButton.styleFrom(
              fixedSize: const Size(56, 56),
              iconSize: 24,
              foregroundColor: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _TeamCardCollection extends StatelessWidget {
  const _TeamCardCollection({
    super.key,
    required this.cards,
    required this.currencyCode,
    required this.salonId,
    required this.onMarkAttendance,
    required this.onToggleActive,
  });

  final List<TeamBarberCardData> cards;
  final String currencyCode;
  final String salonId;
  final ValueChanged<TeamBarberCardData> onMarkAttendance;
  final ValueChanged<TeamBarberCardData> onToggleActive;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1180
            ? 2
            : constraints.maxWidth >= 760
            ? 2
            : 1;

        if (crossAxisCount == 1) {
          return Column(
            children: [
              for (var index = 0; index < cards.length; index++) ...[
                if (index > 0) const SizedBox(height: AppSpacing.medium),
                _TeamCardEntry(
                  index: index,
                  data: cards[index],
                  currencyCode: currencyCode,
                  salonId: salonId,
                  onMarkAttendance: () => onMarkAttendance(cards[index]),
                  onToggleActive: () => onToggleActive(cards[index]),
                ),
              ],
            ],
          );
        }

        return Wrap(
          spacing: AppSpacing.medium,
          runSpacing: AppSpacing.medium,
          children: [
            for (var index = 0; index < cards.length; index++)
              SizedBox(
                width:
                    (constraints.maxWidth - AppSpacing.medium) / crossAxisCount,
                child: _TeamCardEntry(
                  index: index,
                  data: cards[index],
                  currencyCode: currencyCode,
                  salonId: salonId,
                  onMarkAttendance: () => onMarkAttendance(cards[index]),
                  onToggleActive: () => onToggleActive(cards[index]),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TeamCardEntry extends StatelessWidget {
  const _TeamCardEntry({
    required this.index,
    required this.data,
    required this.currencyCode,
    required this.salonId,
    required this.onMarkAttendance,
    required this.onToggleActive,
  });

  final int index;
  final TeamBarberCardData data;
  final String currencyCode;
  final String salonId;
  final VoidCallback onMarkAttendance;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    return AppEntranceMotion(
      motionId: 'team-row-${data.employee.id}',
      index: index,
      slideOffset: 10,
      child: AppOpenContainerRoute(
        closedBuilder: (context, openContainer) => _EmployeeCard(
          data: data,
          currencyCode: currencyCode,
          onViewProfile: openContainer,
          onEditMember: () => showAddBarberSheet(
            context,
            salonId: salonId,
            existing: data.employee,
          ),
          onAttendance: onMarkAttendance,
          onPayroll: () => context.push(
            AppRoutes.ownerEmployeePayrollSetup(data.employee.id),
          ),
          onToggleActive: onToggleActive,
        ),
        openBuilder: (context, _) =>
            BarberDetailsScreen(employeeId: data.employee.id),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    required this.data,
    required this.currencyCode,
    required this.onViewProfile,
    required this.onEditMember,
    required this.onAttendance,
    required this.onPayroll,
    required this.onToggleActive,
  });

  final TeamBarberCardData data;
  final String currencyCode;
  final VoidCallback onViewProfile;
  final VoidCallback onEditMember;
  final VoidCallback onAttendance;
  final VoidCallback onPayroll;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final timeFormat = DateFormat.jm(locale.toString());
    final performance = _performancePercent(data);
    final statusTone = _statusTone(context, data.status);

    Widget buildIdentity() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.employee.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            localizedStaffRole(l10n, data.employee.role),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Icon(
                _attendanceIcon(data),
                size: 14,
                color: statusTone.foreground,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  _attendanceLabel(l10n, timeFormat, data),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusTone.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget buildMetricRow() {
      return Row(
        children: [
          Expanded(
            child: _EmployeeMetric(
              icon: AppIcons.scissors,
              value: '${data.todayMetrics.servicesToday}',
              label: l10n.teamMemberServicesShort,
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: _EmployeeMetric(
              icon: AppIcons.payments_outlined,
              value: formatAppMoney(
                data.todayMetrics.salesToday,
                currencyCode,
                locale,
              ),
              label: l10n.teamMemberRevenueToday,
              iconBackground: const Color(0xFFEAF8ED),
              iconColor: const Color(0xFF2E9D45),
            ),
          ),
        ],
      );
    }

    Widget buildPerformance() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusChip(status: data.status),
          const SizedBox(height: 8),
          Text(
            l10n.teamMemberPerformance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            l10n.teamMemberPerformancePercent(performance),
            style: theme.textTheme.labelMedium?.copyWith(
              color: statusTone.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          _PerformanceBar(value: performance, color: statusTone.foreground),
        ],
      );
    }

    Widget buildMoreMenu() {
      return PopupMenuButton<_TeamMemberAction>(
        tooltip: l10n.teamMemberMoreActions,
        onSelected: (value) {
          switch (value) {
            case _TeamMemberAction.viewProfile:
              onViewProfile();
              return;
            case _TeamMemberAction.edit:
              onEditMember();
              return;
            case _TeamMemberAction.attendance:
              onAttendance();
              return;
            case _TeamMemberAction.payroll:
              onPayroll();
              return;
            case _TeamMemberAction.toggleActive:
              onToggleActive();
              return;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _TeamMemberAction.viewProfile,
            child: Text(l10n.teamMemberViewProfileAction),
          ),
          PopupMenuItem(
            value: _TeamMemberAction.edit,
            child: Text(l10n.teamMemberEditAction),
          ),
          PopupMenuItem(
            value: _TeamMemberAction.attendance,
            child: Text(l10n.teamMemberAttendanceAction),
          ),
          PopupMenuItem(
            value: _TeamMemberAction.payroll,
            child: Text(l10n.teamMemberPayrollAction),
          ),
          PopupMenuItem(
            value: _TeamMemberAction.toggleActive,
            child: Text(
              data.employee.isActive
                  ? l10n.teamMemberDeactivateAction
                  : l10n.teamMemberActivateAction,
            ),
          ),
        ],
        icon: const Icon(AppIcons.more_horiz_rounded),
      );
    }

    return Card(
      elevation: 0,
      color: scheme.surface,
      shadowColor: scheme.shadow.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onViewProfile,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 430) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _EmployeeAvatar(data: data, statusTone: statusTone),
                        const SizedBox(width: AppSpacing.medium),
                        Expanded(child: buildIdentity()),
                        buildMoreMenu(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: buildMetricRow()),
                        const SizedBox(width: AppSpacing.medium),
                        SizedBox(width: 102, child: buildPerformance()),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _EmployeeAvatar(data: data, statusTone: statusTone),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(flex: 7, child: buildIdentity()),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(flex: 4, child: buildMetricRow()),
                  const SizedBox(width: AppSpacing.small),
                  SizedBox(width: 96, child: buildPerformance()),
                  buildMoreMenu(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmployeeAvatar extends StatelessWidget {
  const _EmployeeAvatar({required this.data, required this.statusTone});

  final TeamBarberCardData data;
  final _StatusTone statusTone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initials(data.employee.name);
    final avatarUrl = data.employee.avatarUrl?.trim();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          backgroundImage: avatarUrl == null || avatarUrl.isEmpty
              ? null
              : NetworkImage(avatarUrl),
          child: avatarUrl == null || avatarUrl.isEmpty
              ? Text(
                  initials,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                )
              : null,
        ),
        PositionedDirectional(
          end: 0,
          bottom: 1,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusTone.foreground,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmployeeMetric extends StatelessWidget {
  const _EmployeeMetric({
    required this.icon,
    required this.value,
    required this.label,
    this.iconBackground = const Color(0xFFF1ECFF),
    this.iconColor = const Color(0xFF7C3AED),
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TeamMemberStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tone = _statusTone(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(l10n, status),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: tone.foreground,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  const _PerformanceBar({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = (value.clamp(0, 100)) / 100;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 5,
        value: progress,
        backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

Widget _sheetMetric(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.small),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _TeamModuleLoadingState extends StatelessWidget {
  const _TeamModuleLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AppSkeletonBlock(height: 132),
        SizedBox(height: AppSpacing.large),
        AppSkeletonBlock(height: 48),
        SizedBox(height: AppSpacing.medium),
        AppSkeletonBlock(height: 56),
        SizedBox(height: AppSpacing.large),
        AppSkeletonBlock(height: 108),
        SizedBox(height: AppSpacing.medium),
        AppSkeletonBlock(height: 108),
        SizedBox(height: AppSpacing.medium),
        AppSkeletonBlock(height: 108),
      ],
    );
  }
}

enum _TeamMemberAction { viewProfile, edit, attendance, payroll, toggleActive }

class _StatusTone {
  const _StatusTone({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

const _visibleTeamFilters = <TeamFilter>[
  TeamFilter.all,
  TeamFilter.active,
  TeamFilter.checkedIn,
  TeamFilter.inactive,
  TeamFilter.topSellers,
];

String _filterLabel(AppLocalizations l10n, TeamFilter filter) {
  return switch (filter) {
    TeamFilter.all => l10n.teamFilterAll,
    TeamFilter.active => l10n.teamFilterActive,
    TeamFilter.checkedIn => l10n.teamFilterWorking,
    TeamFilter.inactive => l10n.teamFilterInactive,
    TeamFilter.topSellers => l10n.teamFilterTopPerformers,
    TeamFilter.needsAttention => l10n.teamFilterNeedsAttention,
  };
}

String _statusLabel(AppLocalizations l10n, TeamMemberStatus status) {
  return switch (status) {
    TeamMemberStatus.active => l10n.teamStatusActive,
    TeamMemberStatus.checkedIn => l10n.teamStatusActive,
    TeamMemberStatus.late => l10n.teamStatusLate,
    TeamMemberStatus.inactive => l10n.teamStatusInactive,
  };
}

String _attendanceLabel(
  AppLocalizations l10n,
  DateFormat timeFormat,
  TeamBarberCardData data,
) {
  final attendance = data.todayAttendance;
  if (data.status == TeamMemberStatus.inactive) {
    return l10n.teamMemberInactiveStatus;
  }
  if (attendance == null || attendance.checkInAt == null) {
    return l10n.teamMemberNotCheckedIn;
  }
  if (data.status == TeamMemberStatus.late) {
    return l10n.teamMemberLateAt(
      timeFormat.format(attendance.checkInAt!.toLocal()),
    );
  }
  return l10n.teamMemberCheckedInAt(
    timeFormat.format(attendance.checkInAt!.toLocal()),
  );
}

IconData _attendanceIcon(TeamBarberCardData data) {
  return switch (data.status) {
    TeamMemberStatus.active => AppIcons.schedule_outlined,
    TeamMemberStatus.checkedIn => AppIcons.check_circle_outline,
    TeamMemberStatus.late => AppIcons.timelapse_outlined,
    TeamMemberStatus.inactive => AppIcons.circle_outlined,
  };
}

_StatusTone _statusTone(BuildContext context, TeamMemberStatus status) {
  final scheme = Theme.of(context).colorScheme;
  return switch (status) {
    TeamMemberStatus.active => const _StatusTone(
      foreground: Color(0xFF2E9D45),
      background: Color(0xFFEAF8ED),
    ),
    TeamMemberStatus.checkedIn => const _StatusTone(
      foreground: Color(0xFF2E9D45),
      background: Color(0xFFEAF8ED),
    ),
    TeamMemberStatus.late => const _StatusTone(
      foreground: Color(0xFFC8752D),
      background: Color(0xFFFFF2E5),
    ),
    TeamMemberStatus.inactive => _StatusTone(
      foreground: scheme.onSurfaceVariant,
      background: scheme.surfaceContainerHigh,
    ),
  };
}

int _performancePercent(TeamBarberCardData data) {
  if (!data.employee.isActive || data.todayMetrics.servicesToday == 0) {
    return 0;
  }
  final salesWeight = (data.todayMetrics.salesToday / 1000 * 65).clamp(0, 65);
  final servicesWeight = (data.todayMetrics.servicesToday / 10 * 35).clamp(
    0,
    35,
  );
  return (salesWeight + servicesWeight).round().clamp(0, 100);
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return '?';
  }
  if (parts.length == 1) {
    final value = parts.first;
    return value.substring(0, value.length > 1 ? 2 : 1).toUpperCase();
  }
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
