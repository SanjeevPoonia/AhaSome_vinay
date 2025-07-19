// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
      json['status'] as int?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['auth_key'] as String?,
      json['message'] as String?,
      json['profile_image'] as String?,
      json['user_id'] as int?,
      (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'auth_key': instance.authKey,
      'user_id': instance.userId,
      'profile_image': instance.profileImage,
      'hobbies': instance.hobbies,
      'message': instance.message,
    };
