import 'dart:convert';

import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/profile_new_sceen.dart';
import 'package:aha_project_files/view/report_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../models/app_modal.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/loader.dart';

class LikesScreen extends StatefulWidget {
 final int postId;

 LikesScreen(this.postId);

  @override
  LikesState createState() => LikesState();
}

class LikesState extends State<LikesScreen> {
  final authBloc = Modular.get<AuthCubit>();
  List<dynamic> commentsList=[];
  bool isLoading=false;
  List<String>? blockList;
  bool noDataFound=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body:   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarNew(
                    onTap: () {
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
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Liked by',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child:
                    isLoading?Loader():

                    noDataFound?

                    const Center(
                      child:Text(
                        'No comments found',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ):
                    ListView.builder(
                        itemCount: commentsList.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 15),
                                         InkWell(
                                           onTap:(){
                                             if(commentsList[pos]['user']['id']==authBloc.state.userId)
                                               {
                                                  Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    const ProfileScreenNew()));
                                               }
                                             else
                                               {
                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfile(commentsList[pos]['user']['id'])));
                                               }
                                           },
                                           child: Container(
                                             width: 50,
                                             height: 50,
                                             child: Stack(
                                               children: [
                                                 CircleAvatar(
                                                   radius: 22.0,
                                                   backgroundImage: NetworkImage(
                                                       commentsList[pos]['user']['avatar'].toString()),
                                                 ),


                                                 Align(
                                                   alignment: Alignment.bottomRight,
                                                     child: Container(
                                                       width: 35,
                                                       height: 35,
                                                       child: Stack(
                                                         children:  [

                                                           Align(
                                                             alignment: Alignment.topRight,
                                                             child: Container(
                                                               margin: EdgeInsets.only(top: 10),
                                                             /*  transform: Matrix4.translationValues(
                                                                   0.0, -2.0, 0.0),*/
                                                               width:
                                                               25,
                                                               height:
                                                               17,
                                                               decoration:
                                                               BoxDecoration(color: Colors.blue,
                                                                 shape:BoxShape.circle,
                                                                   border: Border.all(color: Colors.white,width: 1)

                                                               ),
                                                               child:
                                                               Center(
                                                                   child:

                                                                   Icon(Icons.thumb_up_alt_sharp,color: Colors.white,size: 9)
                                                               ),
                                                             ),
                                                           )




                                                         ],
                                                       ),
                                                     ),
                                                 )

                                               ],
                                             ),
                                           ),
                                         ),
                                        const SizedBox(width: 10),
                                        Expanded(child:   GestureDetector(
                                          onTap:(){

                                            if(commentsList[pos]['user']['id']==authBloc.state.userId)
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const ProfileScreenNew()));
                                            }
                                            else
                                            {
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfile(commentsList[pos]['user']['id'])));
                                            }





                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Text(
                                              commentsList[pos]['user']['first_name']+' '+commentsList[pos]['user']['last_name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                              maxLines: 1,
                                            ),
                                          ),
                                        )),

                                        const SizedBox(width: 10),
                                      ],
                                    ),

                                    /*  Row(
                                                children: [
                                                  Spacer(),

                                                  SizedBox(
                                                    width:20,
                                                    height:20,
                                                    //margin: EdgeInsets.only(bottom: 5),
                                                    child: PopupMenuButton<String>(
                                                      icon: Icon(
                                                          Icons.more_vert,
                                                          color: Colors.black),
                                                      onSelected: handleClickReport,
                                                      itemBuilder: (BuildContext context) {
                                                        return {'Report post','Report user'}.map((String choice) {
                                                          return PopupMenuItem<String>(
                                                            value: choice,
                                                            child: Text(choice,style: TextStyle(
                                                                fontSize: 15
                                                            ),),
                                                          );
                                                        }).toList();
                                                      },
                                                    ),
                                                  ),

                                                  SizedBox(width: 15),







                                                ],
                                              ),*/

                                  ],
                                ),

                                const SizedBox(height: 15),
                              ],
                            );
                        }),
                  )
                ],
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
  fetchComments() async {
    setState(() {
      isLoading = true;
    });
    var formData = {'auth_key': AppModel.authKey,'post_id':widget.postId};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('viewLikes', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    commentsList=responseJson['data'];
    if(commentsList.length==0)
      {
        noDataFound=true;
      }
    isLoading = false;
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
   // fetchBlockValues();
    fetchComments();
  }
  String _parseServerDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.yMMMMd();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }
  void actionPopUpItemSelected(String value,int id) async {
    switch (value) {

      case 'Report user':
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen('user',false)));
        break;
      case 'Hide':
        _hidePost(id);
        break;
      case 'Block this user':
        _blockUser(id);
        break;


    }
  }
  _hidePost(int id)  async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var blockList = prefs.getStringList('blockusers');

    if(blockList==null)
    {
      List<String> blockListNew=[];
      blockListNew.add(id.toString());
      prefs.setStringList('blockusers', blockListNew);
    }
    else
    {
      blockList.add(id.toString());
      prefs.setStringList('blockusers', blockList);
    }
    fetchBlockValues();
  }
  fetchBlockValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    blockList = prefs.getStringList('blockusers');
    if(blockList==null)
    {
      blockList=[];
    }
    setState(() {
    });
    print('Fetching Block Data');
    print(blockList);
  }
  _blockUser(int id)  {
    APIDialog.showAlertDialog(context,'Blocking user...');

    Future.delayed(const Duration(seconds: 2), () async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var blockList = prefs.getStringList('blockusers');

      if(blockList==null)
      {
        List<String> blockListNew=[];
        blockListNew.add(id.toString());
        prefs.setStringList('blockusers', blockListNew);
      }
      else
      {
        blockList.add(id.toString());
        prefs.setStringList('blockusers', blockList);
      }
      Navigator.pop(context);
      fetchBlockValues();
      Toast.show('User Blocked successfully',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    });
    print('*** Blocked Successfully***');
  }



}
