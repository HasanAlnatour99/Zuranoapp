import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../../bookings/data/models/booking.dart';
import '../../../sales/data/models/sale.dart';
import '../../data/models/customer.dart';
import 'customer_details_controller.dart';

final customerDetailSalesProvider = StreamProvider.family<List<Sale>, String>((
  ref,
  customerId,
) {
  final user = ref.watch(sessionUserProvider).asData?.value;
  final sid = user?.salonId?.trim() ?? '';
  final cid = customerId.trim();
  if (sid.isEmpty || cid.isEmpty) {
    return Stream.value(const <Sale>[]);
  }
  return ref
      .watch(customerRepositoryProvider)
      .watchCustomerSales(salonId: sid, customerId: cid);
});

final customerDetailUpcomingBookingsProvider =
    StreamProvider.family<List<Booking>, String>((ref, customerId) {
      final user = ref.watch(sessionUserProvider).asData?.value;
      final sid = user?.salonId?.trim() ?? '';
      final cid = customerId.trim();
      if (sid.isEmpty || cid.isEmpty) {
        return Stream.value(const <Booking>[]);
      }
      return ref
          .watch(customerRepositoryProvider)
          .watchUpcomingBookings(salonId: sid, customerId: cid);
    });

final customerDetailsControllerProvider =
    AsyncNotifierProvider<CustomerDetailsController, void>(
      CustomerDetailsController.new,
    );

/// Resolves [Customer] once when needed (e.g. Add Sale deep link).
final customerByIdOnceProvider = FutureProvider.family<Customer?, String>((
  ref,
  customerId,
) async {
  final user = ref.watch(sessionUserProvider).asData?.value;
  final sid = user?.salonId?.trim() ?? '';
  final cid = customerId.trim();
  if (sid.isEmpty || cid.isEmpty) return null;
  return ref.watch(customerRepositoryProvider).getCustomerById(sid, cid);
});
