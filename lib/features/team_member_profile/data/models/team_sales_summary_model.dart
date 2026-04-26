import '../../../sales/data/models/sale.dart';

class TopSoldServiceModel {
  const TopSoldServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.totalRevenue,
  });

  final String serviceId;
  final String serviceName;
  final int quantity;
  final double totalRevenue;
}

class TeamSalesSummaryModel {
  const TeamSalesSummaryModel({
    required this.revenueToday,
    required this.revenueThisWeek,
    required this.revenueThisMonth,
    required this.servicesToday,
    required this.servicesThisMonth,
    required this.averageTicketValue,
    required this.topSoldServices,
  });

  final double revenueToday;
  final double revenueThisWeek;
  final double revenueThisMonth;
  final int servicesToday;
  final int servicesThisMonth;
  final double averageTicketValue;
  final List<TopSoldServiceModel> topSoldServices;

  static int serviceCountForSale(Sale sale) {
    if (sale.lineItems.isEmpty) {
      return 1;
    }
    return sale.lineItems.fold<int>(
      0,
      (sum, line) => sum + (line.quantity < 1 ? 1 : line.quantity),
    );
  }

  factory TeamSalesSummaryModel.empty() {
    return const TeamSalesSummaryModel(
      revenueToday: 0,
      revenueThisWeek: 0,
      revenueThisMonth: 0,
      servicesToday: 0,
      servicesThisMonth: 0,
      averageTicketValue: 0,
      topSoldServices: [],
    );
  }

  factory TeamSalesSummaryModel.fromSales(List<Sale> sales) {
    final now = DateTime.now();

    bool isSameDay(DateTime a, DateTime b) {
      final al = a.toLocal();
      final bl = b.toLocal();
      return al.year == bl.year && al.month == bl.month && al.day == bl.day;
    }

    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = DateTime(now.year, now.month, now.day + 1);

    final startOfWeek = todayStart.subtract(
      Duration(days: todayStart.weekday - DateTime.monday),
    );

    final startOfMonth = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    final todaySales = sales
        .where((s) => isSameDay(s.soldAt.toLocal(), now))
        .toList();

    final weekSales = sales.where((s) {
      final sold = s.soldAt.toLocal();
      return !sold.isBefore(startOfWeek) && sold.isBefore(tomorrowStart);
    }).toList();

    final monthSales = sales.where((s) {
      final sold = s.soldAt.toLocal();
      return !sold.isBefore(startOfMonth) && sold.isBefore(nextMonth);
    }).toList();

    final revenueToday = todaySales.fold<double>(0, (sum, s) => sum + s.total);

    final revenueThisWeek = weekSales.fold<double>(
      0,
      (sum, s) => sum + s.total,
    );

    final revenueThisMonth = monthSales.fold<double>(
      0,
      (sum, s) => sum + s.total,
    );

    final servicesToday = todaySales.fold<int>(
      0,
      (sum, s) => sum + serviceCountForSale(s),
    );

    final servicesThisMonth = monthSales.fold<int>(
      0,
      (sum, s) => sum + serviceCountForSale(s),
    );

    final double averageTicketValue = monthSales.isEmpty
        ? 0
        : revenueThisMonth / monthSales.length;

    final grouped = <String, TopSoldServiceModel>{};
    for (final sale in monthSales) {
      if (sale.lineItems.isEmpty) {
        final key = sale.serviceNames.isEmpty
            ? 'sale:${sale.id}'
            : sale.serviceNames.first;
        final existing = grouped[key];
        grouped[key] = TopSoldServiceModel(
          serviceId: '',
          serviceName: sale.serviceNames.isEmpty
              ? key
              : sale.serviceNames.first,
          quantity: (existing?.quantity ?? 0) + 1,
          totalRevenue: (existing?.totalRevenue ?? 0) + sale.total,
        );
        continue;
      }
      for (final line in sale.lineItems) {
        final key = line.serviceId.isEmpty
            ? 'name:${line.serviceName}'
            : line.serviceId;
        final existing = grouped[key];
        final qty = line.quantity < 1 ? 1 : line.quantity;
        grouped[key] = TopSoldServiceModel(
          serviceId: line.serviceId,
          serviceName: line.serviceName,
          quantity: (existing?.quantity ?? 0) + qty,
          totalRevenue: (existing?.totalRevenue ?? 0) + line.total,
        );
      }
    }

    final topServices = grouped.values.toList()
      ..sort((a, b) {
        final c = b.quantity.compareTo(a.quantity);
        if (c != 0) {
          return c;
        }
        return b.totalRevenue.compareTo(a.totalRevenue);
      });

    return TeamSalesSummaryModel(
      revenueToday: revenueToday,
      revenueThisWeek: revenueThisWeek,
      revenueThisMonth: revenueThisMonth,
      servicesToday: servicesToday,
      servicesThisMonth: servicesThisMonth,
      averageTicketValue: averageTicketValue,
      topSoldServices: topServices.take(5).toList(),
    );
  }
}
