import 'dart:convert';

import 'package:aha_project_files/models/gratitude_model.dart';
import 'package:aha_project_files/models/login_response.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/api_helper.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/login_screen.dart';
import 'package:aha_project_files/view/sign_up_success.dart';
import 'package:aha_project_files/view/verify_email.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toast/toast.dart';
import '../../models/albums_model.dart';
import '../../models/app_modal.dart';
import '../../models/common_model.dart';
import '../../view/forgot_otp_screen.dart';
import '../../view/gratitude_success_screen.dart';
import '../../view/home_screen.dart';
import '../../view/otp_screen.dart';
import '../Utils.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  ApiBaseHelper helper = ApiBaseHelper();

  updateProfileImage(BuildContext context, FormData requestModel) async {
    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      APIDialog.showAlertDialog(context, 'Updating image...');
      final response = await dio.post(
          AppConstant.appBaseURL + 'updateProfileImage',
          data: requestModel);
      var responseBody = response.data;
      Navigator.pop(context);
      final jsonData = jsonDecode(responseBody.toString());
      if (jsonData['status'] == AppConstant.apiSuccess) {
        AppModel.setNewPost(true);
        emit(state.copyWith(profileImage: jsonData['profile_image']));

        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        Navigator.pop(context);
      } else {
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    } catch (errorMessage) {
      String message = errorMessage.toString();
      print(message);
    }
  }

  updateCoverImage(BuildContext context, FormData requestModel) async {
    try {
      Dio dio = Dio();
      APIDialog.showAlertDialog(context, 'Updating image...');
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'updateBgImage',
          data: requestModel);
      Navigator.pop(context);
      var responseBody = response.data;
      final jsonData = jsonDecode(responseBody.toString());
      if (jsonData['status'] == AppConstant.apiSuccess) {
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        Navigator.pop(context);
      } else {
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    } catch (errorMessage) {
      String message = errorMessage.toString();
      print(message);
    }
  }

  loginUser(String urlEndPoint, BuildContext context,
      Map<String, dynamic> requestModel) async {
    APIDialog.showAlertDialog(context, 'Logging in...');
    var response = await helper.postAPI(urlEndPoint, requestModel, context);

    Navigator.of(context, rootNavigator: true).pop();



    var responseJSON = json.decode(response.body);
    if (responseJSON['status'] == AppConstant.apiSuccess) {
      // success
      LoginModel userData = LoginModel.fromJson(json.decode(response.body));
      AppModel.setAuthKey(userData.authKey!);
      emit(state.copyWith(userModel: userData));
      _saveUserDetail(userData);
      Route route = MaterialPageRoute(builder: (context) => HomeScreen(userData));
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
      Toast.show('Logged in successfully !!',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
    }

    else if(responseJSON['message']=='Please verify your email first.')
      {
        Toast.show(responseJSON['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);


        Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyEmail(requestModel['email'])));
      }

    else {




      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


  verifyUserOTP(BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response =
        await helper.postAPI('OtpVerifiaction', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);

    if (responseJSON['status'] == 1) {
      // success
      Route route = MaterialPageRoute(builder: (context) => const SignUpSuccess());
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);

      Toast.show('OTP verified successfully !',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);
    } else {
      ToastContext().init(context);
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }



    }


  addNewUser(BuildContext context, FormData requestModel) async {
    emit(state.copyWith(isLoading: true));
    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'RegisterUser',
          data: requestModel);
      var responseBody = response.data;
      Navigator.pop(context);
      print(responseBody);
      String jsonsDataString = responseBody.toString();
      final jsonData = jsonDecode(jsonsDataString);
      if (jsonData['status'] == 1) {
        print(jsonsDataString + 'Data From server');
        Route route = MaterialPageRoute(
            builder: (context) => OTPScreen(
                jsonData['verifiaction_otp'].toString(),
                jsonData['user_email'],
                'SignUp'));
        Navigator.pushAndRemoveUntil(
            context, route, (Route<dynamic> route) => false);
        Toast.show('Account Created Successfully,please verify your OTP !!',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.greenAccent);
      } else {
        Toast.show(jsonData['data'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } catch (errorMessage) {
      Navigator.pop(context);
      String message = errorMessage.toString();
      print(message);
    }
  }

  fetchCheckInDetails(LoginModel userData) async {
    emit(state.copyWith(userModel: userData));
    emit(state.copyWith(
        hobbies: userData.hobbies!,
        firstName: userData.firstName!,
        lastName: userData.lastName!,
        profileImage: userData.profileImage!,
        userId: userData.userId!));
  }

  _saveUserDetail(LoginModel response) async {
    MyUtils.saveSharedPreferences('access_token', response.authKey.toString());
    MyUtils.saveSharedPreferences('userdata', jsonEncode(response));
    emit(state.copyWith(
      hobbies: response.hobbies!,
        firstName: response.firstName!,
        lastName: response.lastName!,
        profileImage: response.profileImage!,
        userId: response.userId!));
  }

  void updateData() {}

  fetchAllGratitude(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response =
        await helper.postAPI('userGratitudeList', requestModel, context);
    print('****');
    print(response.toString());
    GratitudeModel model = GratitudeModel.fromJson(json.decode(response.body));
    emit(state.copyWith(isLoading: false, gratitudeList: model.gratitudeList!));
  }

  Future<bool> addGratitude(BuildContext context, Map<String, dynamic> requestModel) async {
    bool apiStatus=false;
    emit(state.copyWith(isLoading: true));

    var response = await helper.postAPI('saveGratitude', requestModel, context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      apiStatus=true;
      emit(state.copyWith(isLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);




      //refresh Data
    } else {
      apiStatus=false;
      emit(state.copyWith(isLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }
    return apiStatus;
  }

  editGratitude(BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));

    var response = await helper.postAPI('editGratitude', requestModel, context);
    CommonModel model = CommonModel.fromJson(json.decode(response.body));
    if (model.status == AppConstant.apiSuccess) {
      emit(state.copyWith(isLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);

      Navigator.pop(context, 'Data Refreshed');

      //refresh Data
    } else {
      emit(state.copyWith(isLoading: false));
      Toast.show(model.message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      // do not refresh
    }
  }

  fetchUserAlbums(
      BuildContext context, Map<String, dynamic> requestModel) async {
    emit(state.copyWith(isLoading: true));
    var response = await helper.postAPI('userAlbum', requestModel, context);
    AlbumModel model = AlbumModel.fromJson(json.decode(response.body));
    emit(state.copyWith(
        isLoading: false,
        userAlbumList: model.user_profile_image!,
        postsAlbumList: model.user_post!));
  }

  refreshNameEveryWhere(String firstName, String lastName) {
    emit(state.copyWith(firstName: firstName, lastName: lastName));
  }

  sendOtpForgot(BuildContext context, Map<String, dynamic> requestModel) async {

    APIDialog.showAlertDialog(context, 'Sending OTP...');

    var response =
        await helper.postAPI('forgotPassword', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.body);

    if(responseJSON['message']=='User Account not found')
      {
        Toast.show(responseJSON['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else
      {
        Toast.show('We have sent an OTP on your mail',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForgotOTPScreen(responseJSON['verifiaction_otp'].toString(),
                    responseJSON['user_email'], 'Forgot')));
      }



  }

  Future<String> resendOtp(BuildContext context, Map<String, dynamic> requestModel) async {

    String otp='';
    APIDialog.showAlertDialog(context, 'Sending OTP...');

    var response =
    await helper.postAPI('ResendOtp', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['status'] == AppConstant.apiSuccess) {
      Toast.show('We have sent an OTP on your mail',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      otp=responseJSON['verifiaction_otp'].toString();


  /*    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(responseJSON['verifiaction_otp'].toString(),
                  responseJSON['user_email'], 'Forgot')));*/
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }
    return otp;
  }





  resendOtpVerify(BuildContext context, Map<String, dynamic> requestModel) async {

    APIDialog.showAlertDialog(context, 'Sending OTP...');

    var response =
    await helper.postAPI('ResendOtp', requestModel, context);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['status'] == AppConstant.apiSuccess) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      String otp=responseJSON['verifiaction_otp'].toString();


          Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(responseJSON['verifiaction_otp'].toString(),
                  responseJSON['user_email'], 'Verify')));
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }

  }


  changeForgotPassword(BuildContext context, Map<String, dynamic> requestModel) async {
    APIDialog.showAlertDialog(context, 'Please wait...');

    var response =
    await helper.postAPI('savePassword', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['status'] == AppConstant.apiSuccess) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      Route route = MaterialPageRoute(builder: (context) => LoginScreen());
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);




    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }



}
