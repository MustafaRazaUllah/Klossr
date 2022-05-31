// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GenderListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenderListModel _$GenderListModelFromJson(Map<String, dynamic> json) {
  return GenderListModel(
    json['id'] as int,
    json['gender'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$GenderListModelToJson(GenderListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gender': instance.gender,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
