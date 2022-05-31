// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SignUpDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpDTO _$SignUpDTOFromJson(Map<String, dynamic> json) {
  return SignUpDTO(
    json['errors'] !=null? ErrorModel.fromJson(json['errors'] as Map<String, dynamic>):ErrorModel([], []),
    json['message'] as String,
    json['user']!=null?UserModel.fromJson(json['user'] as Map<String, dynamic>):UserModel(0, "", "", "", "", "", UserInfoModel(0, false, "", "", GenderListModel(0,"","","")),0.0 ,0.0 ,[],"" ),
  );
}

Map<String, dynamic> _$SignUpDTOToJson(SignUpDTO instance) => <String, dynamic>{
      'errors': instance.errors,
      'message': instance.message,
      'user': instance.user,
    };
