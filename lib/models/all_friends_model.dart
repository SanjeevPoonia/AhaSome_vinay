
import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_friends_model.g.dart';

@JsonSerializable()
class AllFriendsResponse
{
  int? status;
  @JsonKey(name: 'friend_list')
  List<Friends>? friendList;
  int? pending_request_count;
  int? friend_count;
  AllFriendsResponse(this.status,this.friendList,this.friend_count,this.pending_request_count);

  factory AllFriendsResponse.fromJson(Map<String, dynamic> json) => _$AllFriendsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllFriendsResponseToJson(this);

}

@JsonSerializable()
class Friends
{
 int? id;
 String? first_name;
 String? last_name;
 String? email;
 int? usertype;
 String? created_at;
 int? is_block;
 String? country;
 String? state;
 String? gender;
 List<String>? hobbies;
 String? avatar;
 String? date_of_birth;

 Friends(this.id,this.first_name,this.last_name,this.email,this.usertype,this.created_at,this.is_block,this.country,this.state,this.gender,this.hobbies,this.avatar,this.date_of_birth);

 factory Friends.fromJson(Map<String, dynamic> json) => _$FriendsFromJson(json);

 Map<String, dynamic> toJson() => _$FriendsToJson(this);

}