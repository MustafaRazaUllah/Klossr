import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'ShowRequestModel.g.dart';

@JsonSerializable()
class ShowRequest {
  int id;
  UserModel userModel;

  ShowRequest(this.id, this.userModel);

  factory ShowRequest.fromJson(Map<String, dynamic> json) =>
      _$ShowRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ShowRequestToJson(this);
}
