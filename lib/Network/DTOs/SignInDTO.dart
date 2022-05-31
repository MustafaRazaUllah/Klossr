import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'SignInDTO.g.dart';

@JsonSerializable()
class SignInDTO {
  ErrorModel errors;
  String message, token, type;
  UserModel user;

  SignInDTO(this.errors, this.message, this.user, this.token, this.type);

  factory SignInDTO.fromJson(Map<String, dynamic> json) =>
      _$SignInDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SignInDTOToJson(this);
}
