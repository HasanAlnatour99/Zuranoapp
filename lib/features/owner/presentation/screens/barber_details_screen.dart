import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/motion/app_motion_widgets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../team_member_profile/presentation/theme/team_member_profile_colors.dart';
import '../../../team_member_attendance/application/team_member_attendance_providers.dart';
import '../../../team_member_attendance/presentation/team_member_attendance_tab.dart';
import '../../../employees/data/models/employee.dart';
import '../../logic/team_management_providers.dart';
import '../widgets/add_barber_sheet.dart';
import '../widgets/barber_booking_prep_tab.dart';
import '../widgets/barber_overview_tab.dart';
import '../widgets/barber_payroll_tab.dart';
import '../widgets/barber_sales_tab.dart';
import '../widgets/barber_services_tab.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class BarberDetailsScreen extends ConsumerStatefulWidget {
  const BarberDetailsScreen({super.key, required this.employeeId});

  final String employeeId;

  @override
  ConsumerState<BarberDetailsScreen> createState() =>
      _BarberDetailsScreenState();
}

class _BarberDetailsScreenState extends ConsumerState<BarberDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _tabBoundEmployeeId;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _syncTabController(String employeeId) {
    if (_tabController != null && _tabBoundEmployeeId == employeeId) {
      return;
    }
    _tabController?.dispose();
    _tabBoundEmployeeId = employeeId;
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailsAsync = ref.watch(barberDetailsProvider(widget.employeeId));
    final salonAsync = ref.watch(sessionSalonStreamProvider);

    return detailsAsync.when(
      loading: () => Scaffold(
        backgroundColor: TeamMemberProfileColors.canvas,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: TeamMemberProfileColors.canvas,
          foregroundColor: TeamMemberProfileColors.textPrimary,
        ),
        body: const Center(child: AppLoadingIndicator(size: 40)),
      ),
      error: (error, _) {
        final message =
            error is FirebaseException && error.code == 'permission-denied'
            ? l10n.teamProfilePermissionDenied
            : l10n.teamProfileLoadGenericError;
        return Scaffold(
          backgroundColor: TeamMemberProfileColors.canvas,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: TeamMemberProfileColors.canvas,
            foregroundColor: TeamMemberProfileColors.textPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: AppEmptyState(
                title: l10n.teamDetailsLoadErrorTitle,
                message: message,
                icon: AppIcons.groups_outlined,
              ),
            ),
          ),
        );
      },
      data: (data) {
        _syncTabController(data.employee.id);
        final tabController = _tabController!;
        final currencyCode = salonAsync.asData?.value?.currencyCode ?? 'USD';
        final canManageAttendance =
            ref.watch(canManageTeamMemberAttendanceProvider).asData?.value ??
            false;

        return Scaffold(
          backgroundColor: TeamMemberProfileColors.canvas,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DetailsTopBar(
                  title: data.employee.name,
                  onBack: () => context.pop(),
                  onCamera: () => _updateProfilePhoto(context, data.employee),
                  onEdit: () => showAddBarberSheet(
                    context,
                    salonId: data.employee.salonId,
                    existing: data.employee,
                  ),
                  cameraTooltip: l10n.addBarberProfilePhotoButton,
                  editTooltip: l10n.teamMemberEditAction,
                ),
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: TeamMemberProfileColors.primary,
                  unselectedLabelColor: TeamMemberProfileColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  indicatorColor: TeamMemberProfileColors.primary,
                  indicatorWeight: 3,
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tabs: [
                    Tab(text: l10n.teamDetailsTabOverview),
                    Tab(text: l10n.teamDetailsTabSales),
                    Tab(text: l10n.teamDetailsTabAttendance),
                    Tab(text: l10n.teamDetailsTabPayroll),
                    Tab(text: l10n.teamDetailsTabServices),
                    Tab(text: l10n.teamDetailsTabBookingPrep),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BarberOverviewTab(data: data, currencyCode: currencyCode),
                      BarberSalesTab(
                        data: data,
                        currencyCode: currencyCode,
                        onAddSale: () => context.push(
                          AppRoutes.addSalePrefill(
                            employeeId: data.employee.id,
                          ),
                        ),
                      ),
                      TeamMemberAttendanceTab(
                        salonId: data.employee.salonId,
                        employeeId: data.employee.id,
                        employeeName: data.employee.name,
                        canManageAttendance: canManageAttendance,
                      ),
                      BarberPayrollTab(data: data, currencyCode: currencyCode),
                      BarberServicesTab(data: data, currencyCode: currencyCode),
                      BarberBookingPrepTab(data: data),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateProfilePhoto(
    BuildContext context,
    Employee employee,
  ) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) {
        return;
      }
      final file = File(picked.path);
      final repository = ref.read(employeeRepositoryProvider);
      final photoUrl = await repository.uploadProfilePhoto(
        salonId: employee.salonId,
        employeeId: employee.id,
        file: file,
      );
      await repository.updateEmployeePhoto(
        salonId: employee.salonId,
        employeeId: employee.id,
        photoUrl: photoUrl,
      );
      if (context.mounted) {
        showAppSuccessSnackBar(context, 'Profile photo updated.');
      }
    } catch (error, stackTrace) {
      developer.log(
        'Failed to update employee photo',
        name: 'team.barberDetails',
        error: error,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile photo.')),
        );
      }
    }
  }
}

class _DetailsTopBar extends StatelessWidget {
  const _DetailsTopBar({
    required this.title,
    required this.onBack,
    required this.onCamera,
    required this.onEdit,
    required this.cameraTooltip,
    required this.editTooltip,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onCamera;
  final VoidCallback onEdit;
  final String cameraTooltip;
  final String editTooltip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            color: TeamMemberProfileColors.textPrimary,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: TeamMemberProfileColors.textPrimary,
              ),
            ),
          ),
          Tooltip(
            message: cameraTooltip,
            child: _RoundedIconButton(
              icon: AppIcons.photo_camera_outlined,
              onTap: onCamera,
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: editTooltip,
            child: _RoundedIconButton(
              icon: AppIcons.edit_outlined,
              onTap: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundedIconButton extends StatelessWidget {
  const _RoundedIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TeamMemberProfileColors.softPurple,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TeamMemberProfileColors.border),
          ),
          child: Icon(icon, color: TeamMemberProfileColors.primary, size: 24),
        ),
      ),
    );
  }
}
