import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'ShowRequestDTO.g.dart';

@JsonSerializable()
class ShowRequestDTO {
  ErrorModel errors;
  List<UserModel> data;

  ShowRequestDTO(this.errors, this.data);

  factory ShowRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$ShowRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ShowRequestDTOToJson(this);
}
