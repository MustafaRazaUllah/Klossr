// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShowRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowRequest _$ShowRequestFromJson(Map<String, dynamic> json) {
  return ShowRequest(
    json['id'] as int,
    json['user']!=null?UserModel.fromJson(json['user'] as Map<String, dynamic>):UserModel(0, "", "", "", "", "", UserInfoModel(0, false, "", "", GenderListModel(0,"","","")),0.0 ,0.0 ,[],"" ),
  );
}

Map<String, dynamic> _$ShowRequestToJson(ShowRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userModel': instance.userModel,
    };
