// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BlockListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockList _$BlockListFromJson(Map<String, dynamic> json) {
  return BlockList(
    json['id'] as int,
    json['user']!=null?UserModel.fromJson(json['user'] as Map<String, dynamic>):UserModel(0, "", "", "", "", "", UserInfoModel(0, false, "", "", GenderListModel(0,"","","")),0.0 ,0.0 ,[],"" ),
  );
}

Map<String, dynamic> _$BlockListToJson(BlockList instance) => <String, dynamic>{
      'id': instance.id,
      'userModel': instance.userModel,
    };
