import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/session_provider.dart';

export '../../logic/expenses_dashboard_providers.dart';

/// Active salon id for the signed-in staff session, or null if missing.
final currentSalonIdProvider = Provider<String?>((ref) {
  final id =
      ref.watch(sessionUserProvider).asData?.value?.salonId?.trim() ?? '';
  return id.isEmpty ? null : id;
});
