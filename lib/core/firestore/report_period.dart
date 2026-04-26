/// Helpers for denormalized `reportYear` / `reportMonth` / `reportPeriodKey` fields.
///
/// **Writes:** always set all three together (use [denormalizedFieldsFor] for maps).
/// **Queries:** existing composite indexes often use `reportYear` + `reportMonth`;
/// documents should still store `reportPeriodKey` for parity and single-field filters.
abstract final class ReportPeriod {
  static int yearFrom(DateTime dt) => dt.toUtc().year;

  static int monthFrom(DateTime dt) => dt.toUtc().month;

  /// Canonical `YYYY-MM` string for equality filters and dashboards.
  static String periodKey(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';

  /// Denormalized reporting fields derived from a UTC calendar anchor (e.g. booking `startAt`).
  static Map<String, dynamic> denormalizedFieldsFor(DateTime anchor) {
    final y = yearFrom(anchor);
    final m = monthFrom(anchor);
    return {
      'reportYear': y,
      'reportMonth': m,
      'reportPeriodKey': periodKey(y, m),
    };
  }

  static (int year, int month)? parsePeriodKey(String? key) {
    if (key == null || key.length < 7) {
      return null;
    }
    final parts = key.split('-');
    if (parts.length < 2) {
      return null;
    }
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (y == null || m == null) {
      return null;
    }
    return (y, m);
  }
}
