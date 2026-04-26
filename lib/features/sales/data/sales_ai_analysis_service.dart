import 'models/sale.dart';

/// Reserved for internal sale checks / summaries. Does not block saving and
/// performs no user-visible "AI" messaging.
class SalesAiAnalysisService {
  const SalesAiAnalysisService();

  Future<void> maybeWriteInternalSummary({
    required String salonId,
    required String saleId,
    required Sale sale,
  }) async {}
}
