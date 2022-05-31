import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';

part 'RequestAcceptDTO.g.dart';

@JsonSerializable()
class RequestAcceptDTO {
  String message;

  RequestAcceptDTO(this.message);

  factory RequestAcceptDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestAcceptDTOFromJson(json);
  Map<String, dynamic> toJson() => _$RequestAcceptDTOToJson(this);
}
