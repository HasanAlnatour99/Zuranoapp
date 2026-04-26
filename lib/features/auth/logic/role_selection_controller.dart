import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/user_roles.dart';
import '../../../core/debug/agent_session_log.dart';
import '../../../core/utils/firebase_error_message.dart';
import '../../../providers/firebase_providers.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';

final roleSelectionControllerProvider =
    NotifierProvider.autoDispose<RoleSelectionController, RoleSelectionState>(
      RoleSelectionController.new,
    );

class RoleSelectionController extends Notifier<RoleSelectionState> {
  @override
  RoleSelectionState build() => const RoleSelectionState();

  Future<bool> selectOwner() => selectRole(UserRoles.owner);

  Future<bool> selectRole(String role) => _persistRole(role);

  Future<bool> _persistRole(String role) async {
    if (role != UserRoles.owner &&
        role != UserRoles.employee &&
        role != UserRoles.customer) {
      state = state.copyWith(error: 'Invalid role.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    final session = ref.read(sessionUserProvider).asData?.value;
    var resolvedSession = session;
    if (resolvedSession == null) {
      final fallbackUid = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (fallbackUid != null && fallbackUid.isNotEmpty) {
        resolvedSession = await ref
            .read(userRepositoryProvider)
            .getUser(fallbackUid);
      }
    }
    if (resolvedSession == null) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'No active authenticated profile found. Please sign in again.',
      );
      return false;
    }

    try {
      agentSessionLog(
        hypothesisId: 'S1',
        location: 'role_selection_controller.dart:_persistRole',
        message: 'role_save_start',
        data: <String, Object?>{'targetRole': role, 'uid': resolvedSession.uid},
        runId: 'startup-router-debug',
      );
      await ref
          .read(userRepositoryProvider)
          .createOrUpdateUser(
            resolvedSession.copyWith(
              role: role,
              salonId: null,
              employeeId: null,
            ),
          );
      agentSessionLog(
        hypothesisId: 'S1',
        location: 'role_selection_controller.dart:_persistRole',
        message: 'role_save_end',
        data: <String, Object?>{
          'targetRole': role,
          'uid': resolvedSession.uid,
          'ok': true,
        },
        runId: 'startup-router-debug',
      );
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (error) {
      agentSessionLog(
        hypothesisId: 'S1',
        location: 'role_selection_controller.dart:_persistRole',
        message: 'role_save_end',
        data: <String, Object?>{
          'targetRole': role,
          'uid': resolvedSession.uid,
          'ok': false,
          'error': error.toString(),
        },
        runId: 'startup-router-debug',
      );
      state = state.copyWith(
        isSubmitting: false,
        error: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }
}

class RoleSelectionState {
  const RoleSelectionState({this.isSubmitting = false, this.error});

  final bool isSubmitting;
  final String? error;

  RoleSelectionState copyWith({bool? isSubmitting, Object? error = _sentinel}) {
    return RoleSelectionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error == _sentinel ? this.error : error as String?,
    );
  }
}

const Object _sentinel = Object();
