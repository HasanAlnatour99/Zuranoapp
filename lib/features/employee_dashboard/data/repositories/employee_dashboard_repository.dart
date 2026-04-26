import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/sale_reporting.dart';
import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_write_payload.dart';
import '../../../sales/data/models/sale.dart';
import '../models/employee_today_summary_model.dart';
import 'employee_attendance_repository.dart';

class EmployeeDashboardRepository {
  EmployeeDashboardRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  ({DateTime start, DateTime endExclusive}) _localDayBounds(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final endExclusive = start.add(const Duration(days: 1));
    return (start: start, endExclusive: endExclusive);
  }

  Future<EmployeeTodaySummaryModel> loadTodaySummary({
    required String salonId,
    required String employeeId,
    required DateTime day,
    required String workedHoursLabel,
  }) async {
    FirestoreWritePayload.assertSalonId(salonId);
    final bounds = _localDayBounds(day);
    final q = await _firestore
        .collection(FirestorePaths.salonSales(salonId))
        .where('employeeId', isEqualTo: employeeId)
        .where('status', isEqualTo: SaleStatuses.completed)
        .where(
          'soldAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(bounds.start),
        )
        .where('soldAt', isLessThan: Timestamp.fromDate(bounds.endExclusive))
        .orderBy('soldAt', descending: true)
        .limit(200)
        .get();

    var services = 0;
    var total = 0.0;
    var commission = 0.0;
    for (final doc in q.docs) {
      final sale = Sale.fromJson(doc.data());
      total += sale.total;
      commission += sale.commissionAmount ?? 0;
      for (final line in sale.lineItems) {
        services += line.quantity;
      }
    }

    return EmployeeTodaySummaryModel(
      servicesCount: services,
      salesTotal: total,
      commissionEstimate: commission,
      workedHoursLabel: workedHoursLabel,
    );
  }

  Stream<List<Sale>> watchSalesInRange({
    required String salonId,
    required String employeeId,
    required DateTime rangeStart,
    required DateTime rangeEndExclusive,
    int limit = 120,
  }) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore
        .collection(FirestorePaths.salonSales(salonId))
        .where('employeeId', isEqualTo: employeeId)
        .where('status', isEqualTo: SaleStatuses.completed)
        .where('soldAt', isGreaterThanOrEqualTo: Timestamp.fromDate(rangeStart))
        .where('soldAt', isLessThan: Timestamp.fromDate(rangeEndExclusive))
        .orderBy('soldAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Sale.fromJson(d.data()))
              .toList(growable: false),
        );
  }

  static String todayDateKey(DateTime d) =>
      EmployeeAttendanceRepository.compactDateKey(d);
}
