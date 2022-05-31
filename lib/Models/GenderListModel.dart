import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/UserInfoModel.dart';

part 'GenderListModel.g.dart';

@JsonSerializable()
class GenderListModel {
  int id;
  String gender, created_at, updated_at;

  GenderListModel(this.id, this.gender, this.created_at, this.updated_at);

  factory GenderListModel.fromJson(Map<String, dynamic> json) =>
      _$GenderListModelFromJson(json);
  Map<String, dynamic> toJson() => _$GenderListModelToJson(this);
}
