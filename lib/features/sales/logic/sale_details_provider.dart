import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../data/models/sale.dart';

final saleDetailsProvider = FutureProvider.family<Sale?, String>((
  ref,
  saleId,
) async {
  final trimmedSaleId = saleId.trim();
  if (trimmedSaleId.isEmpty) {
    return null;
  }

  final session = await ref.watch(sessionUserProvider.future);
  final salonId = session?.salonId?.trim();
  if (salonId == null || salonId.isEmpty) {
    return null;
  }

  return ref.read(salesRepositoryProvider).getSale(salonId, trimmedSaleId);
});
