import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/employee_sales_period.dart';

class EmployeeSalesPeriodNotifier extends Notifier<EmployeeSalesPeriod> {
  @override
  EmployeeSalesPeriod build() => EmployeeSalesPeriod.today;

  void setPeriod(EmployeeSalesPeriod period) => state = period;
}

final employeeSalesPeriodProvider =
    NotifierProvider.autoDispose<
      EmployeeSalesPeriodNotifier,
      EmployeeSalesPeriod
    >(EmployeeSalesPeriodNotifier.new);
