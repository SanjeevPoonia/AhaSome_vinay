



import 'dart:io';

import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/player_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/video_widget/video_control.dart';

import 'package:chewie/chewie.dart';

class LocalVideoScreen extends StatefulWidget
{
  final String videoUrl;
  LocalVideoScreen(this.videoUrl);

  @override
  FullVideoScreenState createState()=>FullVideoScreenState();
}

class FullVideoScreenState extends State<LocalVideoScreen>
{
   VideoPlayerController? _controller;
  late final chewieController;
  bool pageNavigator=false;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(
        body: Column(
          children: [
            AppBarNew(
              onTap: () {
                Navigator.pop(context);
              },
              iconButton: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
              showBackIc: true,
            ),

           Expanded(child:  _controller!.value.isInitialized
               ? Center(
             child: SizedBox(
                 child: AspectRatio(
                     aspectRatio: _controller!.value.aspectRatio,
                     child:

                     Chewie(
                       controller: chewieController,
                     )


                   /*Stack(
                    alignment: Alignment.bottomCenter,
                    children: [

                      VideoPlayer(_controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  )*/
                 )
             ),
           )
               :


         /* Container(
          //  height: 180,
            child: Stack(
              children: [
                Center(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:  widget.thumbnailUrl,
                    placeholder: (context, url) =>Container(),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
                Center(
                  child: Loader(),
                )

              ],
            ),
          )*/

             Center(
               child: Loader(),
             )






             /*  Center(
             child: Loader(),
           ),*/)
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.videoUrl);
    print('******Playing****');

    _onControllerChange(widget.videoUrl);


 /*   _controller = VideoPlayerController.network(widget.videoUrl, videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            _controller.play();
          }
        });
        _controller.play();
        setState(() {});
      });*/
  }

  prepareVideo() async {
    _controller=VideoPlayerController.file(
        File(widget.videoUrl));
    await _controller!.initialize();

    chewieController=await ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: false,
    );
    setState(() {

    });

  }


  Future<void> _onControllerChange(String link) async {
    if (_controller == null) {
      // If there was no controller, just create a new one
     prepareVideo();
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldController = _controller;

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
        _controller = null!;
      });
    }}
  @override
  void dispose() {
    _controller!.pause();
    _controller!.dispose();
    chewieController.dispose();
    super.dispose();
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }
}