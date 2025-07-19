import 'dart:io';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/view/chat_listing_screen.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/group_detail_screen.dart';
import 'package:aha_project_files/view/hunt_aha_buddy_screen.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../models/all_friends_model.dart';
import '../network/bloc/dashboard_bloc.dart';
import '../network/bloc/profile_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/rounded_image_widget.dart';
import '../widgets/small_loader.dart';
import 'map_screen.dart';

class FriendsScreen extends StatefulWidget {
  bool showMainTab;

  FriendsScreen(this.showMainTab);

  @override
  FriendState createState() => FriendState();
}

class FriendState extends State<FriendsScreen> {
  final friendsBloc = Modular.get<FriendsCubit>();
  String header = '';
  bool noDataFound=false;
  bool tabbedButton = true;
  int selectedIndexRequest = 999;
  bool showCheckbox=false;
  List<Friends> friendSearchList = [];
  final dashboardBloc = Modular.get<DashboardCubit>();
  var searchController = TextEditingController();
  List<String>? blockList;
  List<int> friendsID = [];
  final groupBloc = Modular.get<ProfileCubit>();
  File? _image;
  final picker = ImagePicker();
  var groupNameController = TextEditingController();
  var groupDescController = TextEditingController();
// /flutter.compileSdkVersion
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MapSample()));
              },
              backgroundColor: AppTheme.gradient1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/googlemap_ic.png'),
              ),
            ),
            body: BlocBuilder(
                bloc: friendsBloc,
                builder: (context, state) {
                  return Stack(
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
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        if (!widget.showMainTab) {
                                          _executeAPI();
                                          setState(() {
                                            widget.showMainTab = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xFFF0582E)),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 5),
                                            Image.asset('assets/thums_up.gif',
                                                width: 30, height: 35),
                                            const SizedBox(width: 3),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4),
                                                child: Text(
                                                    'Happily Following (' +
                                                        friendsBloc
                                                            .state.friendsCount
                                                            .toString() +
                                                        ')',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11)),
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                          ],
                                        ),
                                      ),
                                    )),
                                const SizedBox(width: 10),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.showMainTab) {
                                          _executeAPIPendingRequests();

                                          setState(() {
                                            widget.showMainTab = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xFF41C0B7)),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 7),
                                            Image.asset(
                                                'assets/pending_requests.gif',
                                                width: 30,
                                                height: 35),
                                            const SizedBox(width: 3),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4),
                                                child: Text(
                  friendsBloc.state
                      .pendingRequestsCount==0?
                  'Pending Requests':

                                                  'Pending Requests (' +
                                                      friendsBloc.state
                                                          .pendingRequestsCount
                                                          .toString() +
                                                      ')',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          widget.showMainTab
                              ? Container(
                                  height: 50,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: TextFormField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        _runFilter(value);
                                      },
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIcon: const Icon(
                                          Icons.search,
                                          color: AppTheme.gradient4,
                                          size: 30,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 0.5,
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        contentPadding: const EdgeInsets.fromLTRB(
                                            20.0, 12.0, 0.0, 12.0),
                                        hintText: 'Search friends',
                                        labelStyle: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                      )),
                                )
                              : Container(),
                          widget.showMainTab
                              ? const SizedBox(height: 10)
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.showMainTab
                                    ? Text(
                                  /*friendSearchList.length != 0 || searchController.text.isNotEmpty?
                              'Friends(${friendSearchList.length})':
                                    'Friends(${friendsBloc.state.friendList.length})'*/
                                  'Friends',
                                  style: const TextStyle(
                                      color: Color(0xFfDD2E44),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                )
                                    : GestureDetector(
                                   onTap: () async{



                              /* locationFromAddress('Uttar Pradesh').then((value) {
                                 print(value.length.toString());
                                 print('LAT LONG');
                                 print(value[0].longitude);
                                 print(value[0].latitude);

                               }).catchError((err) => print("not able to be reached"+err.toString()));*/

                                   },
                                      child: Text(
                                  friendsBloc.state.requestList.length==0?
                                        'Pending Requests':
                                  'Pending Requests(${friendsBloc.state.requestList.length})',
                                  style: const TextStyle(
                                        color: Color(0xFfDD2E44),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                ),
                                    ),


                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      showCheckbox=true;
                                    });
                                  },
                                  child:

                                  widget.showMainTab?

                                  Text(
                                    'Create group',
                                    style: const TextStyle(
                                        color:
                                        Color(0xFfDD2E44),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ):Container()
                                )

                              ],
                            )
                          ),
                          const SizedBox(height: 12),
                          widget.showMainTab
                              ? Expanded(
                                  child: friendsBloc.state.isLoading
                                      ? Loader()
                                       :noDataFound?

                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text('No friends found'),
                    SizedBox(height: 10),
                    Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 35,
                    child: ElevatedButton(
                    style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(
                    Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(
                    AppTheme.navigationRed)),
                    onPressed: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HuntAHABuddy()));
                    },
                    child:  Text(

                    'Add friends',
                    style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600))),
                    ),
                    ],
                    ),
                  )


                                      : friendSearchList.length != 0 ||
                                              searchController.text.isNotEmpty
                                          ?
                                          //search list
                                          ListView.builder(
                                              itemCount: friendSearchList.length,
                                              itemBuilder: (BuildContext context,
                                                  int pos) {
                                                return blockList!.contains(
                                                        friendSearchList[pos]
                                                            .id!
                                                            .toString())
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              FriendProfile(
                                                                                friendSearchList[pos].id!,
                                                                              )));
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                //color: Color(0xFFFFC3CA),
                                                                color: AppTheme
                                                                    .gradient3
                                                                    .withOpacity(
                                                                        0.4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      bottom: 10,
                                                                      left: 8,
                                                                      right: 8),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  RoundedImageWidget(
                                                                      friendSearchList[pos]
                                                                          .avatar!
                                                                  ),


                                                                  /* CircleAvatar(
                                                                    radius: 25.0,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            friendSearchList[pos]
                                                                                .avatar!),
                                                                  ),*/
                                                                  const SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              '${friendSearchList[pos].first_name} ${friendSearchList[pos].last_name}',
                                                                              style: const TextStyle(
                                                                                  color: AppTheme.textColor,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 13),
                                                                            ),
                                                                            Spacer(),


                                                                            showCheckbox?

                                                                            friendsID.contains(friendSearchList[pos].id)
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      friendsID.remove(friendSearchList[pos].id);
                                                                                      print(friendsID.toString());
                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: const Icon(Icons.check_box, size: 20, color: AppTheme.navigationRed),
                                                                                    ))
                                                                                : InkWell(
                                                                                    onTap: () {
                                                                                      friendsID.add(friendSearchList[pos].id!);
                                                                                      print(friendsID.toString());
                                                                                      setState(() {});
                                                                                    },
                                                                                    child:  Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Icon(Icons.check_box_outline_blank_sharp, size: 20),
                                                                                    )):Container()
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              150,
                                                                          child:
                                                                              Text(
                                                                            friendSearchList[pos]
                                                                                .hobbies
                                                                                .toString(),
                                                                            style: const TextStyle(
                                                                                color: AppTheme.textColor,
                                                                                fontSize: 10),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Spacer(),
                                                                              const Text(
                                                                                'Since ',
                                                                                style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, fontSize: 11),
                                                                              ),
                                                                              SizedBox(
                                                                                child: Text(
                                                                                  _parseServerDate(friendSearchList[pos].created_at!),
                                                                                  style: const TextStyle(color: Color(0xFFDD3648), fontWeight: FontWeight.w500, fontSize: 11),
                                                                                  textAlign: TextAlign.end,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      );
                                              })
                                          :

                                          // normal List

                                          ListView.builder(
                                              itemCount: friendsBloc
                                                  .state.friendList.length,
                                              itemBuilder: (BuildContext context,
                                                  int pos) {
                                                return blockList!.contains(
                                                        friendsBloc.state
                                                            .friendList[pos].id!
                                                            .toString())
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              FriendProfile(
                                                                                friendsBloc.state.friendList[pos].id!,
                                                                              )));
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                //color: Color(0xFFFFC3CA),
                                                                color: AppTheme
                                                                    .gradient3
                                                                    .withOpacity(
                                                                        0.4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10,
                                                                      bottom: 10,
                                                                      left: 8,
                                                                      right: 8),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  RoundedImageWidget(
                                                                      friendsBloc
                                                                          .state
                                                                          .friendList[
                                                                      pos]
                                                                          .avatar!
                                                                  ),



                                                                  /*  CircleAvatar(
                                                                    radius: 25.0,
                                                                    backgroundImage:
                                                                        NetworkImage(friendsBloc
                                                                            .state
                                                                            .friendList[
                                                                                pos]
                                                                            .avatar!),
                                                                  ),*/
                                                                  const SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              '${friendsBloc.state.friendList[pos].first_name} ${friendsBloc.state.friendList[pos].last_name}',
                                                                              style: const TextStyle(
                                                                                  color: AppTheme.textColor,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 13),
                                                                            ),
                                                                            Spacer(),

                                                                            showCheckbox?
                                                                            friendsID.contains(friendsBloc.state.friendList[pos].id)
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      friendsID.remove(friendsBloc.state.friendList[pos].id);
                                                                                      print(friendsID.toString());
                                                                                      if(friendsID.length==0)
                                                                                      {
                                                                                        showCheckbox=false;
                                                                                      }
                                                                                      setState(() {});
                                                                                    },
                                                                                    child:  Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Icon(Icons.check_box, size: 20, color: AppTheme.navigationRed),
                                                                                    ))
                                                                                : InkWell(
                                                                                    onTap: () {
                                                                                      friendsID.add(friendsBloc.state.friendList[pos].id!);
                                                                                      print(friendsID.toString());


                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Icon(Icons.check_box_outline_blank_sharp, size: 20),
                                                                                    )):Container(),
                                                                            const SizedBox(
                                                                                width: 10)
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              150,
                                                                          child:
                                                                              Text(
                                                                            friendsBloc
                                                                                .state
                                                                                .friendList[pos]
                                                                                .hobbies
                                                                                .toString(),
                                                                            style: const TextStyle(
                                                                                color: AppTheme.textColor,
                                                                                fontSize: 10),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Spacer(),
                                                                              const Text(
                                                                                'Since ',
                                                                                style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, fontSize: 11),
                                                                              ),
                                                                              SizedBox(
                                                                                child: Text(
                                                                                  _parseServerDate(friendsBloc.state.friendList[pos].created_at!),
                                                                                  style: const TextStyle(color: Color(0xFFDD3648), fontWeight: FontWeight.w500, fontSize: 11),
                                                                                  textAlign: TextAlign.end,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                        ],
                                                      );
                                              }),
                                )
                              : Expanded(
                                  child: friendsBloc.state.isLoading
                                      ? Loader()
                                      : ListView.builder(
                                          itemCount: friendsBloc
                                              .state.requestList.length,
                                          itemBuilder:
                                              (BuildContext context, int pos) {
                                            return Column(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FriendProfile(
                                                                      friendsBloc
                                                                          .state
                                                                          .requestList[
                                                                              pos]
                                                                          .id!)));
                                                    },
                                                    child: Card(
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
                                                                  RoundedImageWidget(
                                                                      friendsBloc
                                                                          .state
                                                                          .requestList[
                                                                      pos]
                                                                          .avatar!
                                                                  ),




                                                                 /* CircleAvatar(
                                                                    radius: 25.0,
                                                                    backgroundImage:
                                                                        NetworkImage(friendsBloc
                                                                            .state
                                                                            .requestList[
                                                                                pos]
                                                                            .avatar!),
                                                                  ),*/
                                                                  const SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          '${friendsBloc.state.requestList[pos].first_name} ${friendsBloc.state.requestList[pos].last_name}',
                                                                          style: const TextStyle(
                                                                              color:
                                                                                  AppTheme.textColor,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 13),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                3),
                                                                        Text(
                                                                          friendsBloc
                                                                              .state
                                                                              .requestList[pos]
                                                                              .country!,
                                                                          style: const TextStyle(
                                                                              color:
                                                                                  AppTheme.textColor,
                                                                              fontSize: 11),
                                                                          maxLines:
                                                                              4,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                6),
                                                                        Row(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                selectedIndexRequest = pos;
                                                                                tabbedButton = true;
                                                                                _acceptRequest(friendsBloc.state.requestList[pos].id!);
                                                                              },
                                                                              child: Container(
                                                                                  height: 32,
                                                                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color(0xFFF0582E)),
                                                                                  child: Center(
                                                                                    child: friendsBloc.state.isRequestLoading && tabbedButton && selectedIndexRequest == pos
                                                                                        ? SmallLoader(Colors.white)
                                                                                        : const Text(
                                                                                            'Confirm',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                                                                                          ),
                                                                                  )),
                                                                            ),
                                                                            const SizedBox(
                                                                                width: 10),
                                                                            InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                selectedIndexRequest = pos;
                                                                                tabbedButton = false;
                                                                                _deleteRequest(friendsBloc.state.requestList[pos].id!);
                                                                              },
                                                                              child: Container(
                                                                                  height: 36,
                                                                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color(0xFFECEDF1)),
                                                                                  child: Center(
                                                                                    child: friendsBloc.state.isRequestLoading && tabbedButton == false && selectedIndexRequest == pos
                                                                                        ? SmallLoader(Colors.black)
                                                                                        : const Text(
                                                                                            'Not Now',
                                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
                                                                                          ),
                                                                                  )),
                                                                            )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                    )),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            );
                                          })),
                          widget.showMainTab && friendsID.length != 0
                              ? Center(
                                  child: InkWell(
                                  onTap: () {
                                    groupNameController.text = '';
                                    groupDescController.text = '';
                                    _image = null;
                                    addGroupDialog(context);
                                  },
                                  child: Container(
                                    height: 48,
                                    width: 100,
                                    margin: EdgeInsets.only(bottom: 5,top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFF0582E)),
                                    child: Center(
                                      child: Text('Proceed',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13)),
                                    ),
                                  ),
                                ))
                              : Container()
                        ],
                      ),

                      /*  Row(
                        children: [
                          const Spacer(),
                          Padding(
                              padding:
                                  const EdgeInsets.only(right: 11, bottom: 10),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatListScreen()));
                                    },
                                    child: Image.asset('assets/message_ic.png',
                                        width: 50, height: 50),
                                  )))
                        ],
                      )*/
                    ],
                  );
                })),
      ),
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
    fetchBlockValues();
    if (widget.showMainTab) {
      _executeAPI();
    } else {
      _executeAPIPendingRequests();
    }
  }

  _executeAPI() async {
    var formData = {'auth_key': AppModel.authKey};
   noDataFound=await friendsBloc.fetchAllFriends(context, formData);
   if(noDataFound==false)
     {
       setState(() {

       });
     }
  }

  _executeAPIPendingRequests() {
    var formData = {'auth_key': AppModel.authKey};
    friendsBloc.fetchPendingRequests(context, formData);
  }

  String _parseServerDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.yMMM();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }

  _acceptRequest(int friendId) async {
    var requestModel = {'auth_key': AppModel.authKey, 'friend_id': friendId};
    bool apiStatus =
        await friendsBloc.acceptFriendRequest(context, requestModel);
    if (apiStatus) {
      updateFriendCount();
      _executeAPIPendingRequests();
    }
  }

  updateFriendCount() {
    int? currentCount = dashboardBloc.state.friendsCount;
    currentCount = currentCount! + 1;
    dashboardBloc.updateFriendsCount(currentCount);
  }

  _deleteRequest(int friendId) async {
    var requestModel = {'auth_key': AppModel.authKey, 'friend_id': friendId};
    bool apiStatus =
        await friendsBloc.deleteFriendRequest(context, requestModel);
    if (apiStatus) {
      _executeAPIPendingRequests();
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Friends> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = friendsBloc.state.friendList;
    } else {
      results = friendsBloc.state.friendList
          .where((friend) =>
              friend.first_name!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              friend.hobbies
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase())

                  ||
                      friend.last_name!
                          .toString()
                          .toLowerCase()
                          .contains(enteredKeyword.toLowerCase())

      )
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      friendSearchList = results;
    });
  }

  fetchBlockValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    blockList = prefs.getStringList('blockusers');
    if (blockList == null) {
      blockList = [];
    }
    print('Combine search');
    setState(() {});
    print('Fetching Block Data');
    print(blockList);
  }

  void addGroupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), //this right here
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Create Group',
                                style: TextStyle(
                                    color: Color(0XFF606060),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.file(
                                      _image!,
                                      width: 100,
                                      height: 80,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      bool status = await getImage();
                                      if (status) {
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppTheme.gradient4
                                              .withOpacity(0.4)),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Group avatar',
                              style: TextStyle(
                                  color: Color(0XFF606060), fontSize: 17),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            child: TextField(
                              controller: groupNameController,
                              textInputAction: TextInputAction.go,
                              onTap: () {},
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                hintText: 'Group Name',
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              maxLines: 2,
                              controller: groupDescController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5),
                                      fontSize: 14,
                                      fontFamily: 'Baumans'),
                                  hintText: 'Description/About',
                                  fillColor: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: 35,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppTheme.navigationRed)),
                                onPressed: () {
                                  if (groupNameController.text.isNotEmpty &&
                                      groupDescController.text.isNotEmpty) {
                                    _createGroup();
                                    Navigator.pop(context);
                                  } else {
                                    Toast.show(
                                        'Description/Group name cannot be left empty',
                                        duration: Toast.lengthShort,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.blue);
                                  }
                                },
                                child: const Text("Create",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      if(Platform.isIOS)
      {
        _image= await FlutterExifRotation.rotateImage(path: _image!.path);
      }
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  _createGroup() async {
    var requestModel;
    if (_image == null) {
      requestModel = FormData.fromMap({
        'group_name': groupNameController.text,
        'group_about': groupDescController.text,
        'auth_key': AppModel.authKey,
      });
    } else {
      requestModel = FormData.fromMap({
        'group_name': groupNameController.text,
        'group_about': groupDescController.text,
        'auth_key': AppModel.authKey,
        'group_avatar': await MultipartFile.fromFile(_image!.path),
      });
    }
    bool apiStatus = await groupBloc.createGroupFriends(context, requestModel);
    if (apiStatus) {
      _inviteUser();
    }
  }

  _inviteUser() async {
    APIDialog.showAlertDialog(context, 'Sending invites...');
    /*  if(friendsID.isNotEmpty)
    {
      friendsID.clear();
    }*/

    var formData = {
      'auth_key': AppModel.authKey,
      'group_id': AppModel.groupId,
      'friend_id': friendsID
    };
    bool apiStatus = await groupBloc.inviteFriend(context, formData);
    if (apiStatus) {
      Navigator.pop(context);
      friendsID.clear();
      showCheckbox=false;

      Toast.show('Invitations sent successfully !',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      setState(() {});
    }
  }
}
