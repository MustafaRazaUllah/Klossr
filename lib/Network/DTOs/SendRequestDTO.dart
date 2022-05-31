import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/ErrorModel.dart';
import 'package:klossr/Models/SendRequestModel.dart';

part 'SendRequestDTO.g.dart';

@JsonSerializable()
class SendRequestDTO {
  // ErrorModel errors;
  String message;
  SendRequestDTO(this.message);

  factory SendRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$SendRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SendRequestDTOToJson(this);
}
