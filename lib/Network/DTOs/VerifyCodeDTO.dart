import 'package:json_annotation/json_annotation.dart';

part 'VerifyCodeDTO.g.dart';

@JsonSerializable()
class VerifyCodeDTO {
  String message;
  String remember_token;

  VerifyCodeDTO(this.message, this.remember_token);

  factory VerifyCodeDTO.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeDTOFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyCodeDTOToJson(this);
}