// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowRequestDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowRequestDTO _$ShowRequestDTOFromJson(Map<String, dynamic> json) {
  return ShowRequestDTO(
    json['errors'] !=null? ErrorModel.fromJson(json['errors'] as Map<String, dynamic>):ErrorModel([], []),
    (json['data'] as List).map((e) =>
           UserModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ShowRequestDTOToJson(ShowRequestDTO instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };
