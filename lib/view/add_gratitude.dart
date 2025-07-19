import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/gratitude_success_screen.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/utils/image_assets.dart';
import 'package:aha_project_files/utils/strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:video_player/video_player.dart';

import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';
import 'package:just_audio/just_audio.dart' as Aud;

import '../widgets/small_loader.dart';
class AddGratitude extends StatefulWidget {
  final int position;
  final String videoUrl;
  final Aud.AudioPlayer musicPlayer;
  VideoPlayerController _controller;
  AddGratitude(this.position,this.videoUrl,this._controller,this.musicPlayer);

  @override
  AddGratitudeState createState() => AddGratitudeState();
}

class AddGratitudeState extends State<AddGratitude> {
  var postController = TextEditingController();
  final authBloc = Modular.get<AuthCubit>();
  //late VideoPlayerController _controller;
  bool videoLoading=true;
  bool musicPlaying=true;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);


  @override
  Widget build(BuildContext context) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom-40;
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: BlocBuilder(
                bloc: authBloc,
                builder: (context, state) {
                  return SingleChildScrollView(
                    child:  Stack(
                      children: [
                        BackgroundWidget(),
                        Column(
                          children: [

                            Stack(
                              children: [

                                Container(
                                  height: 230,
                                  margin: const EdgeInsets.only(top: 40),
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  videoLoading?

                                  VideoPlayer(widget._controller):
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
                                  ),

                                ),
                                GradientAppBar(
                                  onTap: () {
                                    if(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                                    {
                                      FocusManager.instance.primaryFocus?.unfocus();

                                    }
                                    else
                                    {
                                      Navigator.pop(context);
                                    }
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

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),

                                  Row(
                                    children: [
                                      Text(
                                        widget.position != 8888
                                            ? 'Update Gratitude'
                                            : AppStrings.todaysGratitude,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      Spacer(),

                                      InkWell(
                                        onTap: (){

                                          if(widget.musicPlayer.playing)
                                          {
                                            print('Music Stop');
                                            widget.musicPlayer.pause();
                                            setState(() {
                                             // musicPlaying=!musicPlaying;
                                            });
                                          }
                                          else
                                          {
                                            widget.musicPlayer.play();
                                           // musicPlaying=!musicPlaying;
                                            setState((){
                                            });
                                          }

                                        },
                                        child: Icon(widget.musicPlayer.playing?Icons.pause:Icons.play_arrow,size: 30,),
                                      ),
                                      const SizedBox(width: 5),
                                       Text(widget.musicPlayer.playing?'Stop Music':'Play Music')



                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Image.asset(
                                            'assets/gratitude_shadow.png'),
                                        //height: 400,
                                        /* decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:AssetImage(
                                            'assets/gratitude_shadow.png'
                                        )
                                    )
                                ),*/
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 55,
                                            bottom: 15),
                                        child: TextFormField(
                                          scrollPadding: EdgeInsets.only(bottom:bottomInsets + 40.0),
                                          maxLines: 5,
                                          maxLength: 500,
                                          /* onChanged: (value) {
                                               if(value.length>0)
                                                 {
                                                   widget.musicPlayer.pause();
                                                   widget._controller.pause();
                                                 }
                                               else
                                                 {
                                                   widget.musicPlayer.play();
                                                   widget._controller.play();
                                                 }
                                              },*/
                                          controller: postController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                BorderRadius.circular(15.0),
                                              ),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  color:
                                                  Colors.grey.withOpacity(0.5),
                                                  fontSize: 14,
                                                  fontFamily: 'Baumans'),
                                              hintText:
                                              'Add Today\'s Gratitude (Max 500 Words)',
                                              fillColor: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                      onTap: () {
                                        /*  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => GratitudeSuccess()));*/

                                        if (postController.text.isNotEmpty) {
                                          //click event
                                          _callAPI();
                                        }
                                      },
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                            height: 50,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppTheme.gradient2,
                                                  AppTheme.gradient1,
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                //stops: [0, 0, 0.47, 1],
                                              ),
                                            ),
                                            child: Center(
                                              child: authBloc.state.isLoading
                                                  ? const CircularProgressIndicator(
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(Colors.white),
                                              )
                                                  : Text(
                                                widget.position != 8888
                                                    ? 'Update'
                                                    : AppStrings.submit,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            )),
                                      )),

                                  const SizedBox(height: 25),
                                  /* SizedBox(
                                        height: MediaQuery.of(context).viewInsets.bottom,
                                      ),*/
                                ],
                              ),
                            ),


                           /* Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15),
                                      Text(
                                        widget.position != 8888
                                            ? 'Update Gratitude'
                                            : AppStrings.todaysGratitude,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 15),
                                      Stack(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Image.asset(
                                                'assets/gratitude_shadow.png'),
                                            //height: 400,
                                            *//* decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:AssetImage(
                                            'assets/gratitude_shadow.png'
                                        )
                                    )
                                ),*//*
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 55,
                                                bottom: 15),
                                            child: TextFormField(
                                              scrollPadding: EdgeInsets.only(bottom:bottomInsets + 40.0),
                                              maxLines: 5,
                                              maxLength: 500,
                                             *//* onChanged: (value) {
                                               if(value.length>0)
                                                 {
                                                   widget.musicPlayer.pause();
                                                   widget._controller.pause();
                                                 }
                                               else
                                                 {
                                                   widget.musicPlayer.play();
                                                   widget._controller.play();
                                                 }
                                              },*//*
                                              controller: postController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                    BorderRadius.circular(15.0),
                                                  ),
                                                  filled: true,
                                                  hintStyle: TextStyle(
                                                      color:
                                                      Colors.grey.withOpacity(0.5),
                                                      fontSize: 14,
                                                      fontFamily: 'Baumans'),
                                                  hintText:
                                                  'Add Today\'s Gratitude (Max 500 Words)',
                                                  fillColor: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      InkWell(
                                          onTap: () {
                                            *//*  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => GratitudeSuccess()));*//*

                                            if (postController.text.isNotEmpty) {
                                              //click event
                                              _callAPI();
                                            }
                                          },
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Container(
                                                height: 50,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      AppTheme.gradient2,
                                                      AppTheme.gradient1,
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    //stops: [0, 0, 0.47, 1],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: authBloc.state.isLoading
                                                      ? const CircularProgressIndicator(
                                                    valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                                  )
                                                      : Text(
                                                    widget.position != 8888
                                                        ? 'Update'
                                                        : AppStrings.submit,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          )),

                                      const SizedBox(height: 25),
                                     *//* SizedBox(
                                        height: MediaQuery.of(context).viewInsets.bottom,
                                      ),*//*
                                    ],
                                  ),
                                ),
                                musicPlaying? Text(musicPlaying?'Stop Music':'Play Music'):Container(),

                              ],
                            )*/
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ))),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    if(widget.position!=8888)
    {
      postController.text =
      authBloc.state.gratitudeList[widget.position].gratitude!;
    }
  }

  _callAPI() async {
    if (widget.position != 8888) {
      var requestModel = {
        'auth_key': AppModel.authKey,
        'gratitude': postController.text,
        'gratitude_id': authBloc.state.gratitudeList[widget.position].id,
      };
      authBloc.editGratitude(context, requestModel);
    } else {
      var requestModel = {
        'auth_key': AppModel.authKey,
        'gratitude': postController.text
      };
     bool apiStatus=await authBloc.addGratitude(context, requestModel);
     if(apiStatus)
       {
         Navigator.of(context).pushReplacement(MaterialPageRoute(
             builder: (BuildContext context) => GratitudeSuccess(widget.musicPlayer,widget._controller)));
       }
    }
  }
/* @override
  void dispose() {
    widget._controller.pause();
    widget._controller.dispose();
    super.dispose();
    widget._controller.pause();
   widget._controller.dispose();
  }*/
}