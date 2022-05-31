import 'package:json_annotation/json_annotation.dart';

part 'SendRequestModel.g.dart';

@JsonSerializable()
class SendRequestModel {
  String user_id;

  SendRequestModel(this.user_id);

  factory SendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$SendRequestModelToJson(this);
}
