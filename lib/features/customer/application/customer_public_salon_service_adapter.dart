import '../../services/data/models/service.dart';
import '../data/models/customer_service_public_model.dart';

/// Maps customer-safe public service rows to [SalonService] for booking flows.
SalonService salonServiceFromCustomerPublic(CustomerServicePublicModel service) {
  return SalonService(
    id: service.id,
    salonId: service.salonId,
    name: service.name.trim().isNotEmpty ? service.name.trim() : service.displayTitle,
    serviceName: service.displayTitle,
    durationMinutes: service.durationMinutes > 0 ? service.durationMinutes : 30,
    price: service.price,
    description: service.description,
    category: service.category,
    categoryLabel: service.categoryLabel,
    imageUrl: service.imageUrl,
    isActive: service.isActive,
    bookable: service.isCustomerVisible,
    createdAt: service.createdAt,
    updatedAt: service.updatedAt,
  );
}
