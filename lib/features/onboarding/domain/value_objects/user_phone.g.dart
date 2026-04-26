// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_phone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPhone _$UserPhoneFromJson(Map<String, dynamic> json) => _UserPhone(
  countryIsoCode: json['countryIsoCode'] as String,
  dialCode: json['dialCode'] as String,
  nationalNumber: json['nationalNumber'] as String,
  e164: json['e164'] as String,
);

Map<String, dynamic> _$UserPhoneToJson(_UserPhone instance) =>
    <String, dynamic>{
      'countryIsoCode': instance.countryIsoCode,
      'dialCode': instance.dialCode,
      'nationalNumber': instance.nationalNumber,
      'e164': instance.e164,
    };
