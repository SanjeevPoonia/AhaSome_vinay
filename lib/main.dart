import 'dart:convert';
import 'dart:io';

import 'package:aha_project_files/app_module.dart';
import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/view/birthday_cake.dart';
import 'package:aha_project_files/view/gratitude_screens.dart';
import 'package:aha_project_files/view/home_screen.dart';
import 'package:aha_project_files/view/login_screen.dart';
import 'package:aha_project_files/view/profile_new_sceen.dart';
import 'package:aha_project_files/view/shoutouts_screen.dart';
import 'package:aha_project_files/view/splash2.dart';
import 'package:aha_project_files/view/splash_screen.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/update_app_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/services.dart';
import 'package:aha_project_files/main.reflectable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'main.mapper.g.dart' show initializeJsonMapper;
import 'package:shared_preferences/shared_preferences.dart';

import 'models/login_response.dart';
import 'network/bloc/auth_bloc.dart';
//part 'main.mapper.g.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  List<String>? hobbies=[];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
   LoginModel userData=LoginModel(1, '','', '', '', '', 0,hobbies);
      String token=prefs.getString('access_token') ?? 'notLogin';
  if(token!='notLogin')
    {
      // create session for user
      var userPref = prefs.getString('userdata');
      userData = LoginModel.fromJson(json.decode(userPref.toString()));
      AppModel.setAuthKey(token);
    }
  else
    {
      AppModel.setAuthKey('');
    }
  print(token);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppTheme.navigationRed, // status bar color
  ));
  initializeReflectable();
  initializeJsonMapper();
  //HttpOverrides.global = MyHttpOverrides();

  runApp( MyApp(token,userData));
}

class MyApp extends StatefulWidget {
  final String token;
  final LoginModel userData;
   MyApp(this.token,this.userData);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>
{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ModularApp(module: AppModule(), child: MaterialApp(
        title: 'AHA',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            fontFamily: 'Allerta'
        ),
        home:
      /*  Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child:

          widget.token=='notLogin'?
          SplashScreen( widget.token):
          HomeScreen( widget.userData),
        )
*/

      FutureBuilder(
            future: checkUpdateRequired(context),
            builder: (context,snapshot)
            {
              if (snapshot.connectionState != ConnectionState.done)
                return Container(
                  color: Colors.white,
                );
              else if (snapshot.connectionState==ConnectionState.done && snapshot.data==true)
                return UpdateAppScreen();

              else
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child:

                  widget.token=='notLogin'?
                  SplashScreen( widget.token):
                  HomeScreen( widget.userData),
                );
              // return main screen here
            }

        )


    ));
  }
  Future<bool>checkUpdateRequired(BuildContext context) async {
    bool updateRequired=false;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print(version);

    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 12),
      minimumFetchInterval: const Duration(hours: 1),
    ));
   /* await remoteConfig.setDefaults(<String, dynamic>{
      'android_version': '1.0.1',
      'ios_version': '1.71'
    });*/
    //RemoteConfigValue(RemoteConfigValue, ValueSource.valueStatic);

    await remoteConfig.ensureInitialized();
   // await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    print('SERVER VERSION');
    //print(remoteConfig.getString('android_version'));

    String versionName;
    if(Platform.isIOS)
      {
        versionName=remoteConfig.getString('ios_version');
      }
    else
      {
        versionName=remoteConfig.getString('android_version');
      }
    print('sfwfwf');

    print(versionName);

    int userAppVersion = getExtendedVersionNumber(version); // return 10020003
    int storeAppVersion = getExtendedVersionNumber(versionName); // return 10020011


    if(userAppVersion<storeAppVersion)
    {
      print('UPDATE FOUND');
      updateRequired=true;
    }
    else
    {
      print('NO UPDATE');
      updateRequired=false;
    }
    return updateRequired;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
}

