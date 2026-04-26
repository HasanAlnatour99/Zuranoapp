import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import '../../../core/result/app_result.dart';
import '../../../core/result/app_result_guard.dart';
import 'models/employee.dart';

class EmployeeRepository {
  EmployeeRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required ConnectivityService connectivityService,
    required AppLogger logger,
  }) : _firestore = firestore,
       _storage = storage,
       _connectivityService = connectivityService,
       _logger = logger;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ConnectivityService _connectivityService;
  final AppLogger _logger;

  CollectionReference<Map<String, dynamic>> _employees(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonEmployees(salonId));
  }

  Future<String> createEmployee(String salonId, Employee employee) async {
    final collection = _employees(salonId);
    final document = employee.id.isEmpty
        ? collection.doc()
        : collection.doc(employee.id);
    final payload = FirestoreWritePayload.withServerTimestampsForCreate(
      employee.copyWith(id: document.id).toJson(),
    );

    await document.set(payload);
    return document.id;
  }

  Future<AppResult<String>> createEmployeeResult(
    String salonId,
    Employee employee,
  ) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'createEmployee',
      run: () => createEmployee(salonId, employee),
    );
  }

  Future<void> updateEmployee(String salonId, Employee employee) {
    return _employees(salonId)
        .doc(employee.id)
        .set(
          FirestoreWritePayload.withServerTimestampForUpdate(employee.toJson()),
          SetOptions(merge: true),
        );
  }

  Future<AppResult<Unit>> updateEmployeeResult(
    String salonId,
    Employee employee,
  ) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'updateEmployee',
      run: () async {
        await updateEmployee(salonId, employee);
        return unit;
      },
    );
  }

  Future<Employee?> getEmployee(String salonId, String employeeId) async {
    final snapshot = await _employees(salonId).doc(employeeId).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }

    return Employee.fromJson(data);
  }

  Future<AppResult<Employee?>> getEmployeeResult(
    String salonId,
    String employeeId,
  ) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'getEmployee',
      run: () => getEmployee(salonId, employeeId),
    );
  }

  Future<List<Employee>> getEmployees(
    String salonId, {
    bool onlyActive = true,
  }) async {
    Query<Map<String, dynamic>> query = _employees(salonId);
    if (onlyActive) {
      query = query.where('isActive', isEqualTo: true);
    }
    final snapshot = await query.get();
    final list = snapshot.docs
        .map((doc) => Employee.fromJson(doc.data()))
        .toList(growable: false);
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  Future<AppResult<List<Employee>>> getEmployeesResult(
    String salonId, {
    bool onlyActive = true,
  }) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'getEmployees',
      run: () => getEmployees(salonId, onlyActive: onlyActive),
    );
  }

  Stream<List<Employee>> watchEmployees(
    String salonId, {
    String? role,
    bool onlyActive = true,
  }) {
    Query<Map<String, dynamic>> query = _employees(
      salonId,
    ).orderBy('name').orderBy('createdAt', descending: true);

    if (onlyActive) {
      query = query.where('isActive', isEqualTo: true);
    }

    if (role != null && role.isNotEmpty) {
      query = query.where('role', isEqualTo: role);
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Employee.fromJson(doc.data())).toList(),
    );
  }

  Future<void> setEmployeeActiveState({
    required String salonId,
    required String employeeId,
    required bool isActive,
  }) {
    return _employees(salonId)
        .doc(employeeId)
        .set(
          FirestoreWritePayload.withServerTimestampForUpdate({
            'isActive': isActive,
            'status': isActive ? 'active' : 'inactive',
          }),
          SetOptions(merge: true),
        );
  }

  Future<AppResult<Unit>> setEmployeeActiveStateResult({
    required String salonId,
    required String employeeId,
    required bool isActive,
  }) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'setEmployeeActiveState',
      run: () async {
        await setEmployeeActiveState(
          salonId: salonId,
          employeeId: employeeId,
          isActive: isActive,
        );
        return unit;
      },
    );
  }

  Future<String> uploadProfilePhoto({
    required String salonId,
    required String employeeId,
    required File file,
  }) async {
    final ref = _storage.ref().child(
      'salons/$salonId/employees/$employeeId/profile/profile_photo.jpg',
    );
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.ref.getDownloadURL();
  }

  Future<String> uploadEmployeeProfilePhoto({
    required String salonId,
    required String employeeId,
    required XFile image,
  }) async {
    final file = File(image.path);
    final ref = _storage.ref().child(
      'salons/$salonId/employees/$employeeId/profile/profile_photo.jpg',
    );
    final task = await ref.putFile(
      file,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'salonId': salonId, 'employeeId': employeeId},
      ),
    );
    return task.ref.getDownloadURL();
  }

  Future<void> updateEmployeePhoto({
    required String salonId,
    required String employeeId,
    required String photoUrl,
  }) async {
    await _employees(salonId).doc(employeeId).set({
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> clearEmployeePhoto({
    required String salonId,
    required String employeeId,
  }) async {
    await _employees(salonId).doc(employeeId).set({
      'photoUrl': null,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
