import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../sales/data/models/sale.dart';
import '../../data/models/employee_sales_query.dart';
import '../../data/models/sales_date_filter.dart';
import '../../data/models/team_sales_insight_model.dart';
import '../../data/models/team_sales_insight_request.dart';
import '../../data/models/team_sales_summary_model.dart';
import '../../data/repositories/team_member_sales_ai_repository.dart';
import '../../data/repositories/team_member_sales_repository.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../providers/repository_providers.dart';

final teamMemberSalesRepositoryProvider = Provider<TeamMemberSalesRepository>((
  ref,
) {
  return TeamMemberSalesRepository(
    salesRepository: ref.watch(salesRepositoryProvider),
  );
});

final teamMemberSalesAiRepositoryProvider =
    Provider<TeamMemberSalesAiRepository>((ref) {
      return TeamMemberSalesAiRepository(
        firestore: ref.watch(firestoreProvider),
        auth: ref.watch(firebaseAuthProvider),
      );
    });

class TeamSalesDateFilterNotifier extends Notifier<SalesDateFilter> {
  @override
  SalesDateFilter build() => SalesDateFilter.thisMonth();

  void setFilter(SalesDateFilter value) => state = value;
}

final teamSalesDateFilterProvider =
    NotifierProvider.autoDispose<TeamSalesDateFilterNotifier, SalesDateFilter>(
      TeamSalesDateFilterNotifier.new,
    );

final teamMemberKpiSalesStreamProvider = StreamProvider.autoDispose
    .family<List<Sale>, EmployeeSalesQuery>((ref, query) {
      final repo = ref.watch(teamMemberSalesRepositoryProvider);
      final now = DateTime.now();
      final start = teamMemberKpiQueryStartLocal(now);
      final end = teamMemberKpiQueryEndExclusiveLocal(now);
      return repo.watchEmployeeSalesByDateRange(
        salonId: query.salonId,
        employeeId: query.employeeId,
        startDate: start,
        endDate: end,
        limit: 500,
      );
    });

final teamMemberHistorySalesStreamProvider = StreamProvider.autoDispose
    .family<List<Sale>, EmployeeSalesQuery>((ref, query) {
      final filter = ref.watch(teamSalesDateFilterProvider);
      final repo = ref.watch(teamMemberSalesRepositoryProvider);
      return repo.watchEmployeeSalesByDateRange(
        salonId: query.salonId,
        employeeId: query.employeeId,
        startDate: filter.startInclusive,
        endDate: filter.endExclusive,
        limit: 400,
      );
    });

final teamMemberSalesSummaryProvider = Provider.autoDispose
    .family<TeamSalesSummaryModel, EmployeeSalesQuery>((ref, query) {
      final async = ref.watch(teamMemberKpiSalesStreamProvider(query));
      return async.maybeWhen(
        data: TeamSalesSummaryModel.fromSales,
        orElse: TeamSalesSummaryModel.empty,
      );
    });

final teamMemberSalesInsightProvider = FutureProvider.autoDispose
    .family<TeamSalesInsightModel?, TeamSalesInsightRequest>((
      ref,
      request,
    ) async {
      try {
        // Use [read] so live KPI stream updates do not invalidate this digest.
        final kpiSales = await ref.read(
          teamMemberKpiSalesStreamProvider(request.query).future,
        );
        final summary = TeamSalesSummaryModel.fromSales(kpiSales);
        final repo = ref.read(teamMemberSalesAiRepositoryProvider);
        return repo.loadOrGenerateInsight(
          salonId: request.query.salonId,
          employeeId: request.query.employeeId,
          employeeName: request.query.employeeName,
          summary: summary,
          historyStart: request.historyStart,
          historyEndExclusive: request.historyEndExclusive,
        );
      } on Object {
        return null;
      }
    });
