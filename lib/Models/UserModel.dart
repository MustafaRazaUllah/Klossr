import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel {
  int id;
  String name, username, email, profile_image, profile_icon, distance;
  double latitude, longitude;
  List<GenderListModel> interested;
  UserInfoModel user_info;

  UserModel(
      this.id,
      this.name,
      this.username,
      this.email,
      this.profile_image,
      this.profile_icon,
      this.user_info,
      this.latitude,
      this.longitude,
      this.interested,
      this.distance);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
