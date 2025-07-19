import 'dart:io';

import 'package:aha_project_files/widgets/player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/app_theme.dart';

class VideoWidget extends StatefulWidget {

  final bool play;
  final String url;
  final Color loaderColor;
  final double iconSize;

   VideoWidget({required this.url, required this.play,required this.loaderColor,required this.iconSize});


  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
   VideoPlayerController? videoPlayerController ;
 // late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    print('NEW URL****');
    print(widget.url);

   _onControllerChange(widget.url);
  /*  videoPlayerController = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });*/
  } // This closing tag was missing

  // video player not getting initialized and will be disposed when it is not revoked


  @override
  void dispose() {
    videoPlayerController!.pause();
    videoPlayerController!.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
      ),
      height: 180,
      child:ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: VideoPlayer(videoPlayerController!),
      ),
    );
  }

  Future<void> _onControllerChange(String link) async {
    print('VIDEO INITIALIAZATION triggered');
    if (videoPlayerController == null) {
      print('No video player found');
      // If there was no controller, just create a new one
      prepareVideo();
    } else {
      print('video player found');
      // If there was a controller, we need to dispose of the old one first
      final oldController = videoPlayerController;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController!.dispose();

        // Initing new controller
        prepareVideo();
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        videoPlayerController = null!;
      });
    }}

  prepareVideo() async {
    print(widget.url);
    print('VIDEO INITIALIAZATION STARTED');
    videoPlayerController=VideoPlayerController.file(
        File(widget.url));
     videoPlayerController!.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });

  }

}