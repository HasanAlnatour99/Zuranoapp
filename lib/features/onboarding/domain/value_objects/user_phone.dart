import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/phone_normalizer.dart';

/// Normalized phone payload for `users/{uid}.phone`.
part 'user_phone.freezed.dart';
part 'user_phone.g.dart';

@freezed
abstract class UserPhone with _$UserPhone {
  const factory UserPhone({
    required String countryIsoCode,
    required String dialCode,
    required String nationalNumber,
    required String e164,
  }) = _UserPhone;

  factory UserPhone.fromJson(Map<String, dynamic> json) =>
      _$UserPhoneFromJson(json);

  /// Builds E.164-style storage from [dialCode] (e.g. `+966`) and [nationalDigits].
  factory UserPhone.fromDialAndNational({
    required String countryIsoCode,
    required String dialCode,
    required String nationalDigits,
  }) {
    final digitsOnly = nationalDigits.replaceAll(RegExp(r'\D'), '');
    final dial = dialCode.startsWith('+') ? dialCode : '+$dialCode';
    final dialDigits = dial.replaceAll(RegExp(r'\D'), '');
    final combined = '$dialDigits$digitsOnly';
    final e164 = combined.isEmpty ? '' : '+$combined';

    return UserPhone(
      countryIsoCode: countryIsoCode.toUpperCase(),
      dialCode: dial,
      nationalNumber: digitsOnly,
      e164: PhoneNormalizer.normalizeForStorage(e164),
    );
  }

  const UserPhone._();
}
