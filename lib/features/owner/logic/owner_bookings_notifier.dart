import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firestore/firestore_page.dart';
import '../../bookings/data/models/booking.dart';
import '../../../providers/repository_providers.dart';

class OwnerBookingsState {
  const OwnerBookingsState({
    this.items = const [],
    this.lastPage,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.statusFilter = '',
  });

  final List<Booking> items;
  final FirestorePage<Booking>? lastPage;
  final bool isLoading;
  final bool isLoadingMore;
  final String statusFilter;

  OwnerBookingsState copyWith({
    List<Booking>? items,
    FirestorePage<Booking>? lastPage,
    bool? isLoading,
    bool? isLoadingMore,
    String? statusFilter,
  }) {
    return OwnerBookingsState(
      items: items ?? this.items,
      lastPage: lastPage ?? this.lastPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class OwnerBookingsNotifier extends Notifier<OwnerBookingsState> {
  String _salonId = '';

  @override
  OwnerBookingsState build() => const OwnerBookingsState();

  void setSalonId(String salonId) {
    _salonId = salonId.trim();
  }

  Future<void> reload() async {
    if (_salonId.isEmpty) {
      state = state.copyWith(items: [], lastPage: null, isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(bookingRepositoryProvider);
      final page = await repo.getBookingsPage(
        _salonId,
        limit: 30,
        status: state.statusFilter.isEmpty ? null : state.statusFilter,
      );
      state = state.copyWith(
        items: page.items,
        lastPage: page,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMore() async {
    final prev = state.lastPage;
    if (_salonId.isEmpty ||
        prev == null ||
        !prev.hasMore ||
        state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);
    try {
      final repo = ref.read(bookingRepositoryProvider);
      final page = await repo.getBookingsNextPage(
        _salonId,
        prev,
        status: state.statusFilter.isEmpty ? null : state.statusFilter,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        lastPage: page,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setStatusFilter(String status) {
    if (state.statusFilter == status) return;
    state = state.copyWith(statusFilter: status);
    reload();
  }
}

final ownerBookingsNotifierProvider =
    NotifierProvider<OwnerBookingsNotifier, OwnerBookingsState>(
      OwnerBookingsNotifier.new,
    );
