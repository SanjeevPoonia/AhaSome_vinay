// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_groups_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllGroupsModel _$AllGroupsModelFromJson(Map<String, dynamic> json) =>
    AllGroupsModel(
      json['status'] as int?,
      (json['all_group'] as List<dynamic>?)
          ?.map((e) => AllGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
      (json['joined_group'] as List<dynamic>?)
          ?.map((e) => AllGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllGroupsModelToJson(AllGroupsModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'all_group': instance.all_group,
      'joined_group': instance.joined_group,
      'message': instance.message,
    };

AllGroup _$AllGroupFromJson(Map<String, dynamic> json) => AllGroup(
      json['id'] as int?,
      json['group_name'] as String?,
      json['created_by'] as int?,
      json['group_avatar'] as String?,
      json['group_about'] as String?,
      json['status'] as int?,
      json['updated_at'] as String?,
      json['created_at'] as String?,
      json['group_avatar_tem'] as String?,
    );

Map<String, dynamic> _$AllGroupToJson(AllGroup instance) => <String, dynamic>{
      'id': instance.id,
      'group_name': instance.group_name,
      'created_by': instance.created_by,
      'group_avatar': instance.group_avatar,
      'group_avatar_tem': instance.group_avatar_tem,
      'group_about': instance.group_about,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
