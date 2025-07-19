import 'dart:convert';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toast/toast.dart';
import '../../models/all_groups_model.dart';
import '../../models/group_info_model.dart';
import '../api_helper.dart';
import '../constants.dart';

part 'profile_state.dart';

part 'profile_bloc.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());
  ApiBaseHelper helper = ApiBaseHelper();

  fetchAllGroups(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('groups', requestModel, context);
    AllGroupsModel responseModel =
        AllGroupsModel.fromJson(json.decode(response.body));
    emit(state.copyWith(
        isLoading: false,myGroupList: responseModel.joined_group!));
  }

 Future<bool> createGroup(BuildContext context, FormData requestModel) async {
    emit(state.copyWith(isLoading: true));

    bool apiStatus=false;;

    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'createGroup',
          data: requestModel);
      var responseBody = response.data;
      emit(state.copyWith(isLoading: false));

      String jsonsDataString = responseBody.toString();
      final jsonData = jsonDecode(jsonsDataString);
      print('Group Creation Log');
      print(jsonData);
      if (jsonData['status'] == 1) {
        apiStatus=true;

        //success
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
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

  Future<bool> createGroupFriends(BuildContext context, FormData requestModel) async {


    bool apiStatus=false;
    APIDialog.showAlertDialog(context,'Creating group...');

    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'createGroup',
          data: requestModel);
      Navigator.pop(context);
      var responseBody = response.data;


      print(responseBody);
      String jsonsDataString = responseBody.toString();
      print('DAYTATATAT');
      final jsonData = jsonDecode(jsonsDataString);
      print(jsonData);
      if (jsonData['status'] == 1) {
        int groupId=jsonData['data']['id'];
        AppModel.setGroupId(groupId);
        apiStatus=true;
        //success
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
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

  Future<bool> joinGroup(BuildContext context, Map<String, dynamic> requestModel) async {
     bool apiStatus=false;
    APIDialog.showAlertDialog(context, 'Joining Group...');
    var response = await helper.postAPI('joinGroup', requestModel, context);
     Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if (responseJson['status'] == AppConstant.apiSuccess) {
      // handle data
      apiStatus=true;
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      apiStatus=false;
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }
    return apiStatus;
  }

 deleteGroup(BuildContext context, Map<String, dynamic> requestModel) async {

    APIDialog.showAlertDialog(context, 'Deleting Group...');
    var response = await helper.postAPI('deleteGroup', requestModel, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if (responseJson['status'] == AppConstant.apiSuccess) {

      Navigator.pop(context,'Group Deleted');

      // handle data

      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  Future<bool> inviteFriend(BuildContext context, Map<String, dynamic> requestModel) async {

    bool apiStatus=false;
    APIDialog.showAlertDialog(context, 'Sending invitation...');
    var response = await helper.postAPI('groupInvitation', requestModel, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if (responseJson['status'] == AppConstant.apiSuccess) {

      apiStatus=true;
      // handle data

      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      apiStatus=false;
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    return apiStatus;
  }

  Future<bool> exitGroup(BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus=false;
    APIDialog.showAlertDialog(context, 'Leaving Group...');
    var response = await helper.postAPI('exitGroup', requestModel, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if (responseJson['status'] == AppConstant.apiSuccess) {
      // handle data
      apiStatus=true;
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      apiStatus=false;
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    return apiStatus;
  }





  groupInfo(BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('groupInfo', requestModel, context);
    print(json.decode(response.body.toString()));
    emit(state.copyWith(isLoading: false));
    GroupInfoModel responseModel =
        GroupInfoModel.fromJson(json.decode(response.body));
    print(responseModel.group_post!.toString());
    emit(state.copyWith(groupPosts: responseModel.group_post!,isGroupMember: responseModel.alredy_joined!,groupInfo: responseModel.group_info));
  }
  updateGroupReactions(List<GroupPost> list){
    emit(state.copyWith(groupPosts: list));
  }


}
