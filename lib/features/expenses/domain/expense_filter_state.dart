import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ExpensesDatePreset { today, thisWeek, thisMonth, custom }

class ExpensesFilterState {
  const ExpensesFilterState({
    this.datePreset = ExpensesDatePreset.thisMonth,
    this.customRange,
    this.category,
    this.paymentMethod,
    this.createdByUid,
  });

  final ExpensesDatePreset datePreset;
  final DateTimeRange? customRange;
  final String? category;
  final String? paymentMethod;
  final String? createdByUid;

  ExpensesFilterState copyWith({
    ExpensesDatePreset? datePreset,
    Object? customRange = _sentinel,
    Object? category = _sentinel,
    Object? paymentMethod = _sentinel,
    Object? createdByUid = _sentinel,
  }) {
    return ExpensesFilterState(
      datePreset: datePreset ?? this.datePreset,
      customRange: identical(customRange, _sentinel)
          ? this.customRange
          : customRange as DateTimeRange?,
      category: identical(category, _sentinel)
          ? this.category
          : category as String?,
      paymentMethod: identical(paymentMethod, _sentinel)
          ? this.paymentMethod
          : paymentMethod as String?,
      createdByUid: identical(createdByUid, _sentinel)
          ? this.createdByUid
          : createdByUid as String?,
    );
  }
}

class ExpensesFiltersNotifier extends Notifier<ExpensesFilterState> {
  @override
  ExpensesFilterState build() => const ExpensesFilterState();

  void setDatePreset(ExpensesDatePreset preset) {
    state = state.copyWith(
      datePreset: preset,
      customRange: preset == ExpensesDatePreset.custom
          ? state.customRange
          : null,
    );
  }

  void setCustomRange(DateTimeRange? range) {
    state = state.copyWith(
      datePreset: range == null ? state.datePreset : ExpensesDatePreset.custom,
      customRange: range,
    );
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setPaymentMethod(String? paymentMethod) {
    state = state.copyWith(paymentMethod: paymentMethod);
  }

  void setCreatedByUid(String? uid) {
    state = state.copyWith(createdByUid: uid);
  }

  void clearFilters() {
    state = state.copyWith(
      category: null,
      paymentMethod: null,
      createdByUid: null,
    );
  }
}

final expensesFiltersProvider =
    NotifierProvider<ExpensesFiltersNotifier, ExpensesFilterState>(
      ExpensesFiltersNotifier.new,
    );

const Object _sentinel = Object();
