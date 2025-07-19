import 'dart:typed_data';

import 'package:aha_project_files/network/api_dialog.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../view/login_screen.dart';
import '../widgets/custom_drawer/bloc/home_page_bloc.dart';

class Utils {
  static Future<void> logoutUser(BuildContext context) async {

    APIDialog.showAlertDialog(context, 'Logging out...');

      if(HomePageBloc.isOpen)
        {
          HomePageBloc().closeDrawer();
        }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await DefaultCacheManager().emptyCache();

    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
    Toast.show('Logged out successfully',
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.green);
  }

  static Future<void> deactivateAccount(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Deactivating account...');
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
      Toast.show('Account Deactivated successfully',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    });
  }

  static Future<void> tokenExpired(BuildContext context) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await DefaultCacheManager().emptyCache();
    if(HomePageBloc.isOpen)
    {
      HomePageBloc().closeDrawer();
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
    Toast.show('Session expired, please login to continue',
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);
  }



  Future<Uint8List> returnThumbnail(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 15,
    );
    return uint8list!;
  }

  static String _parseServerDate(String date) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    String timeStamp= timeago.format(dateTime).toString();
    return timeStamp;
  }
  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
   /* await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));*/
   /* await remoteConfig.setDefaults(<String, dynamic>{
      'welcome': 'default welcome',
      'hello': 'default hello',
    });*/

    remoteConfig.fetch();

    RemoteConfigValue(null, ValueSource.valueStatic);
    return remoteConfig;
  }
}
