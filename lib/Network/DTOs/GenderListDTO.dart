import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'GenderListDTO.g.dart';

@JsonSerializable()
class GenderListDTO {
  List<GenderListModel> gender;

  GenderListDTO(this.gender);

  factory GenderListDTO.fromJson(Map<String, dynamic> json) =>
      _$GenderListDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GenderListDTOToJson(this);
}
