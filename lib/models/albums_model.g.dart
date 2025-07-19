// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel(
      json['status'] as int?,
      (json['user_profile_image'] as List<dynamic>?)
          ?.map((e) => UserProfileImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['user_post'] as List<dynamic>?)
          ?.map((e) => UserPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
    );

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user_profile_image': instance.user_profile_image,
      'user_post': instance.user_post,
      'message': instance.message,
    };

UserProfileImage _$UserProfileImageFromJson(Map<String, dynamic> json) =>
    UserProfileImage(
      json['id'] as int?,
      json['user_id'] as int?,
      json['user_image'] as String?,
      json['status'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserProfileImageToJson(UserProfileImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'user_image': instance.user_image,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

UserPost _$UserPostFromJson(Map<String, dynamic> json) => UserPost(
      json['id'] as int?,
      json['user_id'] as int?,
      json['body'] as String?,
      json['image'] as String?,
      json['gif_id'] as String?,
      json['image_capture'] as String?,
      json['video_recording'] as String?,
      json['category_id'] as int?,
      json['status'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['video_capture_full'] as String?,
      json['image_full'] as String?,
      json['capture_full'] as String?,
    );

Map<String, dynamic> _$UserPostToJson(UserPost instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'body': instance.body,
      'image': instance.image,
      'gif_id': instance.gif_id,
      'image_capture': instance.image_capture,
      'video_recording': instance.video_recording,
      'category_id': instance.category_id,
      'capture_full': instance.capture_full,
      'image_full': instance.image_full,
      'video_capture_full': instance.video_capture_full,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
