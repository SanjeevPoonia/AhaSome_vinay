// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequests _$FriendRequestsFromJson(Map<String, dynamic> json) =>
    FriendRequests(
      json['status'] as int?,
      (json['pending_request'] as List<dynamic>?)
          ?.map((e) => PendingRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['message'] as String?,
      json['pending_request_count'] as int?,
      json['friend_count'] as int?,
    );

Map<String, dynamic> _$FriendRequestsToJson(FriendRequests instance) =>
    <String, dynamic>{
      'status': instance.status,
      'pending_request': instance.pending_request,
      'message': instance.message,
      'pending_request_count': instance.pending_request_count,
      'friend_count': instance.friend_count,
    };

PendingRequest _$PendingRequestFromJson(Map<String, dynamic> json) =>
    PendingRequest(
      json['id'] as int?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      json['email'] as String?,
      json['created_at'] as String?,
      json['country'] as String?,
      json['state'] as String?,
      json['gender'] as String?,
      json['date_of_birth'] as String?,
      json['mobile_number'] as String?,
      json['avatar'] as String?,
      (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['email_otp'] as int?,
      json['user_bg'] as String?,
    );

Map<String, dynamic> _$PendingRequestToJson(PendingRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'created_at': instance.created_at,
      'country': instance.country,
      'state': instance.state,
      'gender': instance.gender,
      'date_of_birth': instance.date_of_birth,
      'mobile_number': instance.mobile_number,
      'hobbies': instance.hobbies,
      'avatar': instance.avatar,
      'user_bg': instance.user_bg,
      'email_otp': instance.email_otp,
    };
