

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import 'package:just_audio/just_audio.dart';

class NotificationAudio extends StatefulWidget
{
  AudioState createState()=>AudioState();
}
class AudioState extends State<NotificationAudio>
{
  final player = AudioPlayer();
  String checkRingtone='';
  List<Ringtone> ringtones = [];
  int selectedIndex=9999;
  @override
  Widget build(BuildContext context) {
   return SafeArea(child: Scaffold(
     body: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
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
         const SizedBox(height: 15),
         const Padding(
           padding: EdgeInsets.only(left: 10),
           child:
           Text(
             'Change notification ringtone',
             style: TextStyle(
                 color: Color(0xFfDD2E44),
                 fontWeight: FontWeight.w600,
                 fontSize: 16),
           ),

         ),
         const SizedBox(height: 10),


         Expanded(child: ListView.builder(
           padding: EdgeInsets.zero,
           itemCount: ringtones.length,
           itemBuilder: (BuildContext context, int index) {
             return

               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Row(
                       children: [

                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               ringtones[index].title,
                               style: const TextStyle(
                                   fontWeight:
                                   FontWeight.w500,
                                   fontSize: 16,
                                   color:
                                   Colors.black),
                             ),
                             SizedBox(height: 5),

                             checkRingtone==ringtones[index].uri?

                             GestureDetector(
                               onTap: (){
                               //  setNotificationRingtone(ringtones[index].uri);
                               },
                               child: Text(
                                 'Selected',
                                 style: TextStyle(
                                     fontWeight:
                                     FontWeight.w600,
                                     fontSize: 16.5,
                                     color:
                                     Colors.green),
                               ),
                             ):

                             GestureDetector(
                               onTap: (){
                                 setNotificationRingtone(ringtones[index].uri);
                               },
                               child: Text(
                                 'Select',
                                 style: TextStyle(
                                     fontWeight:
                                     FontWeight.w600,
                                     fontSize: 16.5,
                                     color:
                                     AppTheme.gradient1),
                               ),
                             )
                           ],
                         ),




                         Spacer(),

                         Center(
                           child: InkWell(
                             onTap: (){
                               initPlayer(ringtones[index].uri,index);
                             },
                             child: Container(
                            //   margin: EdgeInsets.only(top: 10),
                               width: 33,
                               height: 33,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.grey
                               ),

                               child: Icon(selectedIndex==index?Icons.pause:Icons.play_arrow,color: Colors.white),

                             ),
                           ),
                         )



                       ],
                     ),
                   ),


                 Divider()


                 ],
               );



           },
         ),)

       ],
     ),



   ));
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
    checkSelectedRingtone();
    getRingtones();
  }
  Future<void> getRingtones() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final temp = await FlutterSystemRingtones.getNotificationSounds();
      setState(() {
        ringtones = temp;
      });
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }

    if (!mounted) return;
  }
  initPlayer(String uri,int index) async {

    setState(() {
      selectedIndex=index;
    });
    final duration = await player.setUrl(           // Load a URL
        uri);
    player.play();

    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        selectedIndex=9999;
      });
    });







  }

  setNotificationRingtone(String uri) async {

    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString('notify', uri);
    checkSelectedRingtone();

  }

  checkSelectedRingtone() async
  {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    checkRingtone=prefs.getString('notify')!;

    if(checkRingtone==null)
      {
        checkRingtone='';
      }


    Toast.show('Notification sound changed successfully',
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.green);

    setState(() {

    });
  }
}