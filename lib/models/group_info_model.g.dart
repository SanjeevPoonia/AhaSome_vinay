// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupInfoModel _$GroupInfoModelFromJson(Map<String, dynamic> json) =>
    GroupInfoModel(
      json['status'] as int?,
      json['message'] as String?,
      (json['group_post'] as List<dynamic>?)
          ?.map((e) => GroupPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['alredy_joined'] as int?,
    )..group_info = (json['group_info'] as List<dynamic>?)
        ?.map((e) => GroupInfo.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$GroupInfoModelToJson(GroupInfoModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'group_post': instance.group_post,
      'group_info': instance.group_info,
      'message': instance.message,
      'alredy_joined': instance.alredy_joined,
    };

GroupPost _$GroupPostFromJson(Map<String, dynamic> json) => GroupPost(
      json['id'] as int?,
      json['user_id'] as int?,
      json['body'] as String?,
      json['image'] as String?,
      json['gif_id'],
      json['image_capture'],
      json['video_recording'],
      json['category_id'] as int?,
      json['group_id'] as int?,
      json['status'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['password'] as String?,
      json['usertype'] as int?,
      json['remember_token'] as String?,
      json['is_block'] as int?,
      json['country'] as String?,
      json['state'] as String?,
      json['gender'] as String?,
      json['date_of_birth'] as String?,
      json['marriage_anniversary'] as String?,
      json['verify_emial'] as int?,
      json['profession'] as String?,
      json['mobile_number'] as String?,
      json['hobbies'] as String?,
      json['latitude'] as String?,
      json['longitude'] as String?,
      json['avatar'] as String?,
      json['user_bg'] as String?,
      json['email_otp'] as int?,
      json['active_status'] as int?,
      json['dark_mode'] as int?,
      json['messenger_color'] as String?,
      (json['post_reply'] as List<dynamic>?)
          ?.map((e) => PostReply.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['post_likes'] as List<dynamic>?)
          ?.map((e) => PostLike.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['image_full'] as String?,
      json['capture_full'] as String?,
      json['video_capture_full'] as String?,
    )..userpost = (json['userpost'] as List<dynamic>?)
        ?.map((e) => UserPost.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$GroupPostToJson(GroupPost instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'body': instance.body,
      'image': instance.image,
      'gif_id': instance.gif_id,
      'image_capture': instance.image_capture,
      'video_recording': instance.video_recording,
      'category_id': instance.category_id,
      'group_id': instance.group_id,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'password': instance.password,
      'usertype': instance.usertype,
      'remember_token': instance.remember_token,
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
      'active_status': instance.active_status,
      'dark_mode': instance.dark_mode,
      'messenger_color': instance.messenger_color,
      'post_reply': instance.post_reply,
      'post_likes': instance.post_likes,
      'userpost': instance.userpost,
      'capture_full': instance.capture_full,
      'image_full': instance.image_full,
      'video_capture_full': instance.video_capture_full,
    };

PostLike _$PostLikeFromJson(Map<String, dynamic> json) => PostLike(
      json['id'] as int?,
      json['post_id'] as int?,
      json['liked_by_id'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$PostLikeToJson(PostLike instance) => <String, dynamic>{
      'id': instance.id,
      'post_id': instance.post_id,
      'liked_by_id': instance.liked_by_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

GroupInfo _$GroupInfoFromJson(Map<String, dynamic> json) => GroupInfo(
      json['id'] as int?,
      json['group_name'] as String?,
      json['created_by'] as int?,
      json['group_avatar'] as String?,
      json['group_avatar_tem'] as String?,
      json['status'] as int?,
      json['created_at'] as String?,
      json['group_about'] as String?,
      json['group_deleted'] as int?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$GroupInfoToJson(GroupInfo instance) => <String, dynamic>{
      'id': instance.id,
      'group_name': instance.group_name,
      'created_by': instance.created_by,
      'group_avatar': instance.group_avatar,
      'group_avatar_tem': instance.group_avatar_tem,
      'group_about': instance.group_about,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'group_deleted': instance.group_deleted,
    };

UserPost _$UserPostFromJson(Map<String, dynamic> json) => UserPost(
      json['id'] as int?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['avatar'] as String?,
    );

Map<String, dynamic> _$UserPostToJson(UserPost instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'avatar': instance.avatar,
    };

PostReply _$PostReplyFromJson(Map<String, dynamic> json) => PostReply(
      json['id'] as int?,
      json['post_id'] as int?,
      json['reacted_by_id'] as int?,
      json['emoji'] as String?,
      json['gif'],
      json['created_at'] as String?,
      json['updated_at'] as String?,
    );

Map<String, dynamic> _$PostReplyToJson(PostReply instance) => <String, dynamic>{
      'id': instance.id,
      'post_id': instance.post_id,
      'reacted_by_id': instance.reacted_by_id,
      'emoji': instance.emoji,
      'gif': instance.gif,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
