import 'package:barber_shop_app/core/firestore/salon_query_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('salonSubcollectionQueriesAllowed rejects null, empty, whitespace', () {
    expect(salonSubcollectionQueriesAllowed(null), false);
    expect(salonSubcollectionQueriesAllowed(''), false);
    expect(salonSubcollectionQueriesAllowed('   '), false);
  });

  test('salonSubcollectionQueriesAllowed accepts non-empty id', () {
    expect(salonSubcollectionQueriesAllowed('abc'), true);
    expect(salonSubcollectionQueriesAllowed('  x  '), true);
  });
}
