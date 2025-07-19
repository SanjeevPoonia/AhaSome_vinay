

import 'package:aha_project_files/view/gratitude_screens.dart';
import 'package:aha_project_files/utils/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart' as Aud;

import '../models/app_modal.dart';
import '../network/bloc/auth_bloc.dart';
import '../network/bloc/dashboard_bloc.dart';


class GratitudeSuccess extends StatefulWidget
{

  final Aud.AudioPlayer musicPlayer;
  VideoPlayerController _controller22;
  GratitudeSuccess(this.musicPlayer,this._controller22);
  @override
  GratitudeState createState()=>GratitudeState();
}

class GratitudeState extends State<GratitudeSuccess>
{
  final authBloc = Modular.get<AuthCubit>();
  final dashboardBloc = Modular.get<DashboardCubit>();
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
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    _controller = VideoPlayerController.asset('assets/gif_thanks.mp4', videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            if(!pageNavigator)
            {
              pageNavigator=true;
              // Update Dashboard Gratitude count
              updateGratitudeCount();

              Navigator.pop(context);
              _callAPI();
              widget.musicPlayer.play();
              widget._controller22.play();

            }
          }
        });
        _controller.play();
        setState(() {});
      });
  }
  _callAPI() {
    var formData = {'auth_key': AppModel.authKey};
    authBloc.fetchAllGratitude(context, formData);

  }
  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  updateGratitudeCount(){
    int? currentCount=dashboardBloc.state.gratitudeCount;
    currentCount=currentCount!+1;
    dashboardBloc.updateGratitudeCount(currentCount);
  }
}