// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FriendsDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsDTO _$FriendsDTOFromJson(Map<String, dynamic> json) {
  return FriendsDTO(
    (json['data'] as List).map((e) =>
            UserModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$FriendsDTOToJson(FriendsDTO instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
