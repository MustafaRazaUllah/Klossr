import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';

part 'RequestRejectDTO.g.dart';

@JsonSerializable()
class RequestRejectDTO {
  String message;

  RequestRejectDTO(this.message);

  factory RequestRejectDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestRejectDTOFromJson(json);
  Map<String, dynamic> toJson() => _$RequestRejectDTOToJson(this);
}
