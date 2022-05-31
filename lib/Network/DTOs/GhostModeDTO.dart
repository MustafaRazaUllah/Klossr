import 'package:json_annotation/json_annotation.dart';

part 'GhostModeDTO.g.dart';

@JsonSerializable()
class GhostModeDTO {
  // ErrorModel errors;
  String message;
  GhostModeDTO(this.message);

  factory GhostModeDTO.fromJson(Map<String, dynamic> json) =>
      _$GhostModeDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GhostModeDTOToJson(this);
}
