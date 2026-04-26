import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Current Firebase Auth uid, or `null` when signed out (diagnostics / tools).
/// Do not use this alone for go_router redirects — pair with the Firestore
/// profile stream so “signed in but no `users/{uid}`” is not treated as signed out.
final firebaseAuthUidProvider = StreamProvider<String?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges().map((user) => user?.uid);
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Customer booking HTTPS callables (must match `functions/src` region).
// TODO(me-west1): Align region with Middle East deployment when ready.
final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  return FirebaseFunctions.instanceFor(
    app: Firebase.app(),
    region: 'us-central1',
  );
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});
