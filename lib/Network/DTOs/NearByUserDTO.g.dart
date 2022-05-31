// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NearByUserDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearByUserDTO _$NearByUserDTOFromJson(Map<String, dynamic> json) {
  return NearByUserDTO(
    (json['data'] as List).map((e) =>
          UserModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$NearByUserDTOToJson(NearByUserDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
