import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/user_roles.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../data/models/attendance_correction_request_model.dart';
import '../data/models/attendance_record_model.dart';
import '../data/models/attendance_summary_model.dart';

class TeamMemberAttendanceArgs {
  const TeamMemberAttendanceArgs({
    required this.salonId,
    required this.employeeId,
  });

  final String salonId;
  final String employeeId;

  @override
  bool operator ==(Object other) {
    return other is TeamMemberAttendanceArgs &&
        other.salonId == salonId &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode => Object.hash(salonId, employeeId);
}

/// Owner always; admin only when `employees/{uid}.permissions.canManageAttendance == true`.
final canManageTeamMemberAttendanceProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(sessionUserProvider.future);
  if (user == null) return false;
  if (user.role == UserRoles.owner) return true;
  if (user.role != UserRoles.admin) return false;

  final salonId = user.salonId;
  final empId = user.employeeId;
  if (salonId == null ||
      empId == null ||
      salonId.trim().isEmpty ||
      empId.trim().isEmpty) {
    return false;
  }

  final snap = await ref
      .read(firestoreProvider)
      .collection('salons')
      .doc(salonId)
      .collection('employees')
      .doc(empId)
      .get();

  final perms = snap.data()?['permissions'];
  if (perms is! Map) return false;
  return perms['canManageAttendance'] == true;
});

final todayAttendanceProvider =
    StreamProvider.family<AttendanceRecordModel?, TeamMemberAttendanceArgs>((
      ref,
      args,
    ) {
      final repo = ref.watch(teamMemberAttendanceRepositoryProvider);
      return repo.watchTodayAttendance(
        salonId: args.salonId,
        employeeId: args.employeeId,
        today: DateTime.now(),
      );
    });

final recentAttendanceProvider =
    StreamProvider.family<
      List<AttendanceRecordModel>,
      TeamMemberAttendanceArgs
    >((ref, args) {
      final repo = ref.watch(teamMemberAttendanceRepositoryProvider);
      return repo.watchRecentAttendance(
        salonId: args.salonId,
        employeeId: args.employeeId,
        limit: 10,
      );
    });

final attendanceCorrectionRequestsProvider =
    StreamProvider.family<
      List<AttendanceCorrectionRequestModel>,
      TeamMemberAttendanceArgs
    >((ref, args) {
      final repo = ref.watch(teamMemberAttendanceRepositoryProvider);
      return repo.watchCorrectionRequests(
        salonId: args.salonId,
        employeeId: args.employeeId,
        limit: 10,
      );
    });

final attendanceSummaryProvider =
    FutureProvider.family<AttendanceSummaryModel, TeamMemberAttendanceArgs>((
      ref,
      args,
    ) async {
      final repo = ref.watch(teamMemberAttendanceRepositoryProvider);
      return repo.getSummary(
        salonId: args.salonId,
        employeeId: args.employeeId,
        now: DateTime.now(),
      );
    });
