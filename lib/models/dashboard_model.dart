import 'package:freezed_annotation/freezed_annotation.dart';
part 'dashboard_model.g.dart';

@JsonSerializable()
class DashboardModel {
  int? status;
  RandomQuestion? random_question;
  List<String>? user_promise;
  List<ShowPost>? show_post;
  String? message;

  DashboardModel(
      {this.status,
        this.random_question,
        this.user_promise,
        this.show_post,
        this.message});

   factory DashboardModel.fromJson(Map<String, dynamic> json)=>_$DashboardModelFromJson(json);

  Map<String, dynamic> toJson() =>_$DashboardModelToJson(this);
}

@JsonSerializable()
class RandomQuestion {
  int? id;
  int? batch_id;
  String? question;
  String? answer_1;
  String? answer_2;
  String? answer_3;
  String? answer_4;
  String? correct_answer;
  String? created_at;
  String? updated_at;
  int? choose_category;

  RandomQuestion(
      {this.id,
        this.batch_id,
        this.question,
        this.answer_1,
        this.answer_2,
        this.answer_3,
        this.answer_4,
        this.correct_answer,
        this.created_at,
        this.updated_at,
        this.choose_category});

  factory RandomQuestion.fromJson(Map<String, dynamic> json)=>_$RandomQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$RandomQuestionToJson(this);
}

@JsonSerializable()
class ShowPost {
  int? id;
  int? user_id;
  String? body;
  String? image;
  String? gif_id;
  String? image_capture;
  String? video_recording;
  int? category_id;
  int? status;
  String? created_at;
  String? updated_at;
  List<Userpost>? userpost;

  ShowPost(
      {this.id,
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
        this.userpost});

  factory ShowPost.fromJson(Map<String, dynamic> json) =>_$ShowPostFromJson(json);

  Map<String, dynamic> toJson() => _$ShowPostToJson(this);
}

@JsonSerializable()
class Userpost {
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

  Userpost(
      {this.id,
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
        this.email_otp});

  factory Userpost.fromJson(Map<String, dynamic> json) =>_$UserpostFromJson(json);


  Map<String, dynamic> toJson() => _$UserpostToJson(this);
}