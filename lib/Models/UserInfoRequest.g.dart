// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfoRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoRequestModel _$UserInfoRequestModelFromJson(Map<String, dynamic> json) {
  return UserInfoRequestModel(
  json['name'] as String,
  json['username'] as String,
 json['email'] as String,
   json['dob'] as String,
     json['about_me'] as String,
  json['ghost_mode'] as int,
   json['gender_id'] as int,
        (json['interested_in'] as List).map((e) => e as int).toList(),
    json['password'] as String,
  );
}

Map<String, dynamic> _$UserInfoRequestModelToJson(
        UserInfoRequestModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'dob': instance.dob,
      'about_me': instance.about_me,
      'ghost_mode': instance.ghost_mode,
      'gender_id': instance.gender_id,
      'interested_in': instance.interested_in,
      'password': instance.password,
    };
