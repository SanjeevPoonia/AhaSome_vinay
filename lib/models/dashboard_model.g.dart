// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      status: json['status'] as int?,
      random_question: json['random_question'] == null
          ? null
          : RandomQuestion.fromJson(
              json['random_question'] as Map<String, dynamic>),
      user_promise: (json['user_promise'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      show_post: (json['show_post'] as List<dynamic>?)
          ?.map((e) => ShowPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'random_question': instance.random_question,
      'user_promise': instance.user_promise,
      'show_post': instance.show_post,
      'message': instance.message,
    };

RandomQuestion _$RandomQuestionFromJson(Map<String, dynamic> json) =>
    RandomQuestion(
      id: json['id'] as int?,
      batch_id: json['batch_id'] as int?,
      question: json['question'] as String?,
      answer_1: json['answer_1'] as String?,
      answer_2: json['answer_2'] as String?,
      answer_3: json['answer_3'] as String?,
      answer_4: json['answer_4'] as String?,
      correct_answer: json['correct_answer'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      choose_category: json['choose_category'] as int?,
    );

Map<String, dynamic> _$RandomQuestionToJson(RandomQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batch_id': instance.batch_id,
      'question': instance.question,
      'answer_1': instance.answer_1,
      'answer_2': instance.answer_2,
      'answer_3': instance.answer_3,
      'answer_4': instance.answer_4,
      'correct_answer': instance.correct_answer,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'choose_category': instance.choose_category,
    };

ShowPost _$ShowPostFromJson(Map<String, dynamic> json) => ShowPost(
      id: json['id'] as int?,
      user_id: json['user_id'] as int?,
      body: json['body'] as String?,
      image: json['image'] as String?,
      gif_id: json['gif_id'] as String?,
      image_capture: json['image_capture'] as String?,
      video_recording: json['video_recording'] as String?,
      category_id: json['category_id'] as int?,
      status: json['status'] as int?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      userpost: (json['userpost'] as List<dynamic>?)
          ?.map((e) => Userpost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShowPostToJson(ShowPost instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'body': instance.body,
      'image': instance.image,
      'gif_id': instance.gif_id,
      'image_capture': instance.image_capture,
      'video_recording': instance.video_recording,
      'category_id': instance.category_id,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'userpost': instance.userpost,
    };

Userpost _$UserpostFromJson(Map<String, dynamic> json) => Userpost(
      id: json['id'] as int?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      email: json['email'] as String?,
      usertype: json['usertype'] as int?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      is_block: json['is_block'] as int?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      gender: json['gender'] as String?,
      date_of_birth: json['date_of_birth'] as String?,
      marriage_anniversary: json['marriage_anniversary'] as String?,
      verify_emial: json['verify_emial'] as int?,
      profession: json['profession'] as String?,
      mobile_number: json['mobile_number'] as String?,
      hobbies:
          (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      avatar: json['avatar'] as String?,
      user_bg: json['user_bg'] as String?,
      email_otp: json['email_otp'] as int?,
    );

Map<String, dynamic> _$UserpostToJson(Userpost instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'usertype': instance.usertype,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'is_block': instance.is_block,
      'country': instance.country,
      'state': instance.state,
      'gender': instance.gender,
      'date_of_birth': instance.date_of_birth,
      'marriage_anniversary': instance.marriage_anniversary,
      'verify_emial': instance.verify_emial,
      'profession': instance.profession,
      'mobile_number': instance.mobile_number,
      'hobbies': instance.hobbies,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'avatar': instance.avatar,
      'user_bg': instance.user_bg,
      'email_otp': instance.email_otp,
    };
