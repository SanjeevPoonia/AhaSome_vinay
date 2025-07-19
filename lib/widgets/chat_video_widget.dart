import 'package:aha_project_files/widgets/player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/app_theme.dart';

class ChatVideoWidget extends StatefulWidget {

  final bool play;
  final String url;
  final Color loaderColor;

  ChatVideoWidget({required this.url, required this.play,required this.loaderColor});


  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<ChatVideoWidget> {
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.pause();
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(8),
              // color: Colors.green,
            ),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(8),
                // color: Colors.green,
              ),
              child:   Stack(
                children: [
                  VideoPlayer(videoPlayerController),
                  Controls(controller: videoPlayerController,iconSize: 70,)
                ],
              ),
            ),
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(

              valueColor: AlwaysStoppedAnimation<Color>(widget.loaderColor),
            ),);
        }
      },
    );
  }
}