// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_friends_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllFriendsResponse _$AllFriendsResponseFromJson(Map<String, dynamic> json) =>
    AllFriendsResponse(
      json['status'] as int?,
      (json['friend_list'] as List<dynamic>?)
          ?.map((e) => Friends.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['friend_count'] as int?,
      json['pending_request_count'] as int?,
    );

Map<String, dynamic> _$AllFriendsResponseToJson(AllFriendsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'friend_list': instance.friendList,
      'pending_request_count': instance.pending_request_count,
      'friend_count': instance.friend_count,
    };

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
      json['id'] as int?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['usertype'] as int?,
      json['created_at'] as String?,
      json['is_block'] as int?,
      json['country'] as String?,
      json['state'] as String?,
      json['gender'] as String?,
      (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['avatar'] as String?,
      json['date_of_birth'] as String?,
    );

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'usertype': instance.usertype,
      'created_at': instance.created_at,
      'is_block': instance.is_block,
      'country': instance.country,
      'state': instance.state,
      'gender': instance.gender,
      'hobbies': instance.hobbies,
      'avatar': instance.avatar,
      'date_of_birth': instance.date_of_birth,
    };
