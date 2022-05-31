// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GenderListDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenderListDTO _$GenderListDTOFromJson(Map<String, dynamic> json) {
  return GenderListDTO(
    (json['gender'] as List).map((e) =>GenderListModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$GenderListDTOToJson(GenderListDTO instance) =>
    <String, dynamic>{
      'gender': instance.gender,
    };
