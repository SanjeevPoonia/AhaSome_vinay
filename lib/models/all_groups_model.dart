import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_groups_model.g.dart';

@JsonSerializable()
class AllGroupsModel {
  int? status;
  List<AllGroup>? all_group;
  List<AllGroup>? joined_group;
  String? message;

  AllGroupsModel(this.status, this.all_group, this.message,this.joined_group);

  factory AllGroupsModel.fromJson(Map<String, dynamic> json) =>
      _$AllGroupsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllGroupsModelToJson(this);
}

@JsonSerializable()
class AllGroup {
  int? id;
  String? group_name;
  int? created_by;
  String? group_avatar;
  String? group_avatar_tem;
  String? group_about;
  int? status;
  String? created_at;
  String? updated_at;

  AllGroup(this.id, this.group_name, this.created_by, this.group_avatar,
      this.group_about, this.status, this.updated_at, this.created_at,this.group_avatar_tem);

  factory AllGroup.fromJson(Map<String, dynamic> json) =>
      _$AllGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AllGroupToJson(this);
}



