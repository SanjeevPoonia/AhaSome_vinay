
import 'package:freezed_annotation/freezed_annotation.dart';
part 'friend_requests.g.dart';

@JsonSerializable()
class FriendRequests
{
  int? status;
  List<PendingRequest>? pending_request;
  String? message;
  int? pending_request_count;
  int? friend_count;

  FriendRequests(this.status,this.pending_request,this.message,this.pending_request_count,this.friend_count);

  factory FriendRequests.fromJson(Map<String, dynamic> json) => _$FriendRequestsFromJson(json);

  Map<String, dynamic> toJson() => _$FriendRequestsToJson(this);

}

@JsonSerializable()
 class PendingRequest{
   int? id;
   String? first_name;
   String? last_name;
   String? email;
   String? created_at;
   String? country;
   String? state;
   String? gender;
   String? date_of_birth;
   String? mobile_number;
   List<String>? hobbies;
   String? avatar;
   String? user_bg;
   int? email_otp;

   PendingRequest(this.id,this.first_name,this.last_name,this.email,this.created_at,this.country,this.state,this.gender,this.date_of_birth,this.mobile_number,this.avatar,this.hobbies,this.email_otp,this.user_bg);

   factory PendingRequest.fromJson(Map<String, dynamic> json) => _$PendingRequestFromJson(json);

   Map<String, dynamic> toJson() => _$PendingRequestToJson(this);
}


