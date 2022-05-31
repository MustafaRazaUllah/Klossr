// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ErrorModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) {
  return ErrorModel(
    (json['username'] as List).map((e) => e as String).toList(),
    (json['email'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
    };
