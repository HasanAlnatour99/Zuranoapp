import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/firebase_providers.dart';
import '../data/attendance_settings_repository.dart';
import '../domain/models/attendance_settings_model.dart';

/// Repository provider for the unified attendance settings document.
final attendanceSettingsRepositoryProvider =
    Provider<AttendanceSettingsRepository>((ref) {
      return AttendanceSettingsRepository(
        firestore: ref.watch(firestoreProvider),
      );
    });

/// Streams the canonical [AttendanceSettingsModel] for [salonId]. Always
/// emits a value (defaults when the doc is missing).
final attendanceSettingsProvider = StreamProvider.family
    .autoDispose<AttendanceSettingsModel, String>((ref, salonId) {
      final repository = ref.watch(attendanceSettingsRepositoryProvider);
      return repository.watchSettings(salonId);
    });

/// Save state for the unified attendance settings screen.
class AttendanceSettingsControllerState {
  const AttendanceSettingsControllerState({this.isSaving = false, this.error});

  final bool isSaving;
  final Object? error;

  AttendanceSettingsControllerState copyWith({
    bool? isSaving,
    Object? error,
    bool clearError = false,
  }) {
    return AttendanceSettingsControllerState(
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller exposed to the screen for saving.
class AttendanceSettingsController
    extends Notifier<AttendanceSettingsControllerState> {
  @override
  AttendanceSettingsControllerState build() {
    return const AttendanceSettingsControllerState();
  }

  Future<bool> save({
    required String salonId,
    required AttendanceSettingsModel settings,
    required String updatedBy,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final repository = ref.read(attendanceSettingsRepositoryProvider);
      await repository.saveSettings(
        salonId: salonId,
        settings: settings,
        updatedBy: updatedBy,
      );
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e);
      return false;
    }
  }
}

final attendanceSettingsControllerProvider =
    NotifierProvider.autoDispose<
      AttendanceSettingsController,
      AttendanceSettingsControllerState
    >(AttendanceSettingsController.new);
