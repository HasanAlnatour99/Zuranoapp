import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Uploads service photos to Firebase Storage under
/// `salons/{salonId}/services/{serviceId}/`.
class ServiceImageStorage {
  ServiceImageStorage({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  static const int maxBytes = 5 * 1024 * 1024;

  Reference _objectRef(String salonId, String serviceId, String fileName) {
    return _storage
        .ref()
        .child('salons')
        .child(salonId)
        .child('services')
        .child(serviceId)
        .child(fileName);
  }

  Future<String> uploadServicePhoto({
    required String salonId,
    required String serviceId,
    required Uint8List bytes,
    required String contentType,
  }) async {
    if (bytes.isEmpty) {
      throw ArgumentError('Image data is empty.');
    }
    if (bytes.length > maxBytes) {
      throw ArgumentError('Image exceeds maximum size.');
    }
    final ext = contentType.toLowerCase().contains('png')
        ? 'png'
        : contentType.toLowerCase().contains('webp')
        ? 'webp'
        : 'jpg';
    final name = 'photo_${DateTime.now().millisecondsSinceEpoch}.$ext';
    final ref = _objectRef(salonId, serviceId, name);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }
}
