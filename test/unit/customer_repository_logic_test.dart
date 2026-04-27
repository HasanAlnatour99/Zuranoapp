import 'package:barber_shop_app/features/customers/data/customer_repository.dart';
import 'package:barber_shop_app/features/customers/data/models/customer.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit - soft delete customer behavior', () {
    test('deleteCustomer keeps doc and sets isActive to false', () async {
      final firestore = FakeFirebaseFirestore();
      final repository = CustomerRepository(firestore: firestore);
      await firestore
          .collection('salons')
          .doc('salon-1')
          .collection('customers')
          .doc('c-1')
          .set({
            'id': 'c-1',
            'salonId': 'salon-1',
            'fullName': 'Ali',
            'phone': '5550000',
            'isActive': true,
            'createdBy': 'u-1',
          });

      await repository.deleteCustomer('salon-1', 'c-1');

      final snap = await firestore
          .collection('salons')
          .doc('salon-1')
          .collection('customers')
          .doc('c-1')
          .get();
      expect(snap.exists, isTrue);
      expect(snap.data()?['isActive'], isFalse);
    });
  });

  group('Unit - customer search normalization', () {
    test('normalizeCustomerName trims, lowers and collapses whitespace', () {
      expect(normalizeCustomerName('  AHMAD   SALEH  '), 'ahmad saleh');
    });

    test('normalizeCustomerPhone keeps digits only', () {
      expect(normalizeCustomerPhone('+974 5500-1122'), '97455001122');
    });

    test(
      'Arabic search matches normalized Arabic name',
      () async {
        final firestore = FakeFirebaseFirestore();
        final repository = CustomerRepository(firestore: firestore);
        await firestore
            .collection('salons')
            .doc('salon-1')
            .collection('customers')
            .doc('c-ar')
            .set({
              'id': 'c-ar',
              'salonId': 'salon-1',
              'fullName': 'أحمد علي',
              'phone': '5550000',
              'isActive': true,
              'createdBy': 'u-1',
              'searchKeywords': ['أ', 'أح', 'أحم', 'أحمد'],
            });

        final results = await repository.searchCustomers('salon-1', 'أحمد');
        expect(results.map((c) => c.id), contains('c-ar'));
      },
      tags: ['critical', 'localization'],
    );
  });
}
