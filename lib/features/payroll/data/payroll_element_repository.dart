import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/result/app_result.dart';
import '../../../core/result/app_result_guard.dart';
import 'default_payroll_elements.dart';
import 'models/payroll_element_model.dart';

class PayrollElementRepository {
  PayrollElementRepository({
    required FirebaseFirestore firestore,
    required ConnectivityService connectivityService,
    required AppLogger logger,
  }) : _firestore = firestore,
       _connectivityService = connectivityService,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final ConnectivityService _connectivityService;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> _elements(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonPayrollElements(salonId));
  }

  Future<void> seedDefaultElements(String salonId) async {
    final batch = _firestore.batch();
    for (final element in buildDefaultPayrollElements()) {
      final doc = _elements(salonId).doc(element.id);
      batch.set(
        doc,
        FirestoreWritePayload.withServerTimestampsForCreate({
          ...element.copyWith(id: doc.id).toJson(),
          'id': doc.id,
        }),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }

  Future<AppResult<Unit>> seedDefaultElementsResult(String salonId) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'seedDefaultPayrollElements',
      run: () async {
        await seedDefaultElements(salonId);
        return unit;
      },
    );
  }

  Future<String> createElement(
    String salonId,
    PayrollElementModel element,
  ) async {
    final collection = _elements(salonId);
    final document = element.id.isEmpty
        ? collection.doc()
        : collection.doc(element.id);
    await document.set(
      FirestoreWritePayload.withServerTimestampsForCreate({
        ...element.copyWith(id: document.id).toJson(),
        'id': document.id,
      }),
    );
    return document.id;
  }

  Future<AppResult<String>> createElementResult(
    String salonId,
    PayrollElementModel element,
  ) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'createPayrollElement',
      run: () => createElement(salonId, element),
    );
  }

  Future<void> updateElement(String salonId, PayrollElementModel element) {
    return _elements(salonId)
        .doc(element.id)
        .set(
          FirestoreWritePayload.withServerTimestampForUpdate(element.toJson()),
          SetOptions(merge: true),
        );
  }

  Future<AppResult<Unit>> updateElementResult(
    String salonId,
    PayrollElementModel element,
  ) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'updatePayrollElement',
      run: () async {
        await updateElement(salonId, element);
        return unit;
      },
    );
  }

  Future<PayrollElementModel?> getElement(
    String salonId,
    String elementId,
  ) async {
    final snapshot = await _elements(salonId).doc(elementId).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return PayrollElementModel.fromJson(data);
  }

  Future<AppResult<PayrollElementModel?>> getElementResult(
    String salonId,
    String elementId,
  ) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'getPayrollElement',
      run: () => getElement(salonId, elementId),
    );
  }

  Future<List<PayrollElementModel>> getElements(
    String salonId, {
    String? classification,
    bool activeOnly = true,
  }) async {
    Query<Map<String, dynamic>> query = _elements(salonId);
    if (classification != null && classification.isNotEmpty) {
      query = query.where('classification', isEqualTo: classification);
    }
    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }
    query = query.orderBy('displayOrder').orderBy('name');
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => PayrollElementModel.fromJson(doc.data()))
        .toList(growable: false);
  }

  Future<AppResult<List<PayrollElementModel>>> getElementsResult(
    String salonId, {
    String? classification,
    bool activeOnly = true,
  }) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'getPayrollElements',
      run: () => getElements(
        salonId,
        classification: classification,
        activeOnly: activeOnly,
      ),
    );
  }

  Stream<List<PayrollElementModel>> watchElements(
    String salonId, {
    String? classification,
    bool activeOnly = true,
  }) {
    Query<Map<String, dynamic>> query = _elements(salonId);
    if (classification != null && classification.isNotEmpty) {
      query = query.where('classification', isEqualTo: classification);
    }
    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }
    query = query.orderBy('displayOrder').orderBy('name');
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PayrollElementModel.fromJson(doc.data()))
          .toList(growable: false),
    );
  }
}
