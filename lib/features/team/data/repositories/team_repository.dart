import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/sale_reporting.dart';
import '../../../attendance/data/attendance_repository.dart';
import '../../../attendance/data/models/attendance_record.dart';
import '../../../employees/data/models/employee.dart';
import '../../../sales/data/models/sale.dart';
import '../../../sales/data/sales_repository.dart';
import '../models/team_member_model.dart';
import '../models/team_member_today_summary_model.dart';

class TeamRepository {
  TeamRepository({
    required FirebaseFirestore firestore,
    required SalesRepository salesRepository,
    required AttendanceRepository attendanceRepository,
  }) : _firestore = firestore,
       _salesRepository = salesRepository,
       _attendanceRepository = attendanceRepository;

  final FirebaseFirestore _firestore;
  final SalesRepository _salesRepository;
  final AttendanceRepository _attendanceRepository;

  DocumentReference<Map<String, dynamic>> _employeeRef({
    required String salonId,
    required String employeeId,
  }) {
    return _firestore
        .collection('salons')
        .doc(salonId)
        .collection('employees')
        .doc(employeeId);
  }

  /// Live stream of the employee document (same path as [Employee]).
  Stream<TeamMemberModel?> watchTeamMember({
    required String salonId,
    required String employeeId,
    required String currencyCode,
  }) {
    return _employeeRef(
      salonId: salonId,
      employeeId: employeeId,
    ).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      final data = doc.data()!;
      final json = Map<String, dynamic>.from(data);
      json['id'] = doc.id;
      json['salonId'] = salonId;
      final employee = Employee.fromJson(json);
      final phoneE164 = data['phoneE164'] as String?;
      final isFrozen =
          data['isFrozen'] as bool? ??
          employee.status.trim().toLowerCase() == 'frozen';
      return TeamMemberModel.fromEmployee(
        employee,
        currencyCode:
            (data['currencyCode'] as String?)?.trim().isNotEmpty == true
            ? data['currencyCode'] as String
            : currencyCode,
        phoneE164: phoneE164,
        isFrozenOverride: isFrozen,
      );
    });
  }

  Future<TeamMemberTodaySummaryModel> getTodaySummary({
    required String salonId,
    required String employeeId,
    required DateTime now,
  }) async {
    final local = now.toLocal();
    final dayStart = DateTime(local.year, local.month, local.day);
    final dayEnd = DateTime(
      local.year,
      local.month,
      local.day,
      23,
      59,
      59,
      999,
    );
    final todayKey = _dateKey(local);

    final sales = await _salesRepository.getSalesByEmployee(
      salonId,
      employeeId,
      soldFrom: dayStart,
      soldTo: dayEnd,
      limit: 400,
    );

    var totalSales = 0.0;
    var servicesCount = 0;

    for (final sale in sales) {
      if (sale.status != SaleStatuses.completed) continue;
      totalSales += sale.total;
      servicesCount += _serviceCountForSale(sale);
    }

    final attendance = await _attendanceRepository.getAttendance(
      salonId,
      employeeId: employeeId,
      workDateFrom: dayStart,
      workDateTo: dayEnd,
      limit: 20,
    );

    TeamMemberAttendanceDaySummary daySummary =
        TeamMemberAttendanceDaySummary.notCheckedIn;

    AttendanceRecord? pick;
    for (final r in attendance) {
      if (r.dateKey == todayKey ||
          _isSameLocalCalendarDay(r.workDate.toLocal(), local)) {
        pick = r;
        break;
      }
    }
    pick ??= attendance.isEmpty ? null : attendance.first;

    if (pick != null) {
      final st = pick.status.trim().toLowerCase();
      if (st == 'absent') {
        daySummary = TeamMemberAttendanceDaySummary.absent;
      } else if (pick.checkOutAt != null) {
        daySummary = TeamMemberAttendanceDaySummary.checkedOut;
      } else if (pick.checkInAt != null) {
        daySummary = TeamMemberAttendanceDaySummary.checkedIn;
      }
    }

    return TeamMemberTodaySummaryModel(
      todaySales: totalSales,
      servicesCount: servicesCount,
      attendanceDay: daySummary,
    );
  }

  static int _serviceCountForSale(Sale sale) {
    if (sale.lineItems.isEmpty) return 1;
    return sale.lineItems.fold<int>(0, (acc, item) {
      final q = item.quantity < 1 ? 1 : item.quantity;
      return acc + q;
    });
  }

  static bool _isSameLocalCalendarDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dateKey(DateTime date) {
    final local = date.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
