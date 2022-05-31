// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfoModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return UserInfoModel(
    json['age']!=null?json['age'] as int:0,
    json['ghost_mode']!=null?json['ghost_mode'] as bool:false,
    json['about_me']!=null? json['about_me']as String:"",
    json['dob']!=null?json['dob'] as String:"",
    json['gender'] !=null? GenderListModel.fromJson(json['gender'] as Map<String, dynamic>):GenderListModel(0,"","",""),
  );
}

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'ghost_mode': instance.ghost_mode,
      'about_me': instance.about_me,
      'dob': instance.dob,
      'gender': instance.gender,
    };
