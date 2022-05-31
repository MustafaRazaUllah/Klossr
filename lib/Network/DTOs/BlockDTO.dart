import 'package:json_annotation/json_annotation.dart';

part 'BlockDTO.g.dart';

@JsonSerializable()
class BlockDTO {
  // ErrorModel errors;
  String message;
  BlockDTO(this.message);

  factory BlockDTO.fromJson(Map<String, dynamic> json) =>
      _$BlockDTOFromJson(json);
  Map<String, dynamic> toJson() => _$BlockDTOToJson(this);
}
