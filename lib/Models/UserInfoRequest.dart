import 'package:json_annotation/json_annotation.dart';

part 'UserInfoRequest.g.dart';

@JsonSerializable()
class UserInfoRequestModel {
  String name, username, email, dob, about_me;
  int ghost_mode, gender_id;
  List<int> interested_in;

  UserInfoRequestModel(
      this.name,
      this.username,
      this.email,
      this.dob,
      this.about_me,
      this.ghost_mode,
      this.gender_id,
      this.interested_in);

  factory UserInfoRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoRequestModelToJson(this);
}
