// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['id'] !=null?json['id']as int:0,
    json['name']!=null?json['name'] as String:"",
    json['username']!=null?json['username'] as String:"",
    json['email']!=null?json['email'] as String:"",
    json['profile_image']!=null?json['profile_image'] as String:"",
    json['profile_icon']!=null?json['profile_icon'] as String:"",
    json['user_info'] !=null
        ? UserInfoModel.fromJson(json['user_info'] as Map<String, dynamic>):UserInfoModel(0, false, "", "", GenderListModel(0,"","","")),
    json['latitude']!=null? (json['latitude'] as num).toDouble():0.0,
    json['longitude']!=null? (json['longitude'] as num).toDouble():0.0,
    (json['interested'] as List).map((e) =>
            GenderListModel.fromJson(e as Map<String, dynamic>)).toList(),
    json['distance']!=null?json['distance'] as String:"",
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'profile_image': instance.profile_image,
      'profile_icon': instance.profile_icon,
      'distance': instance.distance,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'interested': instance.interested,
      'user_info': instance.user_info,
    };
