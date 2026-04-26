import '../models/ai_surface_response.dart';

abstract class OwnerDashboardAiRepository {
  Future<SalonRevenueSummary> getSalonRevenueSummary({
    required String salonId,
    required AiTimeframe timeframe,
  });

  Future<List<TopBarberSnapshot>> getTopBarbers({
    required String salonId,
    required AiTimeframe timeframe,
  });
}
