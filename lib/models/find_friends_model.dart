
import 'package:freezed_annotation/freezed_annotation.dart';
part 'find_friends_model.g.dart';

@JsonSerializable()
class FindFriendsModel
{
   int? status;
   List<FindFriend>? find_friend_list;
   String? message;
   FindFriendsModel(this.status, this.find_friend_list, this.message);
   factory FindFriendsModel.fromJson(Map<String, dynamic> json) => _$FindFriendsModelFromJson(json);

   Map<String, dynamic> toJson() => _$FindFriendsModelToJson(this);
}

@JsonSerializable()
class FindFriend{
    int? id;
    String? first_name;
    String? last_name;
    String? email;
    String? country;
    String? state;
    String? gender;
    List<String>? hobbies;
    String? avatar;
    String? user_bg;
    int? request_from_id;
    int? request_to_id;
    int? friend_status;

    FindFriend(
        this.id,
           this.first_name,
           this.last_name,
           this.email,
           this.country,
           this.state,
           this.gender,
           this.hobbies,
           this.avatar,
           this.user_bg);

    factory FindFriend.fromJson(Map<String, dynamic> json) => _$FindFriendFromJson(json);

    Map<String, dynamic> toJson() => _$FindFriendToJson(this);
}
