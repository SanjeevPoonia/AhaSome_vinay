import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/albums.dart';
import 'package:aha_project_files/view/friends_screen.dart';
import 'package:aha_project_files/view/gratitude_screens.dart';
import 'package:aha_project_files/view/shoutouts_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/app_modal.dart';
import '../models/friend_profile.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../network/bloc/dashboard_bloc.dart';
import '../network/bloc/friends_bloc.dart';
import '../network/bloc/profile_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../widgets/add_post_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/cover_image_widget.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/list_video_widget.dart';
import '../widgets/loader.dart';
import 'comments_screen.dart';
import 'edit_profile_screen.dart';
import 'full_video_screen.dart';
import 'image_display.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'likes_screen.dart';
import 'login_screen.dart';

class ProfileScreenNew extends StatefulWidget {
  const ProfileScreenNew({Key? key}) : super(key: key);

  @override
  ProfileNewState createState() => ProfileNewState();
}

class ProfileNewState extends State<ProfileScreenNew> {
  final authBloc = Modular.get<AuthCubit>();
  final friendsBloc = Modular.get<FriendsCubit>();
  File? _image;
  final dashboardBloc = Modular.get<DashboardCubit>();
  File? coverImage;

  int likedPosition = 9999;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
        child: Scaffold(
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
                                    .state.friendProfile[0].user_bg!
                                    .toString()),

                                GradientAppBar(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  iconButton: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_outlined,
                                        color: Colors.white),
                                    onSelected: handleClick,
                                    itemBuilder: (BuildContext context) {
                                      return {
                                       'Logout','Delete account'
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  showBackIc: true,
                                ),

                                GestureDetector(
                                  onTap: () {
                                    getCoverImage();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 40),
                                    height: 170,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 15, bottom: 25),
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Center(
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                              size: 25,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            Container(
                                /*  margin:
                              const EdgeInsets.only(top: 20),*/
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
                                    Center(
                                      child: Container(
                                        transform: Matrix4.translationValues(
                                            0.0, -50.0, 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: SizedBox(
                                                width: 115,
                                                height: 130,
                                                child: Stack(
                                                  children: [
                                                    BlocBuilder(
                                                        bloc: authBloc,
                                                        builder: (context, state) {
                                                          return Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors.white,
                                                              shape:
                                                                  BoxShape.circle,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius: 4,
                                                                    color: Colors
                                                                        .black,
                                                                    spreadRadius: 2)
                                                              ],
                                                            ),
                                                            child: GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageDisplay(image: authBloc
                                                                    .state
                                                                    .profileImage)));
                                                              },
                                                              child: CircleAvatar(
                                                                      radius: 60.0,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              authBloc
                                                                                  .state
                                                                                  .profileImage),
                                                                    ),
                                                            ),
                                                          );
                                                        }),
                                                    Align(
                                                        alignment:
                                                            Alignment.bottomCenter,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            getImage();
                                                          },
                                                          child: Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Color(
                                                                        0xFfDD2E44),
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: const Center(
                                                                child: Icon(
                                                              Icons.edit,
                                                              color: Colors.white,
                                                              size: 25,
                                                            )),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            BlocBuilder(
                                                bloc: authBloc,
                                                builder: (context, state) {
                                                  return Center(
                                                    child: Text(
                                                      '${authBloc.state.firstName} ${authBloc.state.lastName}',
                                                      style: const TextStyle(
                                                          color: Colors.brown,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  );
                                                }),
                                            const SizedBox(height: 12),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: ProfileCard(
                                                        'Album',
                                                        'assets/album_ic.png',
                                                        AppTheme.dashboardRed, () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AlbumScreen()));
                                                    }),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    flex: 1,
                                                    child: ProfileCard(
                                                        'Friends',
                                                        'assets/friends_ic.png',
                                                        AppTheme.dashboardYellow,
                                                        () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FriendsScreen(
                                                                      true)));
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: ProfileCard(
                                                        'ShoutOuts',
                                                        'assets/gra_ic.png',
                                                        AppTheme.dashboardTeal, () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ShoutOuts()));
                                                    }),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    flex: 1,
                                                    child: ProfileCard(
                                                        'Gratitude',
                                                        'assets/gra_ic.png',
                                                        AppTheme.dashboardGrey, () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GratitudeScreen()));
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            /* const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 32),
                                            child: Divider(
                                              thickness: 1.2,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
*/
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              child: Divider(
                                                thickness: 1,
                                                color: Colors.grey.withOpacity(0.4),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    'About',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () async {
                                                      final data=await Navigator
                                                        .push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    EditProfile()));
                                                     if(data!=null)
                                                   {
                                                     _callAPI();
                                                   }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 5, bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                              color:
                                                                  Color(0xFfF4900C),
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Image.asset(
                                                            'assets/edit_ic_about.png',
                                                            width: 18,
                                                            height: 18),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 20,right: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Hobbies : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Expanded(

                                                    child: Text(
                                                      friendsBloc.state
                                                          .friendProfile[0].hobbies!
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.blueGrey,
                                                          fontSize: 13),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 20),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Country : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
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
                                                  const EdgeInsets.only(left: 20),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Email : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    friendsBloc.state
                                                        .friendProfile[0].email!,
                                                    style: const TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 13),
                                                  ),
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
                                            const Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Text(
                                                'Post Something',
                                                style: TextStyle(
                                                    color: Color(0xff867983),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            const SizedBox(height: 18),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40, right: 20),
                                              child: Row(
                                                children: [
                                                  BlocBuilder(
                                                      bloc: authBloc,
                                                      builder: (context, state) {
                                                        return CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                              NetworkImage(authBloc
                                                                  .state
                                                                  .profileImage),
                                                        );
                                                      }),
                                                  const SizedBox(width: 17),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                         final closeStatus = await Navigator.of(context).push(
                                                           CupertinoPageRoute(
                                                            fullscreenDialog: true,
                                                            builder: (context) {
                                                              return AddPostWidget(
                                                                  'Home', null);
                                                            },
                                                          ),
                                                        );

                                                        if (closeStatus != null) {
                                                  _callAPI();
                                                }
                                                      },
                                                      child: TextFormField(
                                                          enabled: false,
                                                          style: const TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                            suffixIcon: const Icon(
                                                                Icons.photo,
                                                                size: 32),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                                style: BorderStyle
                                                                    .none,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.0),
                                                            ),
                                                            fillColor: AppTheme
                                                                .gradient1
                                                                .withOpacity(0.4),
                                                            filled: true,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20.0,
                                                                    12.0,
                                                                    0.0,
                                                                    12.0),
                                                            hintText:
                                                                'Post something',
                                                            labelStyle:
                                                                const TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Color(0XFF606060),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Text(
                                                'My Posts',
                                                style: TextStyle(
                                                    color: Color(0xff867983),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: friendsBloc
                                                    .state.friendPostList.length,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                scrollDirection: Axis.vertical,
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
                                                                  BlocBuilder(
                                                                      bloc:
                                                                          authBloc,
                                                                      builder:
                                                                          (context,
                                                                              state) {
                                                                        return CircleAvatar(
                                                                          radius:
                                                                              24.0,
                                                                          backgroundImage: NetworkImage(authBloc
                                                                              .state
                                                                              .profileImage),
                                                                        );
                                                                      }),
                                                                  const SizedBox(
                                                                      width: 10),
                                                                  Expanded(
                                                                      child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      BlocBuilder(
                                                                          bloc:
                                                                              authBloc,
                                                                          builder:
                                                                              (context,
                                                                                  state) {
                                                                            return Text(
                                                                              '${authBloc.state.firstName} ${authBloc.state.lastName}',
                                                                              style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 13),
                                                                            );
                                                                          }),
                                                                      const SizedBox(
                                                                          height:
                                                                              1),
                                                                      Text(
                                                                        _parseServerDate(friendsBloc
                                                                            .state
                                                                            .friendPostList[
                                                                                pos]
                                                                            .created_at!
                                                                            .toString()),
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                11),
                                                                      ),
                                                                    ],
                                                                  )),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDeleteDialog(context,
                                                                          friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                                  pos]
                                                                              .id!);
                                                                    },
                                                                    child: const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                ],
                                                              ),

                                                              friendsBloc
                                                                  .state
                                                                  .friendPostList[
                                                              pos]
                                                                  .body==null?
                                                                  Container():


                                                              const SizedBox(
                                                                  height: 7),

                                                              friendsBloc
                                                                  .state
                                                                  .friendPostList[
                                                              pos]
                                                                  .body==null?
                                                              Container():
                                                              SizedBox(
                                                                width:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                child:   ReadMoreText(
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


                                                            /*  friendsBloc.state.friendPostList[pos].image!=
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
                                                                            child:
                                                                            CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: friendsBloc.state.friendPostList[pos].image!,
                                                                              placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                              errorWidget: (context, url, error) => Container(),
                                                                            ),

                                                                            *//*  CachedVideoPreviewWidget(
                                                                                path: friendsBloc.state.friendPostList[pos].image!,
                                                                                type: SourceType.remote,
                                                                                remoteImageBuilder: (BuildContext context, url) =>

                                                                                    Image.network(url,fit: BoxFit.cover)


                                                                            ),*//*
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
                                                              ):*/





                                                              friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                                  pos]
                                                                              .image ==
                                                                          null &&
                                                                      friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                                  pos]
                                                                              .image_capture ==
                                                                          null &&
                                                                     /* friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                                  pos]
                                                                              .video_recording ==
                                                                          null &&*/
                                                                      friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                                  pos]
                                                                              .gif_id ==
                                                                          null
                                                                  ? Container()
                                                                /*  : friendsBloc
                                                                              .state
                                                                              .friendPostList[
                                                                                  pos]
                                                                              .video_recording !=
                                                                          null
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => FullVideoScreen(friendsBloc.state.friendPostList[pos].video_recording!)));
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


                                                              )*/

                                                                      /* VideoWidget(
                                                          iconSize: 70,
                                                          play: false,
                                                          loaderColor: Colors.white,
                                                          url: AppConstant.postImageURL+friendsBloc.state.friendPostList[pos].video_recording!,
                                                        ),
                                                      )*/
                                                                      : friendsBloc
                                                                                  .state
                                                                                  .friendPostList[
                                                                                      pos]
                                                                                  .image_capture !=
                                                                              null
                                                                          ? GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => ImageDisplay(image: friendsBloc.state.friendPostList[pos].capture_full!),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                  height: 180,
                                                                                  color: Colors.white,
                                                                                  width: double.infinity,
                                                                                  child: Image.network(
                                                                                    friendsBloc.state.friendPostList[pos].image_capture!,
                                                                                    width: double.infinity,
                                                                                    fit: BoxFit.cover,
                                                                                  )),
                                                                            )
                                                                          : friendsBloc.state.friendPostList[pos].gif_id !=
                                                                                  null
                                                                              ? GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => ImageDisplay(image: friendsBloc.state.friendPostList[pos].gif_id!),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  child: Center(
                                                                                    child: Container(
                                                                                        height: 180,
                                                                                        color: Colors.white,
                                                                                        child: Image.network(
                                                                                          friendsBloc.state.friendPostList[pos].gif_id!,
                                                                                          fit: BoxFit.cover,
                                                                                        )),
                                                                                  ),
                                                                                ):




                                                              friendsBloc
                                                                          .state
                                                                          .friendPostList[
                                                                              pos]
                                                                          .image !=
                                                                      null
                                                                  ? GestureDetector(
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
                                                                          width: double.infinity,
                                                                        /*  color: Colors.white,
                                                                          width: double.infinity,*/
                                                                          child:
                                                                          Stack(
                                                                            children: [

                                                                              Container(
                                                                                height: 180,
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
                                                     /*         friendsBloc
                                                                          .state
                                                                          .friendPostList[
                                                                              pos]
                                                                          .post_reply !=
                                                                      null
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top: 4,
                                                                          bottom:
                                                                              4),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.of(
                                                                                  context)
                                                                              .push(
                                                                            CupertinoPageRoute(
                                                                              fullscreenDialog:
                                                                                  true,
                                                                              builder:
                                                                                  (context) {
                                                                                return CommentsScreen(friendsBloc.state.friendPostList[pos].id!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Spacer(),
                                                                            Text(
                                                                              friendsBloc.state.friendPostList[pos].post_reply!.length == 0
                                                                                  ? 'No reactions'
                                                                                  : friendsBloc.state.friendPostList[pos].post_reply!.length.toString() + ' Reactions',
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top: 4,
                                                                          bottom:
                                                                              4),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.of(
                                                                                  context)
                                                                              .push(
                                                                            CupertinoPageRoute(
                                                                              fullscreenDialog:
                                                                                  true,
                                                                              builder:
                                                                                  (context) {
                                                                                return CommentsScreen(friendsBloc.state.friendPostList[pos].id!);
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            const Spacer(),
                                                                            Text(
                                                                              'No reactions',
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w500),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),*/


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
                                                                              .post_reply!.length!=0
                                                                              ?
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
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        children: [
                                                                          Container(
                                                                              child: isLikedPost(
                                                                                      pos)
                                                                                  ? Icon(Icons.thumb_up_sharp,
                                                                                      color: Colors.blue)
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
                                                                          SizedBox(
                                                                              width:
                                                                                  5),
                                                                          Text(
                                                                            friendsBloc.state.friendPostList[pos].post_likes!.length ==
                                                                                    0
                                                                                ? ''
                                                                                : friendsBloc
                                                                                    .state
                                                                                    .friendPostList[pos]
                                                                                    .post_likes!
                                                                                    .length
                                                                                    .toString(),
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontWeight:
                                                                                    FontWeight.w500),
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
                                                                      flex:1,
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          showCommentDialog(
                                                                              friendsBloc
                                                                                  .state
                                                                                  .friendPostList[pos]
                                                                                  .id!,
                                                                              pos);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                                  .only(
                                                                              right:
                                                                                  10),
                                                                          child: Image
                                                                              .asset(
                                                                            'assets/thums_up.gif',
                                                                            width: 35,
                                                                            height:
                                                                                35,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                    ),
                                  ],
                                )),
                          ],
                        );
                })),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      //Deactivate account
      case 'Logout':
        Utils.logoutUser(context);
        break;
      case 'Delete account':
        Utils.deactivateAccount(context);
        break;
    }
  }
  deleteAccount() async {
    APIDialog.showAlertDialog(context, 'Deleting account');
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('deleteAccount', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if (responseJson['status'] == 1) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    }
  }
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
        deleteAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account"),
      content: Text(
          "Are you sure you want to delete your account, your account will be deleted permanently ?"),
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
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      if(Platform.isIOS)
      {
        _image= await FlutterExifRotation.rotateImage(path: _image!.path);
      }
      _updateImage();
      setState(() {});
    }
  }

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      if(Platform.isIOS)
      {
        coverImage= await FlutterExifRotation.rotateImage(path: coverImage!.path);
      }
      _updateCoverImage();
      setState(() {});
    }
  }

  _callAPI() {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': authBloc.state.userId
    };
    friendsBloc.fetchFriendProfile(context, requestModel);
  }

  _updateImage() async {
    FormData requestModel = FormData.fromMap({
      'auth_key': AppModel.authKey,
      'avatar': await MultipartFile.fromFile(_image!.path),
    });
    authBloc.updateProfileImage(context, requestModel);
  }

  .
  _updateCoverImage() async {
    FormData requestModel = FormData.fromMap({
      'auth_key': AppModel.authKey,
      'user_bg': await MultipartFile.fromFile(coverImage!.path),
    });
    authBloc.updateCoverImage(context, requestModel);
  }

  @override
  void initState() {
    super.initState();
    _callAPI();
    //  _callAboutAPI();
  }

  _deletePost(int postId) async {
    APIDialog.showAlertDialog(context, 'Deleting Post');

    var requestModel = {'auth_key': AppModel.authKey, 'post_id': postId};
    bool status = await friendsBloc.deletePost(context, requestModel);
    if (status) {
      updatePostCount();
      _callAPI();
    }
  }
  updatePostCount() {
    int? currentCount = dashboardBloc.state.ahaByMe;
    currentCount = currentCount! - 1;
    dashboardBloc.updateAHAByMe(currentCount);
  }
  _refreshNewsFeeds(int pos, String type) async {
    if (type == 'Like') {
      List<FriendPost> list = friendsBloc.state.friendPostList;

      PostLikes model = PostLikes(1, authBloc.state.userId);

      list[pos].post_likes!.add(model);

      setState(() {
        friendsBloc.updatePostReactions(list);
      });
    } else {
      List<FriendPost> list = friendsBloc.state.friendPostList;

      PostReply model = PostReply(1, authBloc.state.userId);

      list[pos].post_reply!.add(model);
      print('new list');

      setState(() {
        friendsBloc.updatePostReactions(list);
      });
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
                    )),
              ),
            ],
          ),
        );
      },
    );
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
      _refreshNewsFeeds(pos, 'Reaction');
    }
  }

  bool isLikedPost(int pos) {
    bool likePost = false;
    if (friendsBloc.state.friendPostList[pos].post_likes != null) {
      List<dynamic> postLikes =
          friendsBloc.state.friendPostList[pos].post_likes!;

      for (int i = 0; i < postLikes.length; i++) {
        if (friendsBloc.state.friendPostList[pos].post_likes![i].liked_by_id ==
            authBloc.state.userId) {
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
      imageFormat: ImageFormat.WEBP,
      maxWidth: 128,
      quality: 15,
    );
    return uint8list!;
  }

  onLikeButtonTapped(int postID, int pos) async {
    var formData = {
      'auth_key': AppModel.authKey,
      'post_id': postID,
    };
    bool apiStatus = await dashboardBloc.likePost(context, formData);
    if (apiStatus) {
      _refreshNewsFeeds(pos, 'Like');
    }
  }


  static String _parseServerDate(String date) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
  }
  showDeleteDialog(BuildContext context,int postId) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
       _deletePost(postId);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete post ?"),
      content: Text("Are you sure you want to delete this post ?"),
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
}
