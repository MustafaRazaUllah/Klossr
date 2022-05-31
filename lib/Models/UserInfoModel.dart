import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/GenderListModel.dart';

part 'UserInfoModel.g.dart';

@JsonSerializable()
class UserInfoModel {
  int age;
  bool ghost_mode;
  String about_me, dob;
  GenderListModel gender;

  UserInfoModel(this.age, this.ghost_mode, this.about_me, this.dob, this.gender);

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
