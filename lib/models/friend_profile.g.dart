// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendProfileModel _$FriendProfileModelFromJson(Map<String, dynamic> json) =>
    FriendProfileModel(
      json['status'] as int?,
      (json['friend_profile'] as List<dynamic>?)
          ?.map((e) => FriendProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['friend_post'] as List<dynamic>?)
          ?.map((e) => FriendPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
      json['if_friend'] as String?,
    );

Map<String, dynamic> _$FriendProfileModelToJson(FriendProfileModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'if_friend': instance.if_friend,
      'friend_profile': instance.friend_profile,
      'friend_post': instance.friend_post,
      'message': instance.message,
    };

FriendPost _$FriendPostFromJson(Map<String, dynamic> json) => FriendPost(
      json['id'] as int?,
      json['user_id'] as int?,
      json['body'] as String?,
      json['image'] as String?,
      json['category_id'] as int?,
      json['status'] as int?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['video_recording'] as String?,
      json['image_capture'] as String?,
      json['gif_id'] as String?,
      (json['post_likes'] as List<dynamic>?)
          ?.map((e) => PostLikes.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['post_reply'] as List<dynamic>?)
          ?.map((e) => PostReply.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['capture_full'] as String?,
      json['image_full'] as String?,
      json['video_capture_full'] as String?,
    );

Map<String, dynamic> _$FriendPostToJson(FriendPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'body': instance.body,
      'image': instance.image,
      'category_id': instance.category_id,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'image_capture': instance.image_capture,
      'video_recording': instance.video_recording,
      'capture_full': instance.capture_full,
      'image_full': instance.image_full,
      'video_capture_full': instance.video_capture_full,
      'gif_id': instance.gif_id,
      'post_reply': instance.post_reply,
      'post_likes': instance.post_likes,
    };

PostReply _$PostReplyFromJson(Map<String, dynamic> json) => PostReply(
      json['id'] as int?,
      json['reacted_by_id'] as int?,
    );

Map<String, dynamic> _$PostReplyToJson(PostReply instance) => <String, dynamic>{
      'id': instance.id,
      'reacted_by_id': instance.reacted_by_id,
    };

PostLikes _$PostLikesFromJson(Map<String, dynamic> json) => PostLikes(
      json['id'] as int?,
      json['liked_by_id'] as int?,
    );

Map<String, dynamic> _$PostLikesToJson(PostLikes instance) => <String, dynamic>{
      'id': instance.id,
      'liked_by_id': instance.liked_by_id,
    };

FriendProfile _$FriendProfileFromJson(Map<String, dynamic> json) =>
    FriendProfile(
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

Map<String, dynamic> _$FriendProfileToJson(FriendProfile instance) =>
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
