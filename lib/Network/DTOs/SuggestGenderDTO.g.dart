// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SuggestGenderDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestGenderDTO _$SuggestGenderDTOFromJson(Map<String, dynamic> json) {
  return SuggestGenderDTO(
    json['message']!=null ?json['message'] as String: "",
    json['image_url']!=null?json['image_url'] as String:"",
  );
}

Map<String, dynamic> _$SuggestGenderDTOToJson(SuggestGenderDTO instance) =>
    <String, dynamic>{
      'message': instance.message,
      'image_url': instance.image_url,
    };
