/// Whether salon-scoped Firestore listeners (under `salons/{salonId}/...`) may run.
bool salonSubcollectionQueriesAllowed(String? salonId) {
  if (salonId == null) {
    return false;
  }
  return salonId.trim().isNotEmpty;
}
