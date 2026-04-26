import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/employees/data/models/employee.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';

/// Logged-in staff member document (`salons/{salonId}/employees/{employeeId}`).
final addSaleSessionEmployeeProvider = FutureProvider.autoDispose<Employee?>((
  ref,
) async {
  final u = ref.watch(sessionUserProvider).asData?.value;
  final sid = u?.salonId?.trim();
  final eid = u?.employeeId?.trim();
  if (u == null || sid == null || sid.isEmpty || eid == null || eid.isEmpty) {
    return null;
  }
  return ref.read(employeeRepositoryProvider).getEmployee(sid, eid);
});
