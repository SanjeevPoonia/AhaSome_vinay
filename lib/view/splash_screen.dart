import 'dart:convert';

import 'package:aha_project_files/models/login_response.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/view/home_screen.dart';
import 'package:aha_project_files/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  final String tokenValue;

  SplashScreen(this.tokenValue);

  SplashState createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  VideoPlayerOptions videoPlayerOptions =
      VideoPlayerOptions(mixWithOthers: true);
  bool pageNavigator = false;
  final authBloc = Modular.get<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  void initState() {
    print(widget.tokenValue);
    if (widget.tokenValue == 'notLogin') {
    } else {
      _fetchUserData();
    }

    super.initState();
    _controller = VideoPlayerController.asset('assets/splash_video.mp4',
        videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            if (!pageNavigator) {
              pageNavigator = true;

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
            }
          }
        });
        _controller.play();
        setState(() {});
      });
  }

  _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPref = prefs.getString('userdata');
    LoginModel userData = LoginModel.fromJson(json.decode(userPref.toString()));
    authBloc.fetchCheckInDetails(userData);
  }

  @override
  void dispose() {
    _controller.pause(); // mute instantly
    _controller.dispose();
    super.dispose();
  }
}
