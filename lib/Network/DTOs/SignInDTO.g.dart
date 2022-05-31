// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SignInDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInDTO _$SignInDTOFromJson(Map<String, dynamic> json) {
  return SignInDTO(
    json['errors'] !=null? ErrorModel.fromJson(json['errors'] as Map<String, dynamic>):ErrorModel([], []),
    json['message']!=null?json['message'] as String:"",
    json['user']!=null?UserModel.fromJson(json['user'] as Map<String, dynamic>):UserModel(0, "", "", "", "", "", UserInfoModel(0, false, "", "", GenderListModel(0,"","","")),0.0 ,0.0 ,[],"" ),
    json['token']!=null?json['token'] as String:"",
    json['type']!=null?json['type'] as String:"",
  );
}

Map<String, dynamic> _$SignInDTOToJson(SignInDTO instance) => <String, dynamic>{
      'errors': instance.errors,
      'message': instance.message,
      'token': instance.token,
      'type': instance.type,
      'user': instance.user,
    };
