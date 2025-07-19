import 'dart:convert';
import 'package:aha_project_files/models/common_model.dart';
import 'package:aha_project_files/models/dashboard_model.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toast/toast.dart';
import '../../models/about_model.dart';
import '../api_helper.dart';
import '../constants.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

class DashboardCubit extends Cubit<DashboardState>
{
  DashboardCubit():super(const DashboardState());
  ApiBaseHelper helper = ApiBaseHelper();


  Future<bool> addPromises(BuildContext context,
      Map<String, dynamic> requestModel) async {
    bool apiStatus=false;
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('savePromise', requestModel, context);
    var responseJson=json.decode(response.body);

    Navigator.pop(context);
    emit(state.copyWith(isLoading: false));

    if (responseJson['status'] == 1) {
      // success
      Toast.show('Added successfully !',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      apiStatus=true;

    } else {
      apiStatus=false;
      Toast.show(responseJson['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    return apiStatus;
  }

  fetchHomePosts(BuildContext context,
      Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('newfeed', requestModel, context);
    DashboardModel postModel=DashboardModel.fromJson(json.decode(response.body));
    print(postModel.show_post?.length.toString());
    emit(state.copyWith(isLoading: false,homePost: postModel.show_post!,promisesList: postModel.user_promise!));

  }

  fetchHomeCounts(BuildContext context,
      Map<String, dynamic> requestModel) async {
    var response = await helper.postAPI('ahaDashboard', requestModel, context);
    var responseJson=json.decode(response.body);
    emit(state.copyWith(ahaByMe:responseJson['post_count'],groupCount: responseJson['joined_group_count'],friendsCount: responseJson['friend_count'],gratitudeCount:responseJson['gratitude_count'],notCount:int.parse(responseJson['notifications_count'].toString())));
  }

  updateGratitudeCount(int count){
    emit(state.copyWith(gratitudeCount: count));

  }
  updateNotificationCount(int count){
    emit(state.copyWith(notCount: count));

  }
  updateAHAByMe(int count){
    emit(state.copyWith(ahaByMe: count));

  }

  updateFriendsCount(int count){
    emit(state.copyWith(friendsCount: count));
  }
  updateGroupsCount(int count){
    emit(state.copyWith(groupCount: count));
  }

    Future<bool> addPost(BuildContext context, FormData requestModel) async {
     bool apiStatus=false;
    emit(state.copyWith(isLoading: true));
     print(AppConstant.appBaseURL + 'userPost');
    try {
      Dio dio = Dio();

      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'userPost',
          data: requestModel);
      print(requestModel.fields);
      var responseBody = response.data;
      emit(state.copyWith(isLoading: false));
      print(responseBody);
      String jsonsDataString = responseBody.toString();
      final jsonData = jsonDecode(jsonsDataString);
      if (jsonData['status'] == 1) {
        apiStatus=true;
        print(jsonsDataString+'Data From server');


      } else {
        apiStatus=false;
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);

      }
    } catch (errorMessage) {
      apiStatus=false;
      String message = errorMessage.toString();
      print(message);

    }
    return apiStatus;
  }

  fetchAboutUser(BuildContext context,
      Map<String, dynamic> requestModel) async {
    var response = await helper.postAPI('aboutUser', requestModel, context);
    AboutModel postModel=AboutModel.fromJson(json.decode(response.body));
    emit(state.copyWith(aboutUser: postModel.user_profile!));

  }

  Future<bool> likePost(BuildContext context,
      Map<String, dynamic> requestModel) async {
    var response = await helper.postAPI('postLikes', requestModel, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    return true;
  }

  Future<bool> addComment(BuildContext context,
      Map<String, dynamic> requestModel) async {

     bool apiStatus=false;

    APIDialog.showAlertDialog(context, 'Adding Reaction...');
    var response = await helper.postAPI('postReaction', requestModel, context);
    print(requestModel.toString());
    Navigator.pop(context);
    print(json.decode(response.body));
    CommonModel model=CommonModel.fromJson(json.decode(response.body));

    if(model.status==200)
      {
        apiStatus=true;
        Toast.show('Reaction Added Successfully',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
      }

    return apiStatus;

  }
}