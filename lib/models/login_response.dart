import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginModel {
  int? status;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(name: 'auth_key')
  String? authKey;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'profile_image')
  String? profileImage;
  List<String>? hobbies;
  String? message;

  LoginModel(
       this.status,
       this.firstName,
       this.lastName,
       this.authKey,
       this.message,
       this.profileImage,
       this.userId,
      this.hobbies
      );
  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

}