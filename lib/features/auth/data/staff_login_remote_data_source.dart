import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/cloud_functions_region.dart';

/// Callable [resolveStaffLoginEmail] — maps staff username → internal auth email.
class StaffLoginRemoteDataSource {
  StaffLoginRemoteDataSource({FirebaseFunctions? functions})
    : _functions = functions ?? appCloudFunctions();

  final FirebaseFunctions _functions;

  static const resolveEmailCallableName = 'resolveStaffLoginEmail';

  Future<String> resolveEmailForStaffUsername(String username) async {
    final callable = _functions.httpsCallable(resolveEmailCallableName);
    // Match server + login controller: staff usernames are ASCII-only and
    // resolved case-insensitively via `usernameLower`.
    final normalized = username.trim().toLowerCase();
    final result = await callable.call(<String, dynamic>{
      'username': normalized,
    });
    final raw = result.data;
    if (raw is! Map) {
      throw StateError('$resolveEmailCallableName returned invalid payload.');
    }
    final email =
        Map<String, dynamic>.from(
          raw,
        )['email']?.toString().trim().toLowerCase() ??
        '';
    if (!email.contains('@')) {
      throw StateError('$resolveEmailCallableName returned invalid email.');
    }
    return email;
  }
}
