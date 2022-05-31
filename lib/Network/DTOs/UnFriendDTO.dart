import 'package:json_annotation/json_annotation.dart';

part 'UnFriendDTO.g.dart';

@JsonSerializable()
class UnFriendDTO {
  // ErrorModel errors;
  String message;
  UnFriendDTO(this.message);

  factory UnFriendDTO.fromJson(Map<String, dynamic> json) =>
      _$UnFriendDTOFromJson(json);
  Map<String, dynamic> toJson() => _$UnFriendDTOToJson(this);
}
