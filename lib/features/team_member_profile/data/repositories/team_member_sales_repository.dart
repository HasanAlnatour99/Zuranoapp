import '../../../sales/data/models/sale.dart';
import '../../../sales/data/sales_repository.dart';

/// Team member profile sales reads (Firestore paths stay under [SalesRepository]).
class TeamMemberSalesRepository {
  TeamMemberSalesRepository({required SalesRepository salesRepository})
    : _sales = salesRepository;

  final SalesRepository _sales;

  Stream<List<Sale>> watchEmployeeSalesByDateRange({
    required String salonId,
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
    int limit = 400,
  }) {
    return _sales.watchEmployeeCompletedSalesByDateRange(
      salonId: salonId,
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }

  Future<List<Sale>> getEmployeeSalesForAnalysis({
    required String salonId,
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
    int limit = 400,
  }) {
    return _sales.getEmployeeCompletedSalesForAnalysis(
      salonId: salonId,
      employeeId: employeeId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
  }
}
