import 'package:json_annotation/json_annotation.dart';

part 'unBlockDTO.g.dart';

@JsonSerializable()
class unBlockDTO {
  // ErrorModel errors;
  String message;
  unBlockDTO(this.message);

  factory unBlockDTO.fromJson(Map<String, dynamic> json) =>
      _$unBlockDTOFromJson(json);
  Map<String, dynamic> toJson() => _$unBlockDTOToJson(this);
}
