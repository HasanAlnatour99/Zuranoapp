import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/firebase_providers.dart';
import '../../../../../features/customer/data/models/customer_booking_settings_model.dart';
import '../../../../../features/customer/data/repositories/customer_booking_settings_repository.dart';

final customerBookingSettingsRepositoryProvider =
    Provider<CustomerBookingSettingsRepository>((ref) {
      return CustomerBookingSettingsRepository(
        firestore: ref.watch(firestoreProvider),
      );
    });

/// Owner/admin policy document: `salons/{salonId}/settings/customerBooking`.
final customerBookingSettingsProvider =
    StreamProvider.family<CustomerBookingSettingsModel, String>((ref, salonId) {
      return ref
          .watch(customerBookingSettingsRepositoryProvider)
          .watchSettings(salonId.trim());
    });

final customerBookingSettingsControllerProvider =
    AsyncNotifierProvider<CustomerBookingSettingsController, void>(
      CustomerBookingSettingsController.new,
    );

class CustomerBookingSettingsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> save({
    required String salonId,
    required CustomerBookingSettingsModel settings,
    required String updatedByUid,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(customerBookingSettingsRepositoryProvider)
          .saveSettings(
            salonId: salonId,
            settings: settings,
            updatedByUid: updatedByUid,
          ),
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
