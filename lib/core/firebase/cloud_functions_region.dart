import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

/// Region for Gen-2 HTTPS callables (must match `functions/src` deployment).
FirebaseFunctions appCloudFunctions() {
  return FirebaseFunctions.instanceFor(
    app: Firebase.app(),
    region: 'us-central1',
  );
}
