import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/bookings/logic/booking_recommendation_engine.dart';
import '../features/bookings/logic/booking_recommendation_models.dart';
import '../features/customer/application/customer_public_salon_service_adapter.dart';
import '../features/customer/application/customer_salon_profile_providers.dart';
import '../features/employees/data/models/employee.dart';
import '../features/services/data/models/service.dart';
import 'repository_providers.dart';

final bookingRecommendationProvider = FutureProvider.autoDispose
    .family<RecommendationResult?, BookingRecommendationRequest>((
      ref,
      request,
    ) async {
      final salonRepo = ref.read(salonRepositoryProvider);
      final profileRepo = ref.read(customerSalonProfileRepositoryProvider);
      final bookingRepo = ref.read(bookingRepositoryProvider);
      final metricsRepo = ref.read(barberMetricsRepositoryProvider);

      final salon = await salonRepo.getSalon(request.salonId);
      if (salon == null) {
        return null;
      }

      final team = await profileRepo.fetchBookableTeamMembers(request.salonId);
      final barbers = team
          .map(
            (m) => Employee.customerBookingFromPublicMirror(
              id: m.id,
              salonId: m.salonId,
              displayName: m.displayTitle,
              profileImageUrl: m.profileImageUrl,
            ),
          )
          .toList(growable: false);

      final publicServices = await profileRepo.fetchVisibleServices(
        request.salonId,
      );
      SalonService? service;
      for (final p in publicServices) {
        if (p.id == request.serviceId) {
          service = salonServiceFromCustomerPublic(p);
          break;
        }
      }
      if (service == null) {
        return null;
      }

      final d = request.selectedLocalDay;
      final startLocal = DateTime(d.year, d.month, d.day);
      final endLocal = DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
      final busy = await bookingRepo.fetchDayBusyMask(
        salonId: request.salonId,
        startFromUtc: startLocal.toUtc(),
        startToUtc: endLocal.toUtc(),
      );

      final metrics = await metricsRepo.getForEmployees(
        request.salonId,
        barbers.map((b) => b.id).toList(),
      );

      return BookingRecommendationEngine.compute(
        salon: salon,
        service: service,
        selectedLocalDay: d,
        barbers: barbers,
        dayBusyBookings: busy,
        metricsByEmployeeId: metrics,
        preferredBarberId: request.preferredBarberId,
      );
    });
