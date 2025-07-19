import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/profile_new_sceen.dart';
import 'package:aha_project_files/view/report_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../network/bloc/dashboard_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../widgets/add_post_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/list_video_widget.dart';
import '../widgets/loader.dart';
import '../widgets/rounded_image_widget.dart';
import 'comments_screen.dart';
import 'full_video_screen.dart';
import 'image_display.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'likes_screen.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPostScreen> {
  TextEditingController textController = TextEditingController();
  String? selectedPostType;
  final dashboardBloc = Modular.get<DashboardCubit>();
  int likedPosition=9999;
  bool isPagLoading = false;
  final authBloc = Modular.get<AuthCubit>();
  final friendsBloc = Modular.get<FriendsCubit>();
  List<dynamic> newsFeedList = [];
  bool isLoading = true;
  List<String>? blockList;
  int _page = 1;
  bool loadMoreData=true;
  late ScrollController _scrollController;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
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
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Post Something',
                      style:
                      TextStyle(color: Color(0xFf867983), fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder(
                            bloc: authBloc,
                            builder: (context, state) {
                              return CircleAvatar(
                                radius: 26.0,
                                backgroundImage:
                                NetworkImage(authBloc.state.profileImage),
                              );
                            }),
                        const SizedBox(width: 10),
                        Expanded(
                            child: InkWell(
                              onTap: () async {
                                final closeStatus =
                                await Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return AddPostWidget('Home',null);
                                    },
                                  ),
                                );

                                if (closeStatus != null) {
                                fetchPosts();
                                }
                              },
                              child: TextFormField(
                                  enabled: false,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(Icons.photo, size: 32),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    fillColor:
                                    AppTheme.gradient1.withOpacity(0.4),
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 12.0, 0.0, 12.0),
                                    hintText: 'Type Something Here',
                                    labelStyle: const TextStyle(
                                      fontSize: 15.0,
                                      color: Color(0XFF606060),
                                    ),
                                  )),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                      child: isLoading
                          ? Loader()
                          :
                      ListView.builder(
                          itemCount: newsFeedList.length,
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder:
                              (BuildContext context, int pos) {
                            int userId = newsFeedList[pos]
                            ['userpost'][0]['id'];
                            // print(newsFeedList[pos]['image']);
                            return blockList!.contains(
                                newsFeedList[pos]['userpost'][0]
                                ['id']
                                    .toString())
                                ? Container()
                                : Column(
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
                                            GestureDetector(
                                              onTap:(){
                                                if (newsFeedList[pos]['userpost'][0]['id'] ==
                                                    authBloc.state.userId) {
                                                  // My Profile
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                          const ProfileScreenNew()));
                                                } else {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => FriendProfile(newsFeedList[pos]['userpost'][0]['id'])));
                                                }

                                              },
                                              child: RoundedImageWidget(
                                                  newsFeedList[pos]
                                                  [
                                                  'userpost'][0]
                                                  [
                                                  'avatar']),
                                            ),
                                            const SizedBox(
                                                width: 10),
                                            Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap:
                                                          () {
                                                        if (newsFeedList[pos]['userpost'][0]['id'] ==
                                                            authBloc.state.userId) {
                                                          // My Profile
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (context) => ProfileScreenNew()));
                                                        } else {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (context) => FriendProfile(newsFeedList[pos]['userpost'][0]['id'])));
                                                        }
                                                      },
                                                      child:
                                                      Text(
                                                        newsFeedList[pos]['userpost'][0]['first_name'] +
                                                            ' ' +
                                                            newsFeedList[pos]['userpost'][0]['last_name'],
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                        1),
                                                    Text(
                                                      _parseServerDate(newsFeedList[pos]
                                                      [
                                                      'created_at']
                                                          .toString()),
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          11),
                                                    ),
                                                  ],
                                                )),

                                            newsFeedList[pos]['userpost'][0]['id']==authBloc.state.userId?
                                            PopupMenuButton<
                                                String>(
                                              icon: const Icon(
                                                  Icons
                                                      .more_horiz,
                                                  color: Colors
                                                      .white),
                                              onSelected: (String
                                              value) =>
                                                  actionPopUpItemSelected(
                                                      value,
                                                      userId,newsFeedList[pos]['id']),
                                              itemBuilder:
                                                  (BuildContext
                                              context) {
                                                return {
                                                  'View Reactions'
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
                                            ):

                                            PopupMenuButton<
                                                String>(
                                              icon: const Icon(
                                                  Icons
                                                      .more_horiz,
                                                  color: Colors
                                                      .white),
                                              onSelected: (String
                                              value) =>
                                                  actionPopUpItemSelected(
                                                      value,
                                                      userId,newsFeedList[pos]['id']),
                                              itemBuilder:
                                                  (BuildContext
                                              context) {
                                                return {
                                                  'Report post',
                                                  'Hide',

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
                                            ),
                                          ],
                                        ),





                                        newsFeedList[
                                        pos]
                                        [
                                        'body']==null || newsFeedList[
                                        pos]
                                        [
                                        'body']=="" ?

                                        Container():


                                        const SizedBox(
                                            height: 7),
                                        newsFeedList[
                                        pos]
                                        [
                                        'body']==null || newsFeedList[
                                        pos]
                                        [
                                        'body']=="" ?Container():
                                        SizedBox(
                                            width: MediaQuery.of(
                                                context)
                                                .size
                                                .width,
                                            child:
                                            ReadMoreText(
                                              newsFeedList[pos]
                                              [
                                              'body'],
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

                                          /*Text(
                                                                newsFeedList[pos]
                                                                    ['body'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: 14),
                                                              ),*/
                                        ),
                                        newsFeedList[
                                        pos]
                                        [
                                        'body']==null || newsFeedList[
                                        pos]
                                        [
                                        'body']==""?  Container( height: 10):    const SizedBox(
                                            height: 10),
                                        /*   newsFeedList[pos][
                                                                                'image'] !=
                                                                            null &&
                                                                        newsFeedList[pos]
                                                                                [
                                                                                'image']
                                                                            .toString()
                                                                            .contains(
                                                                                '.mp4')
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => FullVideoScreen(newsFeedList[pos]['image'])));
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
                                                                                    imageUrl: newsFeedList[pos]['image'],
                                                                                    placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                                    errorWidget: (context, url, error) => Container(),
                                                                                  ),


                                                                              *//*    CachedVideoPreviewWidget(
                                                                                      path: newsFeedList[pos]['image'],
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
                                                                        )
                                                                    : */newsFeedList[pos]['image'] == null &&
                                            newsFeedList[pos]['image_capture'] ==
                                                null &&
                                            /* newsFeedList[pos]['video_recording'] ==
                                                                                null &&*/
                                            newsFeedList[pos]['gif_id'] ==
                                                null
                                            ? Container()
                                            :
                                        //video player logic
                                        /*  newsFeedList[pos]['video_recording'] !=
                                                                                null
                                                                            ? GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullVideoScreen(newsFeedList[pos]['video_recording'])));
                                                                                },
                                                                                child:

                                                                                Container(
                                                                                    height: 180,
                                                                                    width: double.infinity,
                                                                                    child:Stack(
                                                                                      children: [
                                                                                        Center(
                                                                                          child:



                                                                                          CachedVideoPreviewWidget(
                                                                                              path: newsFeedList[pos]['video_recording'],
                                                                                              type: SourceType.remote,
                                                                                              remoteImageBuilder: (BuildContext context, url) =>

                                                                                                  Image.network(url,fit: BoxFit.cover)


                                                                                          ),
                                                                                        ),

                                                                                        Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40))


                                                                                      ],
                                                                                    )
                                                                                )





                                                                                *//*  VideoWidget(
                                                                                  iconSize: 70,
                                                                                  play: false,
                                                                                  url:  newsFeedList[pos]['video_recording'],
                                                                                  loaderColor: Colors.white,
                                                                                ),*//*
                                                                                )
                                                                            : */newsFeedList[pos]['image_capture'] != null
                                            ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageDisplay(image: newsFeedList[pos]['capture_full']),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 180,
                                            color: Colors.white,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: newsFeedList[pos]['image_capture'],
                                              placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                              errorWidget: (context, url, error) => Container(),
                                            ),
                                          ),
                                        )
                                            :
                                        //Gif
                                        newsFeedList[pos]['gif_id'] != null
                                            ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageDisplay(image: newsFeedList[pos]['gif_id']),
                                              ),
                                            );
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 180,
                                              color: Colors.white,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: newsFeedList[pos]['gif_id'],
                                                placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                errorWidget: (context, url, error) => Container(),
                                              ),
                                            ),
                                          ),
                                        )
                                            : newsFeedList[pos]['image'] != null
                                            ? GestureDetector(
                                          onTap: () {


                                            if(newsFeedList[pos]['video_capture_full']!=null && newsFeedList[pos]['video_capture_full']!='')
                                            {
                                              // a video

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FullVideoScreen(newsFeedList[pos]['video_capture_full'],newsFeedList[pos]['image']),
                                                ),
                                              );
                                            }
                                            else
                                            {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ImageDisplay(image: newsFeedList[pos]['image_full']),
                                                ),
                                              );
                                            }







                                          },
                                          child: Container(
                                              height: 180,
                                              //color: Colors.white,
                                                width: double.infinity,
                                              child: Stack(
                                                children: [

                                                  Container(
                                                    height: 180,
                                                    //color: Colors.white,
                                                    width: double.infinity,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: newsFeedList[pos]['image'],
                                                      placeholder: (context, url) =>Image.asset('assets/thumb2.jpeg'),
                                                      errorWidget: (context, url, error) => Container(),
                                                    ),
                                                  ),

                                                  newsFeedList[pos]['video_capture_full']!=null && newsFeedList[pos]['video_capture_full']!=''?
                                                  Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40)):Container()


                                                ],
                                              )

                                            /*  FadeInImage.assetNetwork(
                                                                                                  placeholder: 'assets/spinner.gif',
                                                                                                 fit: BoxFit.cover,
                                                                                                  image:  newsFeedList[pos]['image'],
                                                                                                ),
*/

                                            /*   Image.network(
                                                                                                   newsFeedList[pos]['image'],
                                                                                                  width: double.infinity,
                                                                                                  fit: BoxFit.cover,
                                                                                                )*/
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
                                                          return LikesScreen(newsFeedList[pos]['id']);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child:
                                                  newsFeedList[pos]['post_likes'].length!=0?
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
                                                        return CommentsScreen(newsFeedList[pos]['id']);
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  newsFeedList[pos][
                                                  'post_reply']
                                                      .length !=
                                                      0
                                                      ?
                                                  newsFeedList[pos]['post_reply'].length.toString() + ' Reactions':'No reactions',
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
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child:
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [

                                                      Container(
                                                          child:
                                                          isLikedPost(pos)?
                                                          Icon(Icons.thumb_up_sharp,color: Colors.blue):
                                                          GestureDetector(
                                                            onTap: (){
                                                              likedPosition=pos;
                                                              setState((){
                                                              });


                                                              onLikeButtonTapped(newsFeedList[pos]['id'], pos);
                                                            },
                                                            child: Icon(Icons.thumb_up_sharp,color:likedPosition==pos?Colors.blue:AppTheme.gradient3),
                                                          )




                                                        /*Image.asset(
                                                                      'assets/emoji_like.gif',
                                                                      width: 35,
                                                                      height: 35,
                                                                    ),*/
                                                      ),
                                                      SizedBox(width: 5),

                                                      Text(
                                                        newsFeedList[pos]['post_likes'].length==0?'':
                                                        newsFeedList[pos]['post_likes'].length.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500),
                                                      )
                                                    ],
                                                  )
                                              ),
                                              Container(
                                                  width: 0.5,
                                                  height: 55,
                                                  color: Colors
                                                      .white),
                                              Expanded(
                                                flex: 1,
                                                child:
                                                FittedBox(
                                                  fit: BoxFit
                                                      .scaleDown,
                                                  child:
                                                  GestureDetector(
                                                    onTap:
                                                        () {
                                                      showCommentDialog(newsFeedList[pos]
                                                      [
                                                      'id'],pos);
                                                    },
                                                    child:
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      child: Image
                                                          .asset(
                                                        'assets/thums_up.gif',
                                                        width:
                                                        38,
                                                        height:
                                                        38,
                                                      ),
                                                    ),
                                                  ),

                                                  /*ReactionButtonToggle<String>(
                                                                      onReactionChanged: (String? value, bool isChecked) {
                                                                        debugPrint(
                                                                            'Selected value: $value, isChecked: $isChecked');
                                                                      },

                                                                      reactions:Example.reactionsFinal,
                                                                      initialReaction: Reaction<String>(
                                                                        value: null,
                                                                        icon: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Image.asset(
                                                                            'assets/thums_up.gif',
                                                                            width: 38,
                                                                            height: 38,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // selectedReaction: Example.reactions[1],

                                                                      boxDuration: const Duration(milliseconds: 400),
                                                                      itemScaleDuration: const Duration(milliseconds: 200),
                                                                      boxPadding: EdgeInsets.all(5),
                                                                    //  boxColor: Colors.redAccent.withOpacity(0.5),
                                                                    ),*/
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


                  ),

                  isPagLoading
                      ? Container(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: Loader(),
                    ),
                  )
                      : Container(),


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
  _blockUser(int id) {
    APIDialog.showAlertDialog(context, 'Blocking user...');

    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var blockList = prefs.getStringList('blockusers');

      if (blockList == null) {
        List<String> blockListNew = [];
        blockListNew.add(id.toString());
        prefs.setStringList('blockusers', blockListNew);
      } else {
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

  fetchBlockValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    blockList = prefs.getStringList('blockusers');
    if (blockList == null) {
      blockList = [];
    }
    setState(() {});
    print('Fetching Block Data');
    print(blockList);
  }
  _hidePost(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var blockList = prefs.getStringList('blockusers');

    if (blockList == null) {
      List<String> blockListNew = [];
      blockListNew.add(id.toString());
      prefs.setStringList('blockusers', blockListNew);
    } else {
      blockList.add(id.toString());
      prefs.setStringList('blockusers', blockList);
    }
    fetchBlockValues();
  }
  _callAPI() {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': authBloc.state.userId
    };
    friendsBloc.fetchFriendProfile(context, requestModel);
  }

  _deletePost(int postId) async {

    APIDialog.showAlertDialog(context, 'Deleting Post');

    var requestModel = {
      'auth_key': AppModel.authKey,
      'post_id': postId
    };
    bool status=await friendsBloc.deletePost(context, requestModel);
    if(status)
      {
        _callAPI();
      }
  }

  @override
  void initState() {
    super.initState();
    fetchBlockValues();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _page++;
        if (loadMoreData) {
          setState(() {
            isPagLoading = true;
          });
          fetchPostsPaginate(context,_page);
        }
      }
    });

    fetchPosts();
  }



  fetchPostsPaginate(BuildContext context,int page) async {

    var formData = {'auth_key': AppModel.authKey,'hit_count':page};
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('newfeed', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    isPagLoading = false;
    List<dynamic> newPosts= responseJson['show_post'];
    if(newPosts.length==0)
    {
      loadMoreData=false;
    }
    else
    {
      List<dynamic> combo=newsFeedList+newPosts;
      newsFeedList=combo;
    }

    setState(() {});
  }
  fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    var formData = {'auth_key': AppModel.authKey,'hit_count':1};
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('newfeed', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);

    newsFeedList = responseJson['show_post'];
    isLoading = false;
    setState(() {});
  }






  onLikeButtonTapped(int postID,int pos) async {
    var formData = {
      'auth_key': AppModel.authKey,
      'post_id': postID,
    };
    bool apiStatus= await dashboardBloc.likePost(context, formData);
    if(apiStatus)
    {
      _refreshNewsFeeds(pos,'Like',postID);
    }
  }
  _refreshNewsFeeds(int pos,String type,int postID) async {

    if(type=='Like')
    {

      newsFeedList[pos]['post_likes'].add(  {
        "id": 1,
        "post_id": postID,
        "liked_by_id": authBloc.state.userId,
        "created_at": "2022-08-26 12:27:26",
        "updated_at": "2022-08-26 12:27:26"
      });

      setState(() {

      });

    }

    else
    {

      newsFeedList[pos]['post_reply'].add(  {
        "id": 1,
        "post_id": postID,
        "reacted_by_id": 86,
        "emoji": "😘",
        "gif": null,
        "created_at": "2022-08-26 12:27:12",
        "updated_at": "2022-08-26 12:27:12"
      });

      setState(() {

      });

    }


  }
  static String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
  }
  void actionPopUpItemSelected(String value, int id,int postId) async {
    print('The id is ' + id.toString());
    switch (value) {
    // View Reactions
      case 'Report post':
        AppModel.setReportedId(postId);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ReportScreen('post',true)));
        break;
      case 'View Reactions':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CommentsScreen(postId)));
        break;
      case 'Hide':
        _hidePost(id);
        break;
      case 'Block this user':
        _blockUser(id);
        break;
    }
  }
  void showCommentDialog(int postId,int pos) {
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
                                _onEmojiSelected(emoji, postId,pos);
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
                                child: Image.network(
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
  _onEmojiSelected(Emoji emoji, int postId,int pos) {
    Navigator.pop(context);
    addReaction(postId, emoji.emoji,pos);

  }
  addReaction(int postId, String name,int pos) async {
    var requestModel = {
      'post_id': postId,
      'auth_key': AppModel.authKey,
      'emoji': name
    };

   bool apiStatus=await dashboardBloc.addComment(context, requestModel);
   if(apiStatus)
     {
       _refreshNewsFeeds(pos,'Reaction',postId);
     }
  }
  bool isLikedPost(int pos){

    bool likePost=false;
    if(newsFeedList[pos]['post_likes'].length!=0)
    {

      List<dynamic> postLikes=newsFeedList[pos]['post_likes'];

      for(int i=0;i<postLikes.length;i++)
      {
        if(postLikes[i]['liked_by_id']==authBloc.state.userId)
        {
          likePost=true;
          break;
        }
        else
        {
          likePost=false;
        }

      }

    }
    return likePost;
  }

}
