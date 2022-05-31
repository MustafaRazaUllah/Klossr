import 'package:json_annotation/json_annotation.dart';
import 'package:klossr/Models/GenderListModel.dart';
import 'package:klossr/Models/UserInfoModel.dart';
import 'package:klossr/Models/UserModel.dart';

part 'BlockListModel.g.dart';

@JsonSerializable()
class BlockList {
  int id;
  UserModel userModel;

  BlockList(this.id, this.userModel);

  factory BlockList.fromJson(Map<String, dynamic> json) =>
      _$BlockListFromJson(json);
  Map<String, dynamic> toJson() => _$BlockListToJson(this);
}
