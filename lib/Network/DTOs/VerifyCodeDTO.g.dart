// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifyCodeDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyCodeDTO _$VerifyCodeDTOFromJson(Map<String, dynamic> json) {
  return VerifyCodeDTO(
    json['messages'] as String,
    json['remember_token'] as String,
  );
}

Map<String, dynamic> _$VerifyCodeDTOToJson(VerifyCodeDTO instance) =>
    <String, dynamic>{
      'messages': instance.message,
      'remember_token': instance.remember_token,
    };
