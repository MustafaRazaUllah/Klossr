import 'package:json_annotation/json_annotation.dart';

part 'ReportDTO.g.dart';

@JsonSerializable()
class ReportDTO {
  // ErrorModel errors;
  String message;
  ReportDTO(this.message);

  factory ReportDTO.fromJson(Map<String, dynamic> json) =>
      _$ReportDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ReportDTOToJson(this);
}
