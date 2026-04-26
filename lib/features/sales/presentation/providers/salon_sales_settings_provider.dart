import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../data/models/salon_sales_settings.dart';

final salonSalesSettingsStreamProvider =
    StreamProvider.autoDispose<SalonSalesSettings>((ref) {
      final user = ref.watch(sessionUserProvider).asData?.value;
      final sid = user?.salonId?.trim();
      if (sid == null || sid.isEmpty) {
        return Stream.value(SalonSalesSettings.defaults());
      }
      return ref.watch(salonSalesSettingsRepositoryProvider).watchSettings(sid);
    });
