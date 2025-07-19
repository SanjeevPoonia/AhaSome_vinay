// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutModel _$AboutModelFromJson(Map<String, dynamic> json) => AboutModel(
      json['status'] as int?,
      (json['user_profile'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
    );

Map<String, dynamic> _$AboutModelToJson(AboutModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user_profile': instance.user_profile,
      'message': instance.message,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      json['id'] as int?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['usertype'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['is_block'] as int?,
      json['country'] as String?,
      json['state'] as String?,
      json['gender'] as String?,
      json['date_of_birth'] as String?,
      json['marriage_anniversary'] as String?,
      json['verify_emial'] as int?,
      json['profession'] as String?,
      json['mobile_number'] as String?,
      (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['latitude'] as String?,
      json['longitude'] as String?,
      json['avatar'] as String?,
      json['user_bg'] as String?,
      json['email_otp'] as int?,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'usertype': instance.usertype,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'is_block': instance.is_block,
      'country': instance.country,
      'state': instance.state,
      'gender': instance.gender,
      'date_of_birth': instance.date_of_birth,
      'marriage_anniversary': instance.marriage_anniversary,
      'verify_emial': instance.verify_emial,
      'profession': instance.profession,
      'mobile_number': instance.mobile_number,
      'hobbies': instance.hobbies,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'avatar': instance.avatar,
      'user_bg': instance.user_bg,
      'email_otp': instance.email_otp,
    };
