import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/attendance_approval.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/salon_streams_provider.dart';
import '../../../providers/session_provider.dart';
import '../../attendance/data/attendance_repository.dart';
import '../../attendance/data/models/attendance_record.dart';
import '../../users/data/models/app_user.dart';
import 'attendance_requests_review_state.dart';

/// Owner / admin controller for the Attendance Requests review queue.
///
/// Subscribes to [pendingAttendanceRequestsStreamProvider] for the live list,
/// and exposes `approve` / `reject` actions that delegate to the repository.
/// All Firestore writes go through [AttendanceRepository.approveAttendance] so
/// the status + metadata update atomically.
class AttendanceRequestsReviewController
    extends Notifier<AttendanceRequestsReviewState> {
  ProviderSubscription<AsyncValue<List<AttendanceRecord>>>? _subscription;

  @override
  AttendanceRequestsReviewState build() {
    _subscription?.close();
    _subscription = ref.listen<AsyncValue<List<AttendanceRecord>>>(
      pendingAttendanceRequestsStreamProvider,
      (previous, next) => _applySnapshot(next),
      fireImmediately: true,
    );
    ref.onDispose(() {
      _subscription?.close();
      _subscription = null;
    });
    return const AttendanceRequestsReviewState();
  }

  void _applySnapshot(AsyncValue<List<AttendanceRecord>> snapshot) {
    snapshot.when(
      data: (records) {
        final visibleIds = records.map((r) => r.id).toSet();
        final stillProcessing = state.processingIds
            .where(visibleIds.contains)
            .toSet();
        state = state.copyWith(
          requests: records,
          isLoading: false,
          errorMessage: null,
          processingIds: stillProcessing,
        );
      },
      loading: () {
        if (!state.isLoading) {
          state = state.copyWith(isLoading: true);
        }
      },
      error: (error, _) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
      },
    );
  }

  Future<bool> approve(AttendanceRecord record) {
    return _review(
      record: record,
      approvalStatus: AttendanceApprovalStatuses.approved,
    );
  }

  Future<bool> reject(AttendanceRecord record, {String? rejectionReason}) {
    return _review(
      record: record,
      approvalStatus: AttendanceApprovalStatuses.rejected,
      rejectionReason: rejectionReason,
    );
  }

  Future<bool> _review({
    required AttendanceRecord record,
    required String approvalStatus,
    String? rejectionReason,
  }) async {
    if (record.id.isEmpty) return false;
    final user = ref.read(sessionUserProvider).asData?.value;
    if (user == null || user.uid.isEmpty) {
      state = state.copyWith(errorMessage: 'Not signed in.');
      return false;
    }
    final salonId = user.salonId ?? '';
    if (salonId.isEmpty) {
      state = state.copyWith(errorMessage: 'Missing salonId on session.');
      return false;
    }

    if (state.processingIds.contains(record.id)) return false;

    state = state.copyWith(
      processingIds: {...state.processingIds, record.id},
      errorMessage: null,
    );

    try {
      await ref
          .read(attendanceRepositoryProvider)
          .approveAttendance(
            salonId: salonId,
            attendanceId: record.id,
            approvedByUid: user.uid,
            approvedByName: _displayName(user),
            approvalStatus: approvalStatus,
            rejectionReason: rejectionReason,
          );

      final remaining = {...state.processingIds}..remove(record.id);
      state = state.copyWith(
        processingIds: remaining,
        lastApprovedId: approvalStatus == AttendanceApprovalStatuses.approved
            ? record.id
            : null,
        lastRejectedId: approvalStatus == AttendanceApprovalStatuses.rejected
            ? record.id
            : null,
      );
      return true;
    } catch (error) {
      final remaining = {...state.processingIds}..remove(record.id);
      state = state.copyWith(
        processingIds: remaining,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  void clearFeedback() {
    if (state.lastApprovedId == null && state.lastRejectedId == null) return;
    state = state.copyWith(lastApprovedId: null, lastRejectedId: null);
  }

  void clearError() {
    if (!state.hasError) return;
    state = state.copyWith(errorMessage: null);
  }

  String? _displayName(AppUser user) {
    final name = user.name.trim();
    return name.isEmpty ? null : name;
  }
}

final attendanceRequestsReviewControllerProvider =
    NotifierProvider<
      AttendanceRequestsReviewController,
      AttendanceRequestsReviewState
    >(AttendanceRequestsReviewController.new);
