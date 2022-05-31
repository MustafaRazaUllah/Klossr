import 'package:json_annotation/json_annotation.dart';

part 'ErrorModel.g.dart';

@JsonSerializable()
class ErrorModel {
  List<String> username, email;

  ErrorModel(this.username, this.email);

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
