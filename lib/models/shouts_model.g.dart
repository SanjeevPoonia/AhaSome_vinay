// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shouts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoutModel _$ShoutModelFromJson(Map<String, dynamic> json) => ShoutModel(
      json['status'] as int?,
      (json['user_all_promises'] as List<dynamic>?)
          ?.map((e) => Shout.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
    );

Map<String, dynamic> _$ShoutModelToJson(ShoutModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user_all_promises': instance.user_all_promises,
      'message': instance.message,
    };

Shout _$ShoutFromJson(Map<String, dynamic> json) => Shout(
      json['id'] as int?,
      json['user_id'] as int?,
      json['promise'] as String?,
      json['status'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$ShoutToJson(Shout instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'promise': instance.promise,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
