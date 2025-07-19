

import 'package:aha_project_files/view/gratitude_screens.dart';
import 'package:aha_project_files/utils/image_assets.dart';
import 'package:aha_project_files/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class SignUpSuccess extends StatefulWidget
{
  const SignUpSuccess({Key? key}) : super(key: key);

  @override
  SignUpSuccessState createState()=>SignUpSuccessState();
}

class SignUpSuccessState extends State<SignUpSuccess>
{
  late VideoPlayerController _controller;
  bool pageNavigator=false;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
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
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    _controller = VideoPlayerController.asset('assets/registration_gif.mp4',videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            if(!pageNavigator)
            {
              pageNavigator=true;
              Route route = MaterialPageRoute(builder: (context) => LoginScreen());
              Navigator.pushAndRemoveUntil(
                  context, route, (Route<dynamic> route) => false);
            }
          }
        });
        _controller.play();
        setState(() {});
      });
  }

}