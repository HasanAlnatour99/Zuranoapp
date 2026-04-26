import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom navigation / rail index for [OwnerDashboardScreen].
class OwnerDashboardModuleIndex extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final ownerDashboardModuleIndexProvider =
    NotifierProvider<OwnerDashboardModuleIndex, int>(
      OwnerDashboardModuleIndex.new,
    );
