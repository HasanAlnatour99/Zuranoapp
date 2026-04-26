import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/firebase_providers.dart';
import '../data/models/customer_booking_lookup_model.dart';
import '../data/repositories/customer_booking_lookup_repository.dart';
import 'customer_phone_normalizer.dart';

enum CustomerBookingLookupError { invalidPhone }

class CustomerBookingLookupException implements Exception {
  const CustomerBookingLookupException(this.error);

  final CustomerBookingLookupError error;
}

final customerBookingLookupRepositoryProvider =
    Provider<CustomerBookingLookupRepository>((ref) {
      return FirestoreCustomerBookingLookupRepository(
        ref.watch(firestoreProvider),
      );
    });

final customerBookingLookupControllerProvider =
    AsyncNotifierProvider<
      CustomerBookingLookupController,
      List<CustomerBookingLookupModel>?
    >(CustomerBookingLookupController.new);

class CustomerBookingLookupController
    extends AsyncNotifier<List<CustomerBookingLookupModel>?> {
  @override
  Future<List<CustomerBookingLookupModel>?> build() async => null;

  Future<List<CustomerBookingLookupModel>?> search({
    required String phoneInput,
    String? bookingCode,
  }) async {
    final phoneNormalized = CustomerPhoneNormalizer.normalizePhone(phoneInput);
    final normalizedBookingCode = bookingCode?.trim().toUpperCase();

    if (!CustomerPhoneNormalizer.isValidPhone(phoneNormalized)) {
      final error = const CustomerBookingLookupException(
        CustomerBookingLookupError.invalidPhone,
      );
      state = AsyncValue.error(error, StackTrace.current);
      return null;
    }

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref
          .read(customerBookingLookupRepositoryProvider)
          .findBookings(
            phoneNormalized: phoneNormalized,
            bookingCode: normalizedBookingCode?.isEmpty == true
                ? null
                : normalizedBookingCode,
            salonIdForPolicy: null,
          ),
    );
    state = result;
    return result.when(
      data: (value) => value,
      error: (_, _) => null,
      loading: () => null,
    );
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
