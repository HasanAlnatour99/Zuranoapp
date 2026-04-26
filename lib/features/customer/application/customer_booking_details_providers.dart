import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/firebase_providers.dart';
import '../data/models/customer_booking_details_model.dart';
import '../data/repositories/customer_booking_details_repository.dart';

typedef CustomerBookingDetailsArgs = ({String salonId, String bookingId});

final customerBookingDetailsRepositoryProvider =
    Provider<CustomerBookingDetailsRepository>((ref) {
      return FirestoreCustomerBookingDetailsRepository(
        ref.watch(firestoreProvider),
      );
    });

/// Loads merged booking + public salon row for the customer details screen.
final customerBookingDetailsProvider = FutureProvider.autoDispose
    .family<CustomerBookingDetailsModel?, CustomerBookingDetailsArgs>((
      ref,
      args,
    ) async {
      final repo = ref.watch(customerBookingDetailsRepositoryProvider);
      return repo.getBookingDetails(
        salonId: args.salonId,
        bookingId: args.bookingId,
      );
    });
