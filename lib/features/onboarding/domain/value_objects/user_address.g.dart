// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAddress _$UserAddressFromJson(Map<String, dynamic> json) => _UserAddress(
  countryCode: json['countryCode'] as String,
  countryName: json['countryName'] as String,
  city: json['city'] as String,
  street: json['street'] as String,
  building: json['building'] as String?,
  postalCode: json['postalCode'] as String?,
  formattedAddress: json['formattedAddress'] as String,
);

Map<String, dynamic> _$UserAddressToJson(_UserAddress instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'countryName': instance.countryName,
      'city': instance.city,
      'street': instance.street,
      'building': instance.building,
      'postalCode': instance.postalCode,
      'formattedAddress': instance.formattedAddress,
    };
