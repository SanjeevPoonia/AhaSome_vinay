// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_friends_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindFriendsModel _$FindFriendsModelFromJson(Map<String, dynamic> json) =>
    FindFriendsModel(
      json['status'] as int?,
      (json['find_friend_list'] as List<dynamic>?)
          ?.map((e) => FindFriend.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
    );

Map<String, dynamic> _$FindFriendsModelToJson(FindFriendsModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'find_friend_list': instance.find_friend_list,
      'message': instance.message,
    };

FindFriend _$FindFriendFromJson(Map<String, dynamic> json) => FindFriend(
      json['id'] as int?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['country'] as String?,
      json['state'] as String?,
      json['gender'] as String?,
      (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['avatar'] as String?,
      json['user_bg'] as String?,
    )
      ..request_from_id = json['request_from_id'] as int?
      ..request_to_id = json['request_to_id'] as int?
      ..friend_status = json['friend_status'] as int?;

Map<String, dynamic> _$FindFriendToJson(FindFriend instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'country': instance.country,
      'state': instance.state,
      'gender': instance.gender,
      'hobbies': instance.hobbies,
      'avatar': instance.avatar,
      'user_bg': instance.user_bg,
      'request_from_id': instance.request_from_id,
      'request_to_id': instance.request_to_id,
      'friend_status': instance.friend_status,
    };
