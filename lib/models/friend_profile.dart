
import 'package:freezed_annotation/freezed_annotation.dart';
part 'friend_profile.g.dart';

@JsonSerializable()
class FriendProfileModel
{
  int? status;
  String? if_friend;
  List<FriendProfile>? friend_profile;
  List<FriendPost>? friend_post;
  String? message;

  FriendProfileModel(this.status,this.friend_profile,this.friend_post,this.message,this.if_friend);
  factory FriendProfileModel.fromJson(Map<String, dynamic> json) => _$FriendProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendProfileModelToJson(this);

}

@JsonSerializable()
class FriendPost{
   int? id;
   int? user_id;
   String? body;
   String? image;
   int? category_id;
   int? status;
   String? created_at;
   String? updated_at;
   String? image_capture;
   String? video_recording;
   String? capture_full;
   String? image_full;
   String? video_capture_full;
   String? gif_id;
   List<PostReply>? post_reply;
   List<PostLikes>? post_likes;
   FriendPost(this.id,this.user_id,this.body,this.image,this.category_id,this.status,this.created_at,this.updated_at,this.video_recording,this.image_capture,this.gif_id,this.post_likes,this.post_reply,this.capture_full,this.image_full,this.video_capture_full);

   factory FriendPost.fromJson(Map<String, dynamic> json) => _$FriendPostFromJson(json);

   Map<String, dynamic> toJson() => _$FriendPostToJson(this);


}
@JsonSerializable()
class PostReply{
  int? id;
  int? reacted_by_id;
  PostReply(this.id,this.reacted_by_id);

  factory PostReply.fromJson(Map<String, dynamic> json) => _$PostReplyFromJson(json);

  Map<String, dynamic> toJson() => _$PostReplyToJson(this);


}
@JsonSerializable()
class PostLikes{
  int? id;
  int? liked_by_id;
  PostLikes(this.id,this.liked_by_id);

  factory PostLikes.fromJson(Map<String, dynamic> json) => _$PostLikesFromJson(json);

  Map<String, dynamic> toJson() => _$PostLikesToJson(this);


}


@JsonSerializable()
class FriendProfile {
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  int? usertype;
  String? created_at;
  String? updated_at;
  int? is_block;
  String? country;
  String? state;
  String? gender;
  String? date_of_birth;
  String? marriage_anniversary;
  int? verify_emial;
  String? profession;
  String? mobile_number;
  List<String>? hobbies;
  String? latitude;
  String? longitude;
  String? avatar;
  String? user_bg;
  int? email_otp;

  FriendProfile(
      this.id,
        this.first_name,
        this.last_name,
        this.email,
        this.usertype,
        this.created_at,
        this.updated_at,
        this.is_block,
        this.country,
        this.state,
        this.gender,
        this.date_of_birth,
        this.marriage_anniversary,
        this.verify_emial,
        this.profession,
        this.mobile_number,
        this.hobbies,
        this.latitude,
        this.longitude,
        this.avatar,
        this.user_bg,
        this.email_otp);

  factory FriendProfile.fromJson(Map<String, dynamic> json) => _$FriendProfileFromJson(json);

  Map<String, dynamic> toJson() => _$FriendProfileToJson(this);


}