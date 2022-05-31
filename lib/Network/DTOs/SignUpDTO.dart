import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'SignUpDTO.g.dart';

@JsonSerializable()
class SignUpDTO {
  ErrorModel errors;
  String message;
  UserModel user;

  SignUpDTO(this.errors, this.message, this.user);

  factory SignUpDTO.fromJson(Map<String, dynamic> json) =>
      _$SignUpDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SignUpDTOToJson(this);
}
