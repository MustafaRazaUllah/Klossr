import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'NearByUserDTO.g.dart';

@JsonSerializable()
class NearByUserDTO {
  List<UserModel> data;

  NearByUserDTO(this.data);

  factory NearByUserDTO.fromJson(Map<String, dynamic> json) =>
      _$NearByUserDTOFromJson(json);
  Map<String, dynamic> toJson() => _$NearByUserDTOToJson(this);
}
