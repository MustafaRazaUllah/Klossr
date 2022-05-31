import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'GetUserDTO.g.dart';

@JsonSerializable()
class GetUserDTO {
  UserModel user;

  GetUserDTO(this.user);

  factory GetUserDTO.fromJson(Map<String, dynamic> json) =>
      _$GetUserDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GetUserDTOToJson(this);
}
