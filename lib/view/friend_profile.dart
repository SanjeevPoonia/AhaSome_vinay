import 'dart:io';
import 'dart:typed_data';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/chat_screen.dart';
import 'package:aha_project_files/view/report_screen.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/rounded_image_widget.dart';
import 'package:aha_project_files/widgets/small_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/friend_profile.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/cover_image_widget.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/list_video_widget.dart';
import 'comments_screen.dart';
import 'full_video_screen.dart';
import 'image_display.dart';
import 'likes_screen.dart';

class FriendProfile extends StatefulWidget {
  final int friendId;

  FriendProfile(this.friendId);

  @override
  FriendProfileState createState() => FriendProfileState();
}

class FriendProfileState extends State<FriendProfile> {
  final friendsBloc = Modular.get<FriendsCubit>();
  final authBloc = Modular.get<AuthCubit>();
  int likedPosition = 9999;
  String postText = '';
  bool dataUpdated = false;
  List<dynamic> list = [];
  List<dynamic> listTime = [];
  final dashboardBloc = Modular.get<DashboardCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: BlocBuilder(
            bloc: friendsBloc,
            builder: (context,state)
            {
              return Scaffold(
                  backgroundColor: Colors.white,
                  floatingActionButton:

                  friendsBloc.state.isLoading?
                  Container():

                  friendsBloc.state.isFriend=='Friend'?
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatScreen(friendsBloc.state.friendProfile[0]
                              .id!,friendsBloc.state.friendProfile[0]
                              .first_name!+' '+friendsBloc.state.friendProfile[0].last_name!, friendsBloc.state.friendProfile[0]
                              .avatar!)));
                    },
                    backgroundColor:AppTheme.gradient2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.chat,color: Colors.white),
                    ),
                  ):Container(),
                  body: BlocBuilder(
                    bloc: friendsBloc,
                    builder: (context, state) {
                      return friendsBloc.state.isLoading
                          ? Loader()
                          : ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Stack(
                            children: [

                              CoverImageWidget(friendsBloc
                                  .state.friendProfile[0].user_bg
                                  .toString()),


                              /*  Container(
                                  height: 165,
                                  margin: const EdgeInsets.only(top: 45),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: CachedNetworkImageProvider(
                                              friendsBloc
                                                  .state.friendProfile[0].user_bg
                                                  .toString()),
                                    ),
                                  ),
                                ),*/
                              GradientAppBar(
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
                            ],
                          ),
                          Container(
                              transform:
                              Matrix4.translationValues(0.0, -20.0, 0.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(22),
                                  topRight: Radius.circular(22),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                      MediaQuery.of(context).size.height,
                                      padding: const EdgeInsets.only(top: 20),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                'assets/background.png')),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(22),
                                          topRight: Radius.circular(22),
                                        ),
                                      ),
                                      child: BackgroundWidget()),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -40.0, 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 4,
                                                      color: Colors.black,
                                                      spreadRadius: 2)
                                                ],
                                              ),
                                              child:
                                              RoundedImage(friendsBloc
                                                  .state
                                                  .friendProfile[0]
                                                  .avatar!,60)



                                            /*CircleAvatar(
                                                radius: 60.0,
                                                backgroundImage: NetworkImage(

                                                        friendsBloc
                                                            .state
                                                            .friendProfile[0]
                                                            .avatar!),
                                              ),*/
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: Text(
                                            '${friendsBloc.state.friendProfile[0].first_name} ${friendsBloc.state.friendProfile[0].last_name}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            friendsBloc.state.friendProfile[0]
                                                .country!,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            friendsBloc.state.isFriend ==
                                                'Not friend'
                                                ? InkWell(
                                              onTap: () {
                                                _followUser();
                                              },
                                              child: SizedBox(
                                                  height: 42,
                                                  child: Card(
                                                    elevation: 6,
                                                    shadowColor:
                                                    Colors.black,
                                                    margin:
                                                    EdgeInsets.zero,
                                                    color: AppTheme
                                                        .gradient2,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          // SizedBox(width: 15),
                                                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),

                                                            child: Text(
                                                              'Happy to connect',
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 12),
                                                            ),


                                                          ),

                                                          const SizedBox(
                                                              width: 10)
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            )
                                                : friendsBloc.state.isFriend ==
                                                'Pending'
                                                ?
                                            SizedBox(
                                                height: 42,
                                                child: Card(
                                                  elevation: 6,
                                                  shadowColor:
                                                  Colors.black,
                                                  margin:
                                                  EdgeInsets.zero,
                                                  color: AppTheme
                                                      .dashboardGrey,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        vertical:
                                                        10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Text(
                                                            'Requested',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10)
                                                      ],
                                                    ),
                                                  ),
                                                )):
                                            friendsBloc.state.isFriend=='Confirm'?

                                            InkWell(
                                              onTap: () {
                                                _acceptRequest(friendsBloc.state.friendProfile[0].id!);
                                              },
                                              child: SizedBox(
                                                  height: 42,
                                                  child: Card(
                                                    elevation: 6,
                                                    shadowColor:
                                                    Colors.black,
                                                    margin: EdgeInsets
                                                        .zero,
                                                    color: Colors.green,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text(
                                                              'Confirm',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ):

                                            friendsBloc.state.isFriend=='Friend'?


                                            // Friends
                                            InkWell(
                                              onTap: () {
                                                showLogUnfollowDialog(context);
                                              },
                                              child: SizedBox(
                                                  height: 42,
                                                  child: Card(
                                                    elevation: 6,
                                                    shadowColor:
                                                    Colors.black,
                                                    margin: EdgeInsets
                                                        .zero,
                                                    color: AppTheme
                                                        .gradient1,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: Text(
                                                              'Unfollow',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 13),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ):Container(),
                                            SizedBox(width: 12),
                                            Container(
                                              height: 45,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFc5c5c5),
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child:
                                              friendsBloc.state.isFriend=='Friend'?

                                              PopupMenuButton<String>(
                                                icon: Icon(Icons.more_horiz,
                                                    color: Colors.black,
                                                    size: 20),
                                                onSelected: handleClickReport,
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return {
                                                    'Report user',
                                                    'Block'
                                                  }.map((String choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(
                                                        choice,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ):



                                              PopupMenuButton<String>(
                                                icon: Icon(Icons.more_horiz,
                                                    color: Colors.black,
                                                    size: 20),
                                                onSelected: handleClickReport,
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return {
                                                    'Report user',
                                                    'Block'
                                                  }.map((String choice) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: choice,
                                                      child: Text(
                                                        choice,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Text(
                                            'About',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 12,right: 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Hobbies : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    friendsBloc.state
                                                        .friendProfile[0].hobbies
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 13),
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.visible,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 12),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Country : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              Text(
                                                friendsBloc.state
                                                    .friendProfile[0].country!,
                                                style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 12),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Email : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  friendsBloc.state
                                                      .friendProfile[0].email!,
                                                  style: const TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 13),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),

                                              SizedBox(width: 10)
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.grey.withOpacity(0.4),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 12),
                                          child: Text(
                                            friendsBloc.state.friendPostList
                                                .length !=
                                                0
                                                ? 'Posts'
                                                : 'No Posts found',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(height: 13),
                                        ListView.builder(
                                            itemCount: friendsBloc
                                                .state.friendPostList.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            scrollDirection: Axis.vertical,
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int pos) {
                                              return Column(
                                                children: [
                                                  Card(
                                                    elevation: 8,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    color: pos % 2 == 0
                                                        ? AppTheme.gradient4
                                                        : AppTheme.gradient1,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10)),
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 7),
                                                      // height: 300,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 7),
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 24.0,
                                                                backgroundImage: NetworkImage(
                                                                    friendsBloc
                                                                        .state
                                                                        .friendProfile[
                                                                    0]
                                                                        .avatar!),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                        '${friendsBloc.state.friendProfile[0].first_name} ${friendsBloc.state.friendProfile[0].last_name}',
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            fontSize:
                                                                            13),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                          1),
                                                                      Text(
                                                                        _parseServerDate(friendsBloc
                                                                            .state
                                                                            .friendPostList[
                                                                        pos]
                                                                            .created_at!),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                            10),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              PopupMenuButton<
                                                                  String>(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .more_horiz,
                                                                    color: Colors
                                                                        .white),
                                                                onSelected: (String
                                                                value) =>
                                                                    handleClickReport2(
                                                                        value,friendsBloc
                                                                        .state
                                                                        .friendPostList[
                                                                    pos].id!),
                                                                itemBuilder:
                                                                    (BuildContext
                                                                context) {
                                                                  return {
                                                                    'Report post'
                                                                  }.map((String
                                                                  choice) {
                                                                    return PopupMenuItem<
                                                                        String>(
                                                                      value:
                                                                      choice,
                                                                      child:
                                                                      Text(
                                                                        choice,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            15),
                                                                      ),
                                                                    );
                                                                  }).toList();
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                          friendsBloc
                                                              .state
                                                              .friendPostList[
                                                          pos]
                                                              .body==null ||  friendsBloc
                                                              .state
                                                              .friendPostList[
                                                          pos]
                                                              .body==""?
                                                          Container():
                                                          const SizedBox(
                                                              height: 7),

                                                          friendsBloc
                                                              .state
                                                              .friendPostList[
                                                          pos]
                                                              .body==null ||  friendsBloc
                                                              .state
                                                              .friendPostList[
                                                          pos]
                                                              .body==""?
                                                          Container():

                                                          SizedBox(
                                                              width:
                                                              MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              child:

                                                              ReadMoreText(
                                                                friendsBloc
                                                                    .state
                                                                    .friendPostList[
                                                                pos]
                                                                    .body!,
                                                                trimLines:
                                                                2,
                                                                style: const TextStyle(
                                                                    color:
                                                                    Colors.white,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14),
                                                                colorClickableText:
                                                                Colors.limeAccent,
                                                                trimMode:
                                                                TrimMode.Line,
                                                                trimCollapsedText:
                                                                'Show more',
                                                                trimExpandedText:
                                                                '   Show less',
                                                                moreStyle: TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors.white),

                                                                lessStyle: TextStyle(
                                                                    fontSize:
                                                                    12,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    color: Colors.limeAccent),

                                                              )




                                                          ),
                                                          const SizedBox(
                                                              height: 10),

                                                          /* friendsBloc.state.friendPostList[pos].image!=
                                                                null &&
                                                                friendsBloc.state.friendPostList[pos].image!
                                                                    .toString()
                                                                    .contains(
                                                                    '.mp4')
                                                                ? GestureDetector(
                                                                onTap:
                                                                    () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => FullVideoScreen(friendsBloc.state.friendPostList[pos].image!)));
                                                                },
                                                                child:

                                                                // dont use
                                                                Container(
                                                                    height: 180,
                                                                    width: double.infinity,
                                                                    child:Stack(
                                                                      children: [
                                                                        Center(
                                                                          child: CachedVideoPreviewWidget(
                                                                              path: friendsBloc.state.friendPostList[pos].image!,
                                                                              type: SourceType.remote,
                                                                              remoteImageBuilder: (BuildContext context, url) =>

                                                                                  Image.network(url,fit: BoxFit.cover)


                                                                          ),
                                                                        ),

                                                                        Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40))


                                                                      ],
                                                                    )
                                                                )

                                                              *//* VideoWidget(
                                                                          iconSize:
                                                                              70,
                                                                          play:
                                                                              false,
                                                                          url:
                                                                              newsFeedList[pos]['image'],
                                                                          loaderColor:
                                                                              Colors.white,
                                                                        ),*//*
                                                            ):
*/

                                                          friendsBloc.state.friendPostList[pos].image ==
                                                              null && friendsBloc.state.friendPostList[pos].image_capture ==
                                                              null  /*&&  friendsBloc.state.friendPostList[pos].video_recording==
                                                                null*/ && friendsBloc.state.friendPostList[pos].gif_id==
                                                              null
                                                              ?
                                                          Container():








/*
                                                            friendsBloc.state.friendPostList[pos].video_recording
                                                                !=null?

                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>FullVideoScreen(friendsBloc.state.friendPostList[pos].video_recording!)));
                                                              },
                                                              child:
                                                              Container(
                                                                  height: 180,
                                                                  width: double.infinity,
                                                                  child:Stack(
                                                                    children: [
                                                                      Center(
                                                                        child: CachedVideoPreviewWidget(
                                                                            path: friendsBloc.state.friendPostList[pos].video_recording!,
                                                                            type: SourceType.remote,
                                                                            remoteImageBuilder: (BuildContext context, url) =>

                                                                                Image.network(url,fit: BoxFit.cover)


                                                                        ),
                                                                      ),

                                                                      Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40))


                                                                    ],
                                                                  )
                                                              )


                                                              *//*VideoWidget(
                                                                iconSize: 70,
                                                                play: false,
                                                                loaderColor: Colors.white,
                                                                url: friendsBloc.state.friendPostList[pos].video_recording!,
                                                              ),*//*
                                                            ):*/
                                                          friendsBloc.state.friendPostList[pos].image_capture!=null?
                                                          GestureDetector(
                                                            onTap: (){
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ImageDisplay(
                                                                      image:
                                                                      friendsBloc.state.friendPostList[pos].capture_full!
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 180,
                                                              color:
                                                              Colors.white,
                                                              width: double
                                                                  .infinity,
                                                              child:

                                                              CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,

                                                                imageUrl:
                                                                friendsBloc.state.friendPostList[pos].image_capture!,
                                                                placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                errorWidget: (context, url, error) => Container(),
                                                              ),


                                                            ),
                                                          ):


                                                          friendsBloc.state.friendPostList[pos].gif_id !=
                                                              null?



                                                          GestureDetector(
                                                            onTap:
                                                                () {
                                                              Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ImageDisplay(image:friendsBloc.state.friendPostList[pos].gif_id!),
                                                                ),
                                                              );
                                                            },
                                                            child: Center(
                                                              child: Container(
                                                                height: 180,
                                                                color: Colors.white,
                                                                child:


                                                                CachedNetworkImage(
                                                                  fit: BoxFit.cover,
                                                                  imageUrl: friendsBloc.state.friendPostList[pos].gif_id!,
                                                                  placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                  errorWidget: (context, url, error) => Container(),
                                                                ),
                                                                /*    Image.network(
                                                                      cacheHeight:150,
                                                                      cacheWidth:200,
                                                                    friendsBloc.state.friendPostList[pos].gif_id!,
                                                                      fit: BoxFit.cover,
                                                                    )*/),
                                                            ),
                                                          ):

                                                          friendsBloc.state.friendPostList[pos].image !=
                                                              null?

                                                          GestureDetector(
                                                            onTap: () {

                                                              if(friendsBloc.state.friendPostList[pos].video_capture_full!=null && friendsBloc.state.friendPostList[pos].video_capture_full!="")
                                                              {
                                                                // a video

                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => FullVideoScreen(friendsBloc.state.friendPostList[pos].video_capture_full!,friendsBloc.state.friendPostList[pos].image!),
                                                                  ),
                                                                );
                                                              }
                                                              else
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => ImageDisplay(image: friendsBloc.state.friendPostList[pos].image_full!),
                                                                  ),
                                                                );
                                                              }





/*
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder:
                                                                              (context) =>
                                                                                  ImageDisplay(image: friendsBloc.state.friendPostList[pos].image_full!),
                                                                        ),
                                                                      );*/
                                                            },
                                                            child: Container(
                                                                height: 180,
                                                                //color: Colors.white,
                                                                width: double.infinity,
                                                                child:
                                                                Stack(
                                                                  children: [

                                                                    Container(
                                                                      height: 180,
                                                                      //color: Colors.white,
                                                                      width: double.infinity,
                                                                      child: CachedNetworkImage(
                                                                        fit: BoxFit.cover,
                                                                        imageUrl:  friendsBloc
                                                                            .state
                                                                            .friendPostList[pos]
                                                                            .image!,
                                                                        placeholder: (context, url) =>Image.asset('assets/thumb2.jpeg'),
                                                                        errorWidget: (context, url, error) => Container(),
                                                                      ),
                                                                    ),

                                                                    friendsBloc
                                                                        .state
                                                                        .friendPostList[pos]
                                                                        .video_capture_full!=null &&  friendsBloc
                                                                        .state
                                                                        .friendPostList[pos]
                                                                        .video_capture_full!=''?
                                                                    Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40)):Container()


                                                                  ],
                                                                )





                                                              /*CachedNetworkImage(
                                                                          fit: BoxFit.cover,
                                                                          imageUrl:  friendsBloc
                                                                              .state
                                                                              .friendPostList[pos]
                                                                              .image!,
                                                                          placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                          errorWidget: (context, url, error) => Container(),
                                                                        ),

*/


                                                            ),
                                                          )
                                                              : Container(),


                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                top:
                                                                4,
                                                                bottom:
                                                                4),
                                                            child:
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [

                                                                GestureDetector(
                                                                    onTap:(){
                                                                      Navigator.of(context)
                                                                          .push(
                                                                        CupertinoPageRoute(
                                                                          fullscreenDialog: true,
                                                                          builder: (context) {
                                                                            return LikesScreen(friendsBloc.state.friendPostList[pos].id!);
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                    child:
                                                                    friendsBloc
                                                                        .state
                                                                        .friendPostList[
                                                                    pos]
                                                                        .post_likes!.length!=0?
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 5),
                                                                      child: Text(
                                                                        'View likes',
                                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 12),
                                                                      ),
                                                                    ):Container()
                                                                ),



                                                                GestureDetector(
                                                                  onTap: (){
                                                                    Navigator.of(context)
                                                                        .push(
                                                                      CupertinoPageRoute(
                                                                        fullscreenDialog: true,
                                                                        builder: (context) {
                                                                          return CommentsScreen( friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                          pos]
                                                                              .id!);
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    friendsBloc
                                                                        .state
                                                                        .friendPostList[
                                                                    pos]
                                                                        .post_reply!.length!=0?
                                                                    friendsBloc
                                                                        .state
                                                                        .friendPostList[
                                                                    pos]
                                                                        .post_reply!.length.toString() + ' Reactions':'No reactions',
                                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                            height: 0.4,
                                                            color: Colors.white,
                                                          ),

                                                          SizedBox(
                                                            height: 55,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [

                                                                Expanded(
                                                                  flex:1,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                          child: isLikedPost(pos)
                                                                              ? Icon(Icons.thumb_up_sharp, color: Colors.blue)
                                                                              : GestureDetector(
                                                                            onTap: () {
                                                                              likedPosition = pos;
                                                                              setState(() {});

                                                                              onLikeButtonTapped(friendsBloc.state.friendPostList[pos].id!, pos);
                                                                            },
                                                                            child: Icon(Icons.thumb_up_sharp, color: likedPosition == pos ? Colors.blue : AppTheme.gradient3),
                                                                          )

                                                                        /*Image.asset(
                                                                        'assets/emoji_like.gif',
                                                                        width: 35,
                                                                        height: 35,
                                                                      ),*/
                                                                      ),
                                                                      SizedBox(width: 5),
                                                                      Text(
                                                                        friendsBloc.state.friendPostList[pos].post_likes!.length == 0 ? '' : friendsBloc.state.friendPostList[pos].post_likes!.length.toString(),
                                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),

                                                                Container(
                                                                    width: 0.5,
                                                                    height: 55,
                                                                    color: Colors
                                                                        .white),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      showCommentDialog( friendsBloc
                                                                          .state
                                                                          .friendPostList[
                                                                      pos].id!,
                                                                          pos);
                                                                    },
                                                                    child: Image.asset(
                                                                      'assets/thums_up.gif',
                                                                      width: 35,
                                                                      height: 35,
                                                                    ),
                                                                  ),
                                                                ),
                                                                /* Icon(Icons.share,
                                                        color: Colors.white),*/
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      );
                    },
                  ));
            }
            ,
          )),
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
    _callAPI();
  //  fetchBlockValues();
  }

  _callAPI() {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': widget.friendId
    };
    friendsBloc.fetchFriendProfile(context, requestModel);
  }

  _removeFriend() async {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': widget.friendId
    };
    bool apiStatus = await friendsBloc.removeFriend(context, requestModel);
    if (apiStatus) {
      _callAPI();
    }
  }

  _followUser() async {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': widget.friendId
    };
    bool apiStatus = await friendsBloc.addFriend(context, requestModel);
    if (apiStatus) {
      _callAPI();
    }
  }

  Future<void> handleClickReport(String value) async {
    switch (value) {
      case 'Report user':
        AppModel.setReportedId(widget.friendId);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ReportScreen('user',false)));
        break;
      case 'Block':
        _blockUser();
        break;
    }
  }

  Future<void> handleClickReport2(String value,int postID) async {
    switch (value) {
      case 'Report post':
        AppModel.setReportedId(postID);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ReportScreen('post',true)));
        break;
    }
  }

  _blockUser() {
    APIDialog.showAlertDialog(context, 'Blocking user...');

    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var blockList = prefs.getStringList('blockusers');

      if (blockList == null) {
        List<String> blockListNew = [];
        blockListNew.add(friendsBloc.state.friendProfile[0].id.toString());
        prefs.setStringList('blockusers', blockListNew);
      } else {
        blockList.add(friendsBloc.state.friendProfile[0].id.toString());
        prefs.setStringList('blockusers', blockList);
      }
      Navigator.pop(context);
      Navigator.pop(context, 'Refresh');
      Toast.show('User Blocked successfully',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    });
    print('*** Blocked Successfully***');
  }
  onLikeButtonTapped(int postID, int pos) async {
    var formData = {
      'auth_key': AppModel.authKey,
      'post_id': postID,
    };
    bool apiStatus = await dashboardBloc.likePost(context, formData);
    if (apiStatus) {
      _refreshNewsFeeds(pos,'Like');
    }
  }
  fetchBlockValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blockList = prefs.getStringList('blockusers');
    print('Fetching Block Data');
    print(blockList);
  }
  _onEmojiSelected(Emoji emoji, int postId, int pos) {
    Navigator.pop(context);
    addReaction(postId, emoji.emoji, pos);
  }
  addReaction(int postId, String name, int pos) async {
    var requestModel = {
      'post_id': postId,
      'auth_key': AppModel.authKey,
      'emoji': name
    };

    bool apiStatus = await dashboardBloc.addComment(context, requestModel);
    if (apiStatus) {
      _refreshNewsFeeds(pos,'Reaction');
    }
  }

  void showCommentDialog(int postId, int pos) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 250,
                          child: EmojiPicker(
                              onEmojiSelected:
                                  (Category? category, Emoji emoji) {
                                _onEmojiSelected(emoji, postId, pos);
                              },
                              config: Config(
                                  columns: 7,
                                  // Issue: https://github.com/flutter/flutter/issues/28894
                                  emojiSizeMax:
                                  32 * (Platform.isIOS ? 1.30 : 1.0),
                                  verticalSpacing: 0,
                                  horizontalSpacing: 0,
                                  gridPadding: EdgeInsets.zero,
                                  initCategory: Category.RECENT,
                                  bgColor: Colors.white,
                                  indicatorColor: Colors.blue,
                                  iconColor: Colors.grey,
                                  iconColorSelected: Colors.blue,
                                  backspaceColor: Colors.blue,
                                  skinToneDialogBgColor: Colors.white,
                                  skinToneIndicatorColor: Colors.grey,
                                  enableSkinTones: true,
                                  showRecentsTab: false,
                                  recentsLimit: 28,
                                  replaceEmojiOnLimitExceed: false,
                                  noRecents: const Text(
                                    'No Recents',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black26),
                                    textAlign: TextAlign.center,
                                  ),
                                  tabIndicatorAnimDuration: kTabScrollDuration,
                                  categoryIcons: const CategoryIcons(),
                                  buttonMode: ButtonMode.MATERIAL)),
                        ),
                        Container(
                          color: Colors.white,
                          height: 50,
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select emojis',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close),
                              )
                            ],
                          ),
                        )
                      ],
                    )

                  /* ListView.builder(
                        itemCount: smileyList.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int pos) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                //  addReaction(postId,smileyList[pos]['emoji_name']);
                                  //Navigator.pop(context);

                                },
                                child: Image.network(AppConstant.gifImageURL +
                                    smileyList[pos]['emoji_name'])),
                          );
                        })*/
                ),
              ),
            ],
          ),
        );
      },

/*      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },*/
    );
  }
  bool isLikedPost(int pos) {
    bool likePost = false;
    if (friendsBloc.state.friendPostList[pos].post_likes!.length != 0) {
      List<PostLikes> postLikes = friendsBloc.state.friendPostList[pos].post_likes!;

      for (int i = 0; i < postLikes.length; i++) {
        if (postLikes[i].liked_by_id == authBloc.state.userId) {
          likePost = true;
          break;
        } else {
          likePost = false;
        }
      }
    }
    return likePost;
  }
  Future<Uint8List> returnThumbnail(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,//maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return uint8list!;
  }

  _refreshNewsFeeds(int pos,String type) async {

    if(type=='Like')
    {

      List<FriendPost> list=friendsBloc.state.friendPostList;

      PostLikes model=PostLikes(1,authBloc.state.userId);



      list[pos].post_likes!.add(
          model);



      setState(() {
        friendsBloc.updatePostReactions(list);
      });


    }

    else
    {
      List<FriendPost> list=friendsBloc.state.friendPostList;

      PostReply model=PostReply(1,authBloc.state.userId);

      list[pos].post_reply!.add(
          model
      );
      print('new list');

      setState(() {
        friendsBloc.updatePostReactions(list);
      });

    }


  }

  showLogUnfollowDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Unfollow",
        style: TextStyle(color: AppTheme.gradient1),
      ),
      onPressed: () {
        Navigator.pop(context);
        _removeFriend();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Unfollow ?"),
      content: Text("Are you sure you want to unfollow ${friendsBloc.state.friendProfile[0].first_name} ${friendsBloc.state.friendProfile[0].last_name}' ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _acceptRequest(int friendId) async {
    APIDialog.showAlertDialog(context, 'Accepting request...');
    var requestModel = {'auth_key': AppModel.authKey, 'friend_id': friendId};
    bool apiStatus =
    await friendsBloc.acceptFriendRequest(context, requestModel);
    if (apiStatus) {
      Navigator.pop(context);
     _callAPI();
    }
  }
  String _parseServerDate(String date) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
  }
}
