// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BlockListDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListDTO _$BlockListDTOFromJson(Map<String, dynamic> json) {
  return BlockListDTO(
    json['errors'] !=null? ErrorModel.fromJson(json['errors'] as Map<String, dynamic>):ErrorModel([], []),
    (json['data'] as List).map((e) =>
          UserModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$BlockListDTOToJson(BlockListDTO instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'data': instance.data,
    };
