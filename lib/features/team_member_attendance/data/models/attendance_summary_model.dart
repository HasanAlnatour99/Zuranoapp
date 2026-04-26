class AttendanceSummaryModel {
  const AttendanceSummaryModel({
    required this.weeklyPresentDays,
    required this.monthlyLateCount,
    required this.monthlyMissingCheckoutCount,
    required this.pendingCorrectionRequests,
  });

  final int weeklyPresentDays;
  final int monthlyLateCount;
  final int monthlyMissingCheckoutCount;
  final int pendingCorrectionRequests;

  static const empty = AttendanceSummaryModel(
    weeklyPresentDays: 0,
    monthlyLateCount: 0,
    monthlyMissingCheckoutCount: 0,
    pendingCorrectionRequests: 0,
  );
}
