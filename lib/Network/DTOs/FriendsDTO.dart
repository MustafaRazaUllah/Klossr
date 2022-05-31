import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/UserModel.dart';

part 'FriendsDTO.g.dart';

@JsonSerializable()
class FriendsDTO {
  List<UserModel> data;

  FriendsDTO(this.data);

  factory FriendsDTO.fromJson(Map<String, dynamic> json) =>
      _$FriendsDTOFromJson(json);
  Map<String, dynamic> toJson() => _$FriendsDTOToJson(this);
}
