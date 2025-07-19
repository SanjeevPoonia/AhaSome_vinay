import 'dart:convert';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/view/add_gratitude.dart';
import 'package:aha_project_files/utils/strings.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/small_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../utils/image_assets.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart' as Aud;


class GratitudeScreen extends StatefulWidget {
  const GratitudeScreen({Key? key}) : super(key: key);

  @override
  GratitudeState createState() => GratitudeState();
}

class GratitudeState extends State<GratitudeScreen> {
   AudioPlayer? advancedPlayer;
   final musicPlayer = Aud.AudioPlayer();
   AudioCache? audioCache;
   bool videoLoading=false;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  late VideoPlayerController _controller;
  final authBloc = Modular.get<AuthCubit>();
  String videoUrl='';
  String audioUrl='';
  bool musicPlaying=false;
  bool musicLayout=false;
  String videoURLasset='';
   final FocusNode focusNode = FocusNode();
   List<Color> colorList = [
    AppTheme.gratitudeOrange,
    AppTheme.gratitudePink,
    AppTheme.dashboardTeal
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          color: AppTheme.navigationRed,
          child: SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: [
                      BackgroundWidget(),
                      BlocBuilder(
                          bloc: authBloc,
                          builder: (context, state) {
                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 230,
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(top: 40),
                                      child:
                                      videoLoading?

                                      VideoPlayer(_controller):
                                          Container(
                                            color: Colors.grey.withOpacity(0.5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SmallLoader(Colors.blue),
                                                const SizedBox(width: 10),

                                                const Text('Loading video...'),

                                              ],
                                            )
                                          )

                                    ),
                                    GradientAppBar(
                                      onTap: () {
                                        musicPlayer.stop();
                                        Navigator.pop(context);
                                      },
                                      iconButton: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert_outlined,
                                            color: Colors.white),
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
                                  ],
                                ),
                                Expanded(
                                    child: authBloc.state.isLoading
                                        ? Loader()
                                        : ListView (
                                            children: [
                                              Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      SizedBox(width: 20),


                                                     musicLayout? InkWell(
                                                            onTap: (){

                                                              if(musicPlayer.playing)
                                                                {
                                                                  print('Music Stop');
                                                                  musicPlayer.pause();
                                                                  setState(() {
                                                                    //musicPlaying=!musicPlaying;
                                                                  });
                                                                }
                                                              else
                                                                {
                                                                  musicPlayer.play();
                                                                 // musicPlaying=!musicPlaying;
                                                                  setState((){
                                                                  });
                                                                }

                                                            },
                                                            child: Icon(musicPlayer.playing?Icons.pause:Icons.play_arrow,size: 30,),
                                                          ):Container(),
                                                       const SizedBox(width: 5),
                                                        musicLayout? Text(musicPlayer.playing?'Stop Music':'Play Music'):Container(),
                                                      const Spacer(),


                                                      InkWell(
                                                        onTap: () async {
                                                          final result = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      AddGratitude(
                                                                          8888,videoUrl,_controller,musicPlayer)));
                                                          if (result != null) {
                                                            _controller.play();
                                                            musicPlayer.play();
                                                            _callAPI();
                                                          }
                                                          else
                                                            {
                                                              setState(() {

                                                              });
                                                            }
                                                        },
                                                        child: Container(
                                                            height: 47,
                                                            width: 120,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              gradient:
                                                                  const LinearGradient(
                                                                colors: [
                                                                  AppTheme
                                                                      .gradient2,
                                                                  AppTheme
                                                                      .gradient1,
                                                                ],
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                //stops: [0, 0, 0.47, 1],
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                AppStrings.add,
                                                                style: TextStyle(
                                                                    fontSize: 17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 20),
                                                        child: Text(
                                                          '${AppStrings
                                                                  .lastGratitude}(${authBloc
                                                                  .state
                                                                  .gratitudeList
                                                                  .length})',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Image.asset(
                                                        ImageAssets.danceGif,
                                                        width: 90,
                                                        height: 90,
                                                      )
                                                    ],
                                                  ),
                                                  ListView.builder(
                                                      itemCount: authBloc.state
                                                          .gratitudeList.length,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int pos) {
                                                        return Column(
                                                          children: [
                                                            Card(
                                                              color: pos % 2 == 0
                                                                  ? AppTheme
                                                                      .gradient2
                                                                  : colorList[2],
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18)),
                                                              margin:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          15),
                                                              child: Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          15),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(

                                                                        children: [
                                                                          Text(
                                                                            _parseServerDate(authBloc
                                                                                .state
                                                                                .gratitudeList[pos]
                                                                                .created_at
                                                                                .toString()),
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 13,
                                                                                color: Colors.white),
                                                                          ),
                                                                          Spacer(),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              final result =
                                                                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => AddGratitude(pos,videoUrl,_controller,musicPlayer)));
                                                                              if (result !=
                                                                                  null) {
                                                                                _callAPI();
                                                                              }
                                                                              else
                                                                                {
                                                                                  setState(() {

                                                                                  });
                                                                                }
                                                                            },
                                                                            child:
                                                                                const Icon(
                                                                              Icons.mode_edit_outline_outlined,
                                                                              color:
                                                                                  Colors.white,
                                                                              size:
                                                                                  24,
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: 10),

                                                                          GestureDetector(
                                                                            onTap:
                                                                                () async {


                                                                              deleteGratitude(authBloc
                                                                                  .state
                                                                                  .gratitudeList[pos]
                                                                                  .id!);
                                                                            },
                                                                            child:
                                                                            const Icon(
                                                                              Icons.delete,
                                                                              color:
                                                                              Colors.white,
                                                                              size:
                                                                              24,
                                                                            ),
                                                                          )



                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              5),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                              child:
                                                                              ReadMoreText(
                                                                                authBloc
                                                                                    .state
                                                                                    .gratitudeList[pos]
                                                                                    .gratitude!,
                                                                                trimLines: 2,
                                                                                style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontFamily: 'Baumans',
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w600),
                                                                                colorClickableText: Colors.blue,
                                                                                trimMode: TrimMode.Line,
                                                                                trimCollapsedText: 'Show more',
                                                                                trimExpandedText: 'Show less',
                                                                                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),
                                                                              )



                                                                                  /*Text(
                                                                            authBloc
                                                                                .state
                                                                                .gratitudeList[pos]
                                                                                .gratitude!,
                                                                            style: const TextStyle(
                                                                                fontSize: 15,
                                                                                fontFamily: 'Baumans',
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w600),
                                                                          )
                                                                          */

                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        );
                                                      })
                                                ],
                                              )
                                            ],
                                          ))
                              ],
                            );
                          })
                    ],
                  ))),
        ),
        onWillPop: () {
         musicPlayer.stop();
          Navigator.pop(context);
          return Future.value(false);
        });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

  void playMusic() async {
    advancedPlayer!.play(audioUrl);
  //  audioCache.play('gratitude_audio.mp3');
    print('Music Started');
  }

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    super.initState();
    fetchVideoAndAudio();
    _callAPI();
 //   fetchVideo();

  }

  _initializeVideoPlayer(){
    _controller = VideoPlayerController.network(videoUrl, videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        videoLoading=true;
        setState(() {});
        });
  }

  String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    final DateFormat dayFormatter = DateFormat.MMMEd();
    String dayAsString = dayFormatter.format(dateLocal);
    return dayAsString;
  }

  _callAPI() {
    var formData = {'auth_key': AppModel.authKey};
    authBloc.fetchAllGratitude(context, formData);

  }

  initPlayer() async {
    advancedPlayer = AudioPlayer();
    await advancedPlayer!.setUrl(audioUrl);
    musicPlaying=true;

    setState(() {});
  //  audioCache = AudioCache(fixedPlayer: advancedPlayer);
    playMusic();
  }

  fetchVideoAndAudio() async {
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('gratitudeFile', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    videoUrl=responseJson['gratitude_video'].toString().trim();
    audioUrl=responseJson['gratitude_audio'].toString().trim();
    _startMusic();
   // initPlayer();
    _initializeVideoPlayer();
    setState(() {});

  }



   deleteGratitude(int gratitudeId) async {
    APIDialog.showAlertDialog(context, 'Deleting');
     var formData = {'auth_key': AppModel.authKey,'gratitude_id':gratitudeId};
     ApiBaseHelper helper = ApiBaseHelper();
     var response = await helper.postAPI('deleteGratitude', formData, context);
     var responseJson = jsonDecode(response.body.toString());
     print(responseJson);
     Navigator.pop(context);
     if(responseJson['status']==1)
       {
         _callAPI();
       }
   }



   @override
   void dispose() {
     super.dispose();
     musicPlayer.dispose();
     _controller.pause();
     _controller.dispose();
   //  advancedPlayer!.dispose();
   }

   fetchVideo() async {

    SharedPreferences prefs=await SharedPreferences.getInstance();
    String? videoStatus=prefs.getString('video');

    if(videoStatus==null)
      {
        prefs.setString('video', 'assets/gratitude_1.mp4');
        videoURLasset='assets/gratitude_1.mp4';
      }

    else if(videoStatus=='assets/gratitude_1.mp4')
      {
        videoURLasset='assets/gratitude_2.mp4';
        prefs.setString('video', 'assets/gratitude_2.mp4');
      }

    else if(videoStatus=='assets/gratitude_2.mp4')
      {
        videoURLasset='assets/gratitude_1.mp4';
        prefs.setString('video', 'assets/gratitude_1.mp4');
      }

    _initializeVideoPlayer();
   }


_startMusic() async {
  musicPlayer.setUrl(           // Load a URL
      audioUrl);
  musicPlayer.setLoopMode(Aud.LoopMode.all);

 /* await musicPlayer.(Aud.AudioSource.uri(Uri.parse(
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));*/

  musicPlayer.play();
  musicLayout=true;
  musicPlaying=true;
  setState(() {

  });

}



}
