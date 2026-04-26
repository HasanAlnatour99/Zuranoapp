import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/firebase_providers.dart';
import '../../../providers/repository_providers.dart';
import '../data/models/team_member_model.dart';
import '../data/models/team_member_today_summary_model.dart';
import '../data/repositories/team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(
    firestore: ref.watch(firestoreProvider),
    salesRepository: ref.watch(salesRepositoryProvider),
    attendanceRepository: ref.watch(attendanceRepositoryProvider),
  );
});

class TeamMemberProfileArgs {
  const TeamMemberProfileArgs({
    required this.salonId,
    required this.employeeId,
    required this.currencyCode,
  });

  final String salonId;
  final String employeeId;
  final String currencyCode;

  @override
  bool operator ==(Object other) {
    return other is TeamMemberProfileArgs &&
        other.salonId == salonId &&
        other.employeeId == employeeId &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => Object.hash(salonId, employeeId, currencyCode);
}

/// Live employee row for profile UI (Firestore `employees/{id}`).
final teamMemberProfileStreamProvider = StreamProvider.autoDispose
    .family<TeamMemberModel?, TeamMemberProfileArgs>((ref, args) {
      final repo = ref.watch(teamRepositoryProvider);
      return repo.watchTeamMember(
        salonId: args.salonId,
        employeeId: args.employeeId,
        currencyCode: args.currencyCode,
      );
    });

final teamMemberTodaySummaryProvider = FutureProvider.autoDispose
    .family<TeamMemberTodaySummaryModel, TeamMemberProfileArgs>((ref, args) {
      final repo = ref.watch(teamRepositoryProvider);
      return repo.getTodaySummary(
        salonId: args.salonId,
        employeeId: args.employeeId,
        now: DateTime.now(),
      );
    });
