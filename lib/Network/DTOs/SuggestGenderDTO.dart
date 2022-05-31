import 'package:json_annotation/json_annotation.dart';

part 'SuggestGenderDTO.g.dart';

@JsonSerializable()
class SuggestGenderDTO {
  String message;
  String image_url;

  SuggestGenderDTO(this.message, this.image_url);

  factory SuggestGenderDTO.fromJson(Map<String, dynamic> json) =>
      _$SuggestGenderDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestGenderDTOToJson(this);
}
