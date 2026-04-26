import 'package:flutter/services.dart';

/// Allows digits and short separators for the national segment of a phone.
class NationalPhoneInputFormatter extends FilteringTextInputFormatter {
  NationalPhoneInputFormatter() : super.allow(RegExp(r'[0-9\s\-]{0,20}'));
}
