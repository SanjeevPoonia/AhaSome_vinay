import 'dart:convert';
import 'dart:io';

import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/bloc/profile_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/group_detail_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/rounded_image_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';

class GroupInvites extends StatefulWidget {
  GroupState createState() => GroupState();
}

class GroupState extends State<GroupInvites> {
  final groupBloc = Modular.get<ProfileCubit>();
  final authBloc = Modular.get<AuthCubit>();
  final dashboardBloc = Modular.get<DashboardCubit>();
  List<dynamic> inviteList=[];
  bool isLoading=false;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  BackgroundWidget(),
                  Column(
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
                      const SizedBox(height: 20),



                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: (){
                            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>))
                          },
                          child: Text(
                            'Group Invites',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                Colors.blueGrey,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                          child:isLoading
                              ? Loader():
                            inviteList.length==0?
                                Center(
                                  child: Text('No invitations found'),
                                ):


                              ListView.builder(
                              itemCount: inviteList.length,
                              itemBuilder:
                                  (BuildContext context, int pos) {
                                return Column(
                                  children: [
                                    Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            15),
                                      ),
                                      margin: const EdgeInsets
                                          .symmetric(
                                          horizontal: 15),
                                      child: Container(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              top: 10,
                                              bottom: 10,
                                              left: 8,
                                              right: 8),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  const SizedBox(
                                                      width: 5),
                                                 /* CircleAvatar(
                                                    radius: 35.0,
                                                    backgroundImage: NetworkImage(
                                                       inviteList[pos]['group_avatar']),
                                                  ),*/

                                                  RoundedImage(inviteList[pos]['group_avatar'], 65),
                                                  const SizedBox(
                                                      width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        inviteList[pos]['group_name'],
                                                        style: const TextStyle(
                                                            color: AppTheme
                                                                .textColor,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            fontSize:
                                                            14.5),
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(
                                                          height:
                                                          3),

                                                      const SizedBox(
                                                          height:
                                                          10),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              _acceptRequests(inviteList[pos]['id']);
                                                            },
                                                            child: Container(
                                                                width: 100,
                                                                height: 42,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFF0582E)),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Confirm',
                                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13.5),
                                                                  ),
                                                                )),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                              10),
                                                          InkWell(
                                                            onTap:
                                                                () {

                                                              _deleteRequests(inviteList[pos]['id']);
                                                            },
                                                            child: Container(
                                                                width: 100,
                                                                height: 42,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFFECEDF1)),
                                                                child: Center(
                                                                  child: const Text(
                                                                    'Not Now',
                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13.5),
                                                                  ),
                                                                )),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              }))
                    ],
                  )
                ],
              ))),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
    }
  }


  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  fetchRequests() async {
    setState(() {
      isLoading=true;
    });
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('allGroupInvitation', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    isLoading=false;
    inviteList = responseJson['group_info'];
    setState(() {});
  }

  _acceptRequests(int groupId) async {
    APIDialog.showAlertDialog(context, 'Accepting invitation...');
    var formData = {'auth_key': AppModel.authKey,'group_id':groupId};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('acceptGroupInvitation', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
        if(responseJson['status']==1)
          {
            updateGroupCount();
            Navigator.pop(context,'Refresh Data');
            Toast.show(responseJson['message'],
                duration: Toast.lengthShort,
                gravity: Toast.bottom,
                backgroundColor: Colors.green);
          }
  }

  _deleteRequests(int groupId) async {
    APIDialog.showAlertDialog(context, 'Rejecting invitation...');
    var formData = {'auth_key': AppModel.authKey,'group_id':groupId};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('rejectGroupInvitation', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if(responseJson['status']==1)
    {
      Navigator.pop(context,'Refresh Data');
      Toast.show(responseJson['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    }
  }
  updateGroupCount(){
    int? currentCount=dashboardBloc.state.groupCount;
    currentCount=currentCount!+1;
    dashboardBloc.updateGroupsCount(currentCount);
  }
}
