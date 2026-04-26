import 'package:freezed_annotation/freezed_annotation.dart';

/// Shared address shape for users and salons (`address` map in Firestore).
part 'user_address.freezed.dart';
part 'user_address.g.dart';

@freezed
abstract class UserAddress with _$UserAddress {
  const factory UserAddress({
    required String countryCode,
    required String countryName,
    required String city,
    required String street,
    String? building,
    String? postalCode,
    required String formattedAddress,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);

  factory UserAddress.customerProfile({
    required String countryCode,
    required String countryName,
    required String city,
    required String street,
    String? building,
    String? postalCode,
  }) {
    final parts = <String>[
      street.trim(),
      if (building != null && building.trim().isNotEmpty) building.trim(),
      city.trim(),
      if (postalCode != null && postalCode.trim().isNotEmpty) postalCode.trim(),
      countryName.trim(),
    ].where((e) => e.isNotEmpty).toList();

    return UserAddress(
      countryCode: countryCode.toUpperCase(),
      countryName: countryName.trim(),
      city: city.trim(),
      street: street.trim(),
      building: building?.trim().isEmpty ?? true ? null : building!.trim(),
      postalCode: postalCode?.trim().isEmpty ?? true
          ? null
          : postalCode!.trim(),
      formattedAddress: parts.join(', '),
    );
  }

  factory UserAddress.salonLocation({
    required String countryCode,
    required String countryName,
    required String city,
    required String street,
    required String building,
    String? postalCode,
  }) {
    final parts = <String>[
      street.trim(),
      building.trim(),
      city.trim(),
      if (postalCode != null && postalCode.trim().isNotEmpty) postalCode.trim(),
      countryName.trim(),
    ].where((e) => e.isNotEmpty).toList();

    return UserAddress(
      countryCode: countryCode.toUpperCase(),
      countryName: countryName.trim(),
      city: city.trim(),
      street: street.trim(),
      building: building.trim(),
      postalCode: postalCode?.trim().isEmpty ?? true
          ? null
          : postalCode!.trim(),
      formattedAddress: parts.join(', '),
    );
  }

  const UserAddress._();
}
