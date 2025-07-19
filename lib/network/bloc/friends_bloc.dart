import 'dart:convert';

import 'package:aha_project_files/models/common_model.dart';
import 'package:aha_project_files/models/find_friends_model.dart';
import 'package:aha_project_files/models/friend_profile.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toast/toast.dart';

import '../../models/all_friends_model.dart';
import '../../models/friend_requests.dart';
import '../../models/shouts_model.dart';
import '../../utils/app_theme.dart';
import '../api_helper.dart';

part 'friends_state.dart';

part 'friends_bloc.freezed.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit() : super(const FriendsState());
  ApiBaseHelper helper = ApiBaseHelper();
   Future<bool> fetchAllFriends(
      BuildContext context, Map<String, dynamic> requestModel) async {
    bool noData=false;
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('friendList', requestModel, context);
    emit(state.copyWith(isLoading: false));
    AllFriendsResponse friendData =
        AllFriendsResponse.fromJson(json.decode(response.body));


    if (friendData.status == 1) {
      if(friendData.friendList!.length==0)
        {
          noData=true;
        }
      else
        {
          noData=false;
        }



      // success
      emit(state.copyWith(friendList: friendData.friendList!,pendingRequestsCount: friendData.pending_request_count!,friendsCount: friendData.friend_count!));
    } else {}
    return noData;
  }


  updateSearchList(List<Friends> results)
  {
    emit(state.copyWith(searchFriendList: results));
  }

  updatePostReactions(List<FriendPost> friendPosts){
    emit(state.copyWith(friendPostList: friendPosts));
  }

  fetchPendingRequests(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response =
        await helper.postAPI('pendingRequest', requestModel, context);
    FriendRequests requestData =
        FriendRequests.fromJson(json.decode(response.body));

    if (requestData.status == 1) {
      // success
      emit(state.copyWith(
          isLoading: false, requestList: requestData.pending_request!,pendingRequestsCount: requestData.pending_request_count!,friendsCount: requestData.friend_count!));
    }
  }

  fetchFriendProfile(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('friendProfile', requestModel, context);
    emit(state.copyWith(
        isLoading: false));
    FriendProfileModel postList =
        FriendProfileModel.fromJson(json.decode(response.body));

    if (postList.status == 1) {
      // success
      emit(state.copyWith(
           friendPostList: postList.friend_post!,friendProfile: postList.friend_profile!,isFriend: postList.if_friend!));
    } else {}
  }

  acceptFriendRequest(
      BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus = false;
    emit(state.copyWith(isRequestLoading: true));

    var response =
        await helper.postAPI('requestAccepted', requestModel, context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      emit(state.copyWith(
          isRequestLoading: false,
          apiMessage: model.message,
          apiStatus: model.status));
      apiStatus = true;
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
      //refresh Data
    } else {
      apiStatus = false;
      emit(state.copyWith(isRequestLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }

    return apiStatus;
  }

  deleteFriendRequest(
      BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus = false;
    emit(state.copyWith(isRequestLoading: true));

    var response =
        await helper.postAPI('requestRejected', requestModel, context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      emit(state.copyWith(
          isRequestLoading: false,
          apiMessage: model.message,
          apiStatus: model.status));
      apiStatus = true;
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
      //refresh Data
    } else {
      apiStatus = false;
      emit(state.copyWith(isRequestLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }

    return apiStatus;
  }

  removeFriend(BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus = false;
    APIDialog.showAlertDialog(context, 'Please wait...');

    var response = await helper.postAPI('unfriend', requestModel, context);
    Navigator.pop(context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      emit(state.copyWith(
          apiMessage: model.message,
          apiStatus: model.status));
      apiStatus = true;
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
      //refresh Data
    } else {
      apiStatus = false;
      emit(state.copyWith(isRequestLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }

    return apiStatus;
  }

  addFriend(BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus = false;
    APIDialog.showAlertDialog(context, 'Please wait...');
    var response = await helper.postAPI('followRequest', requestModel, context);
    Navigator.pop(context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      emit(state.copyWith(
          apiMessage: model.message,
          apiStatus: model.status));
      apiStatus = true;
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);


      //refresh Data
    } else {
      apiStatus = false;
      emit(state.copyWith(isRequestLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }

    return apiStatus;
  }
  fetchAllShouts(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('userPromisesList', requestModel, context);
    ShoutModel promisesData =
    ShoutModel.fromJson(json.decode(response.body));

    if (promisesData.status == 1) {
      // success
      emit(state.copyWith(isLoading: false,shoutList: promisesData.user_all_promises!));
    }
  }

  fetchFindFriends(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('findFriendList', requestModel, context);
    FindFriendsModel modelList=FindFriendsModel.fromJson(json.decode(response.body));
    emit(state.copyWith(isLoading: false,findFriendList: modelList.find_friend_list!));
  }


  deletePost(BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus = false;
    var response = await helper.postAPI('deletePost', requestModel, context);
    Navigator.pop(context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      emit(state.copyWith(
          apiMessage: model.message,
          apiStatus: model.status));

   /*   int? count = dashboardBloc.state.ahaByMe;
      count=count!-1;
      dashboardBloc.updateAHAByMe(count);*/



      apiStatus = true;
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
      //refresh Data
    } else {
      apiStatus = false;
      emit(state.copyWith(isRequestLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }

    return apiStatus;
  }
}
