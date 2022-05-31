// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetUserDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserDTO _$GetUserDTOFromJson(Map<String, dynamic> json) {
  return GetUserDTO(
    json['user']!=null?UserModel.fromJson(json['user'] as Map<String, dynamic>):UserModel(0, "", "", "", "", "", UserInfoModel(0, false, "", "", GenderListModel(0,"","","")),0.0 ,0.0 ,[],"" ),
  );
}

Map<String, dynamic> _$GetUserDTOToJson(GetUserDTO instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
