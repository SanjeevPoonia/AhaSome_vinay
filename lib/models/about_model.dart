
import 'package:freezed_annotation/freezed_annotation.dart';
part 'about_model.g.dart';
@JsonSerializable()
 class AboutModel{
   int? status;
   List<UserProfile>? user_profile;
   String? message;

   AboutModel(this.status, this.user_profile, this.message);

   factory AboutModel.fromJson(Map<String, dynamic> json) =>
       _$AboutModelFromJson(json);

   Map<String, dynamic> toJson() => _$AboutModelToJson(this);

}
@JsonSerializable()
  class UserProfile{
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

    UserProfile(
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

    factory UserProfile.fromJson(Map<String, dynamic> json) =>
        _$UserProfileFromJson(json);

    Map<String, dynamic> toJson() => _$UserProfileToJson(this);
 }

