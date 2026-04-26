import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/violation_types.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../violations/data/models/violation.dart';

typedef HrViolationsSummaryData = ({
  int pendingReviews,
  int activeRules,
  int staffFlagged,
});

final hrViolationsSummaryProvider =
    Provider<AsyncValue<HrViolationsSummaryData>>((ref) {
      final violationsAsync = ref.watch(violationsStreamProvider);
      final salonAsync = ref.watch(sessionSalonStreamProvider);

      return violationsAsync.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (violations) {
          return salonAsync.when(
            loading: () => const AsyncValue.loading(),
            error: (e, st) => AsyncValue.error(e, st),
            data: (salon) {
              final pending = violations
                  .where((v) => v.status == ViolationStatuses.pending)
                  .length;
              final p = salon?.penaltySettings;
              var rules = 0;
              if (p != null) {
                rules =
                    (p.barberLateEnabled ? 1 : 0) +
                    (p.barberNoShowEnabled ? 1 : 0);
              }
              final now = DateTime.now();
              final flaggedIds = violations
                  .where((Violation v) {
                    final d = v.occurredAt;
                    return d.year == now.year && d.month == now.month;
                  })
                  .map((v) => v.employeeId)
                  .toSet();
              return AsyncValue.data((
                pendingReviews: pending,
                activeRules: rules,
                staffFlagged: flaggedIds.length,
              ));
            },
          );
        },
      );
    });
