import 'package:cloud_functions/cloud_functions.dart';

/// Server-side policy generation — never embed Gemini keys in Flutter.
class AttendancePolicyCallableService {
  AttendancePolicyCallableService({FirebaseFunctions? functions})
    : _fn = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _fn;

  Future<void> generateAttendancePolicyReadable(String salonId) async {
    final callable = _fn.httpsCallable('generateAttendancePolicyReadable');
    await callable.call(<String, dynamic>{'salonId': salonId});
  }
}
