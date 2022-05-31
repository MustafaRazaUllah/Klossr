import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'BlockListDTO.g.dart';

@JsonSerializable()
class BlockListDTO {
  ErrorModel errors;
  List<UserModel> data;

  BlockListDTO(this.errors, this.data);

  factory BlockListDTO.fromJson(Map<String, dynamic> json) =>
      _$BlockListDTOFromJson(json);
  Map<String, dynamic> toJson() => _$BlockListDTOToJson(this);
}
