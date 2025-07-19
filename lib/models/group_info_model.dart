
import 'package:freezed_annotation/freezed_annotation.dart';
part 'group_info_model.g.dart';

@JsonSerializable()
class GroupInfoModel
{
   int? status;
   List<GroupPost>? group_post;
   List<GroupInfo>? group_info;
   String? message;
   int? alredy_joined;

   GroupInfoModel(this.status,this.message,this.group_post,this.alredy_joined);
   factory GroupInfoModel.fromJson(Map<String, dynamic> json) =>
       _$GroupInfoModelFromJson(json);

   Map<String, dynamic> toJson() => _$GroupInfoModelToJson(this);

}

@JsonSerializable()
 class GroupPost{
   int? id;
   int? user_id;
   String? body;
   String? image;
   Object? gif_id;
   Object? image_capture;
   Object? video_recording;
   int? category_id;
   int? group_id;
   int? status;
   String? created_at;
   String? updated_at;
   String? first_name;
   String? last_name;
   String? email;
   String? password;
   int? usertype;
   String? remember_token;
   int? is_block;
   String? country;
   String? state;
   String? gender;
   String? date_of_birth;
   String? marriage_anniversary;
   int? verify_emial;
   String? profession;
   String? mobile_number;
   String? hobbies;
   String? latitude;
   String? longitude;
   String? avatar;
   String? user_bg;
   int? email_otp;
   int? active_status;
   int? dark_mode;
   String? messenger_color;
   List<PostReply>? post_reply;
   List<PostLike>? post_likes;
   List<UserPost>? userpost;
   String? capture_full;
   String? image_full;
   String? video_capture_full;

   GroupPost(
       this.id,
         this.user_id,
         this.body,
         this.image,
         this.gif_id,
         this.image_capture,
         this.video_recording,
         this.category_id,
         this.group_id,
         this.status,
         this.created_at,
         this.updated_at,
         this.first_name,
         this.last_name,
         this.email,
         this.password,
         this.usertype,
         this.remember_token,
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
         this.email_otp,
         this.active_status,
         this.dark_mode,
         this.messenger_color,
         this.post_reply,
         this.post_likes,
         this.image_full,
        this.capture_full,
         this.video_capture_full

       );
   factory GroupPost.fromJson(Map<String, dynamic> json) =>
       _$GroupPostFromJson(json);

   Map<String, dynamic> toJson() => _$GroupPostToJson(this);


}

@JsonSerializable()
 class PostLike{
   int? id;
   int? post_id;
   int? liked_by_id;
   String? created_at;
   String? updated_at;
   PostLike(
       this.id, this.post_id, this.liked_by_id, this.created_at, this.updated_at);
   factory PostLike.fromJson(Map<String, dynamic> json) =>
       _$PostLikeFromJson(json);

   Map<String, dynamic> toJson() => _$PostLikeToJson(this);


}

@JsonSerializable()
class GroupInfo{
  int? id;
  String? group_name;
  int? created_by;
  String? group_avatar;
  String? group_avatar_tem;
  String? group_about;
  int? status;
  String? created_at;
  String? updated_at;
  int? group_deleted;

  GroupInfo(
      this.id, this.group_name, this.created_by, this.group_avatar, this.group_avatar_tem,this.status,this.created_at,this.group_about,this.group_deleted,this.updated_at);
  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);


}
@JsonSerializable()
class UserPost{
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? avatar;
  UserPost(
      this.id, this.first_name, this.last_name, this.email, this.avatar);
  factory UserPost.fromJson(Map<String, dynamic> json) =>
      _$UserPostFromJson(json);

  Map<String, dynamic> toJson() => _$UserPostToJson(this);


}



@JsonSerializable()
 class PostReply{
   int? id;
   int? post_id;
   int? reacted_by_id;
   String? emoji;
   Object? gif;
   String? created_at;
   String? updated_at;


   PostReply(
       this.id,
         this.post_id,
         this.reacted_by_id,
         this.emoji,
         this.gif,
         this.created_at,
         this.updated_at);

   factory PostReply.fromJson(Map<String, dynamic> json) =>
       _$PostReplyFromJson(json);

   Map<String, dynamic> toJson() => _$PostReplyToJson(this);
}

