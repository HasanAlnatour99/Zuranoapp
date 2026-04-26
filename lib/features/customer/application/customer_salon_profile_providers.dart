import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/firebase_providers.dart';
import '../data/models/customer_review_model.dart';
import '../data/models/customer_service_public_model.dart';
import '../data/models/customer_team_member_public_model.dart';
import '../data/models/salon_public_model.dart';
import '../data/repositories/customer_salon_profile_repository.dart';

final customerSalonProfileRepositoryProvider =
    Provider<CustomerSalonProfileRepository>((ref) {
      return FirestoreCustomerSalonProfileRepository(
        ref.watch(firestoreProvider),
      );
    });

final customerSalonProfileProvider =
    StreamProvider.family<SalonPublicModel?, String>((ref, salonId) {
      return ref
          .watch(customerSalonProfileRepositoryProvider)
          .watchSalonProfile(salonId);
    });

final customerVisibleServicesProvider =
    StreamProvider.family<List<CustomerServicePublicModel>, String>((
      ref,
      salonId,
    ) {
      return ref
          .watch(customerSalonProfileRepositoryProvider)
          .watchVisibleServices(salonId);
    });

final customerBookableTeamMembersProvider =
    StreamProvider.family<List<CustomerTeamMemberPublicModel>, String>((
      ref,
      salonId,
    ) {
      return ref
          .watch(customerSalonProfileRepositoryProvider)
          .watchBookableTeamMembers(salonId);
    });

final customerSalonReviewsProvider =
    StreamProvider.family<List<CustomerReviewModel>, String>((ref, salonId) {
      return ref
          .watch(customerSalonProfileRepositoryProvider)
          .watchSalonReviews(salonId);
    });
