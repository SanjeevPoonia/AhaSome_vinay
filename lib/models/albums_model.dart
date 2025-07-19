import 'package:freezed_annotation/freezed_annotation.dart';
part 'albums_model.g.dart';

@JsonSerializable()
class AlbumModel {
  int? status;
  List<UserProfileImage>? user_profile_image;
  List<UserPost>? user_post;
  String? message;

  AlbumModel(
      this.status, this.user_profile_image, this.user_post, this.message);

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);
}

@JsonSerializable()
class UserProfileImage {
  int? id;
  int? user_id;
  String? user_image;
  int? status;
  String? created_at;
  String? updated_at;

  UserProfileImage(this.id, this.user_id, this.user_image, this.status,
      this.created_at, this.updated_at);

  factory UserProfileImage.fromJson(Map<String, dynamic> json) =>
      _$UserProfileImageFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileImageToJson(this);
}


@JsonSerializable()
class UserPost {
  int? id;
  int? user_id;
  String? body;
  String? image;
  String? gif_id;
  String? image_capture;
  String? video_recording;
  int? category_id;
  String? capture_full;
  String? image_full;
  String? video_capture_full;
  int? status;
  String? created_at;
  String? updated_at;

  UserPost(
      this.id,
      this.user_id,
      this.body,
      this.image,
      this.gif_id,
      this.image_capture,
      this.video_recording,
      this.category_id,
      this.status,
      this.created_at,
      this.updated_at,
      this.video_capture_full,
      this.image_full,
      this.capture_full


      );

  factory UserPost.fromJson(Map<String, dynamic> json) =>
      _$UserPostFromJson(json);

  Map<String, dynamic> toJson() => _$UserPostToJson(this);
}


