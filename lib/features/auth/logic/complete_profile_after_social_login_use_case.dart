import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/user_roles.dart';
import '../../users/data/models/app_user.dart';
import '../../users/data/user_repository.dart';

class CompleteProfileAfterSocialLoginUseCase {
  CompleteProfileAfterSocialLoginUseCase({
    required FirebaseAuth auth,
    required UserRepository userRepository,
  }) : _auth = auth,
       _userRepository = userRepository;

  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  Future<AppUser> call({required String role}) async {
    final authUser = _auth.currentUser;
    if (authUser == null) {
      throw FirebaseAuthException(
        code: 'user-not-authenticated',
        message: 'No authenticated user found.',
      );
    }

    final uid = authUser.uid;
    final existing = await _userRepository.getUser(uid);
    if (existing != null) {
      return existing;
    }

    if (role != UserRoles.employee &&
        role != UserRoles.owner &&
        role != UserRoles.customer) {
      throw FirebaseAuthException(
        code: 'invalid-role',
        message: 'Role must be customer, employee, or owner.',
      );
    }

    final resolvedName = authUser.displayName?.trim().isNotEmpty == true
        ? authUser.displayName!.trim()
        : (authUser.email ?? 'User');

    final newUser = AppUser(
      uid: uid,
      email: authUser.email ?? '',
      name: resolvedName,
      role: role,
      isActive: true,
      salonId: null,
      employeeId: null,
      authProvider: 'google',
      photoUrl: authUser.photoURL,
      onboardingCompleted: true,
      profileCompletedAt: DateTime.now(),
      mustChangePassword: null,
      salonCreationCompleted: role == UserRoles.owner ? false : null,
      onboardingStatus: null,
      createdAt: null,
      updatedAt: null,
      address: null,
      phone: null,
      notificationPrefs: null,
    );

    final created = await _userRepository.createUserIfNotExists(newUser);
    if (!created) {
      final again = await _userRepository.getUser(uid);
      if (again != null) {
        return again;
      }
      throw FirebaseAuthException(
        code: 'profile-create-failed',
        message: 'Could not create user profile.',
      );
    }
    return newUser;
  }
}
