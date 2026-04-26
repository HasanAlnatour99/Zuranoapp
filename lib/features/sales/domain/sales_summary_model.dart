/// Aggregated KPIs for the Sales dashboard hero and tiles.
class SalesSummaryModel {
  const SalesSummaryModel({
    required this.totalSales,
    required this.transactionsCount,
    required this.averageTicket,
    this.topBarberName,
    this.topBarberId,
    this.topBarberImageUrl,
    this.topServiceName,
  });

  final double totalSales;
  final int transactionsCount;
  final double averageTicket;
  final String? topBarberName;
  final String? topBarberId;
  final String? topBarberImageUrl;
  final String? topServiceName;
}
