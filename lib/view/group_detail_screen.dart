import 'dart:io';
import 'dart:typed_data';

import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/bloc/profile_bloc.dart';
import 'package:aha_project_files/view/edit_group_screen.dart';
import 'package:aha_project_files/view/edit_profile_screen.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/group_members_screen.dart';
import 'package:aha_project_files/view/profile_new_sceen.dart';
import 'package:aha_project_files/view/report_screen.dart';
import 'package:aha_project_files/view/send_invites.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/app_modal.dart';
import '../models/group_info_model.dart';
import '../network/api_dialog.dart';
import '../network/bloc/friends_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/add_post_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/cover_image_widget.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/list_video_widget.dart';
import '../widgets/loader.dart';
import '../widgets/rounded_image_widget.dart';
import 'comments_screen.dart';
import 'full_video_screen.dart';
import 'image_display.dart';
import 'likes_screen.dart';

class GroupDetail extends StatefulWidget {
  final int groupId;
   GroupDetail(this.groupId);

  @override
  GroupDetailState createState() => GroupDetailState();
}

class GroupDetailState extends State<GroupDetail> {
  final groupBloc = Modular.get<ProfileCubit>();
  final dashboardBloc = Modular.get<DashboardCubit>();
  final authBloc = Modular.get<AuthCubit>();
  int likedPosition=9999;
  final friendsBloc = Modular.get<FriendsCubit>();

  File? coverImage;
  List<String>? blockList;
  final picker = ImagePicker();
  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              body: BlocBuilder(
        bloc: groupBloc,
        builder: (context, state) {
          return Stack(
            children: [
              BackgroundWidget(),


              groupBloc.state.isLoading?
                  Center(
                    child: Loader(),
                  ):
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      GroupCoverWidget(groupBloc.state.groupInfo![0].group_avatar.toString()),

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
                      groupBloc.state.groupInfo![0].created_by==authBloc.state.userId?

                      GestureDetector(
                        onTap:() async {

                          final data=await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditGroupScreen(groupBloc.state.groupInfo![0].group_name!, groupBloc.state.groupInfo![0].group_about!, groupBloc.state.groupInfo![0].group_avatar!.toString(), widget.groupId)));

                          if(data!=null)
                          {
                            _executeAPI();
                          }



                          //  getCoverImage();


                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 40),
                          height: 200,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 15,bottom: 5),
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
                      ):Container()

                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            groupBloc.state.groupInfo![0].group_name!
                            ,
                            style: const TextStyle(
                                color: Color(0xFFEC831B),
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),

                        groupBloc.state.groupInfo![0].created_by==authBloc.state.userId?

                        GestureDetector(
                          onTap: (){
                            showAlertDialog(context);
                          },
                          child:

                          Icon(Icons.delete,color: Colors.red)


                          /*Text(
                          'Delete Group',
                          style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w600),
          ),*/
                        ):
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

                                          groupBloc.state.isGroupMember==1?

                                          AppTheme.navigationRed:Color(0xFF284888))),
                              onPressed: () {

                                if(groupBloc.state.isGroupMember==1)
                                  {

                                    _leaveGroup();
                                  }
                                else
                                  {

                                    _joinGroup();
                                  }



                              },
                              child:  Text(

                                  groupBloc.state.isGroupMember==1?
                                  "Leave":"Join",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      groupBloc.state.groupInfo![0].group_about!,
                      style:
                          const TextStyle(color: Color(0xFF999999), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 13),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GroupCard(
                              'Members',
                              const Icon(Icons.people,color: Colors.white),
                              AppTheme.gradient1,
                                  (){
                                bool isAdmin=false;
                                if(groupBloc.state.groupInfo![0].created_by==authBloc.state.userId)
                                  {
                                    isAdmin=true;
                                  }
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupMembers(widget.groupId,isAdmin)));
                              }



                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child:
                          GroupCard(
                              'Invite Friends',
                              Icon(Icons.person_add_alt_1_rounded,color: Colors.white),
                              Colors.grey,
                                  (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SendInvites(widget.groupId)));
                              }


                          )
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),


                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Divider(
                      thickness: 0.7,
                      color: Colors.black,
                    ),
                  ),
                  groupBloc.state.isGroupMember==1?
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 10),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      final closeStatus = await Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) {
                                            return AddPostWidget(
                                                'Group',
                                            widget.groupId);
                                          },
                                        ),
                                      );

                                      if (closeStatus != null) {
                                        _executeAPI();
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
                                          fillColor: AppTheme.gradient1.withOpacity(0.4),
                                          filled: true,
                                          contentPadding: const EdgeInsets.fromLTRB(
                                              20.0, 12.0, 0.0, 12.0),
                                          hintText: 'Post something',
                                          labelStyle: const TextStyle(
                                            fontSize: 12.0,
                                            color: Color(0XFF606060),
                                          ),
                                        )),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                      ],
                    ),
                  ):Container(),

                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child:
                    groupBloc.state.groupPosts.length==0?
                        Container():


                    Text(
                      'Group Posts(${groupBloc.state.groupPosts.length})',
                      style: const TextStyle(
                          color: Color(0xff867983),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),

                  groupBloc.state.groupPosts.length==0?

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text('No Posts found'),
                        ),
                      ):





                  ListView.builder(
                      itemCount: groupBloc.state.groupPosts.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int pos) {
                        return

                          blockList!.contains(groupBloc
                              .state
                              .groupPosts[pos]
                              .id!.toString())?

                              Container():


                          Column(
                          children: [
                            Card(
                              elevation: 8,
                              margin:
                              const EdgeInsets.symmetric(horizontal: 5),
                              color: pos % 2 == 0
                                  ? AppTheme.gradient4
                                  : AppTheme.gradient1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: double.infinity,
                                padding:
                                const EdgeInsets.symmetric(horizontal: 7),
                                // height: 300,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap:(){
                                            if(groupBloc.state.groupPosts[pos].userpost![0].id==authBloc.state.userId)
                                            {
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreenNew()));
                                            }
                                            else
                                            {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => FriendProfile(groupBloc.state.groupPosts[pos].userpost![0].id!)));
                                            }

                                          },
                                          child: RoundedImageWidget(
                                              groupBloc
                                                  .state
                                                  .groupPosts[pos].userpost![0]
                                                  .avatar!),
                                        ),
                                      /*  CircleAvatar(
                                          radius: 24.0,
                                          backgroundImage: NetworkImage(

                                                  groupBloc
                                                      .state
                                                      .groupPosts[pos].userpost![0]
                                                      .avatar!),
                                        ),*/
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [

                                                GestureDetector(
                                                  onTap:(){

                                                    if(groupBloc.state.groupPosts[pos].userpost![0].id==authBloc.state.userId)
                                                      {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreenNew()));
                                                      }
                                                    else
                                                    {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(builder: (context) => FriendProfile(groupBloc.state.groupPosts[pos].userpost![0].id!)));
                                                    }


                                        },
                                                  child:  Text(
                                                    groupBloc.state.groupPosts[pos].userpost![0]
                                                        .first_name! +
                                                        ' ' +
                                                        groupBloc
                                                            .state
                                                            .groupPosts[pos].userpost![0]
                                                            .last_name!,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                const SizedBox(height: 1),
                                                Text(
                                                  _parseServerDate(groupBloc.state.groupPosts[pos]
                                                      .created_at!.toString()),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            )),


                                        groupBloc.state.groupInfo![0].created_by==authBloc.state.userId?
                                        groupBloc.state.groupPosts[pos].userpost![0].id==authBloc.state.userId?



                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_horiz,
                                              color: Colors.white),
                                          onSelected:(String value) => handleClickReport(value,groupBloc.state.groupPosts[pos]
                                              .id!,groupBloc.state.groupPosts[pos].id!),
                                          itemBuilder: (BuildContext context) {
                                            return {'Delete post'}.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice,style: const TextStyle(
                                                    fontSize: 15
                                                )),
                                              );
                                            }).toList();
                                          },
                                        ):





                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_horiz,
                                              color: Colors.white),
                                          onSelected:(String value) => handleClickReport(value,groupBloc.state.groupPosts[pos]
                                              .id!,groupBloc.state.groupPosts[pos].id!),
                                          itemBuilder: (BuildContext context) {
                                            return {'Delete post','Report post','Hide'}.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice,style: const TextStyle(
                                                    fontSize: 15
                                                )),
                                              );
                                            }).toList();
                                          },
                                        ): PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_horiz,
                                              color: Colors.white),
                                          onSelected:(String value) => handleClickReport(value,groupBloc.state.groupPosts[pos]
                                              .id!,groupBloc.state.groupPosts[pos].id!),
                                          itemBuilder: (BuildContext context) {
                                            return {'Report post','Hide'}.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice,style: const TextStyle(
                                                    fontSize: 15
                                                )),
                                              );
                                            }).toList();
                                          },
                                        )
                                      ],
                                    ),
                                    groupBloc.state.groupPosts[pos].body==null?
                                    Container():
                                    const SizedBox(height: 7),
                                    groupBloc.state.groupPosts[pos].body==null?
                                    Container():
                                    SizedBox(
                                      width:
                                      MediaQuery.of(context).size.width,
                                      child:
                                      ReadMoreText(
                                        groupBloc.state.groupPosts[pos].body!,
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
                                        groupBloc.state.groupPosts[pos].body!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),*/
                                    ),
                                    const SizedBox(height: 10),



                                   /* groupBloc.state.groupPosts[pos].image!=
                                        null &&
                                        groupBloc.state.groupPosts[pos].image!
                                            .toString()
                                            .contains(
                                            '.mp4')
                                        ? GestureDetector(
                                        onTap:
                                            () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FullVideoScreen(groupBloc.state.groupPosts[pos].image!)));
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
                                                      path: groupBloc.state.groupPosts[pos].image!,
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




                                    groupBloc.state.groupPosts[pos].image ==
                                        null &&
                                        groupBloc.state.groupPosts[pos]
                                            .image_capture ==
                                            null &&
                                       /* groupBloc.state.groupPosts[pos]
                                            .video_recording ==
                                            null &&*/
                                        groupBloc.state.groupPosts[pos]
                                            .gif_id ==
                                            null
                                        ? Container()
                                        :
                                    //video player logic
                             /*       groupBloc.state.groupPosts[pos]
                                        .video_recording !=
                                        null
                                        ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FullVideoScreen(
                                                        groupBloc
                                                            .state
                                                            .groupPosts[
                                                        pos]
                                                            .video_recording
                                                            .toString())));
                                      },
                                      child:
                                      Container(
                                          height: 180,
                                          width: double.infinity,
                                          child:Stack(
                                            children: [
                                              Center(
                                                child: CachedVideoPreviewWidget(
                                                    path: groupBloc
                                                        .state
                                                        .groupPosts[
                                                    pos]
                                                        .video_recording
                                                        .toString(),
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
                                        play: false,
                                        iconSize: 70,
                                        url: AppConstant
                                            .postImageURL +
                                            groupBloc
                                                .state
                                                .groupPosts[pos]
                                                .video_recording
                                                .toString(),
                                        loaderColor: Colors.white,
                                      ),*//*
                                    )
                                        :*/ groupBloc.state.groupPosts[pos]
                                        .image_capture !=
                                        null
                                        ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageDisplay(
                                                image:
                                                    groupBloc
                                                        .state
                                                        .groupPosts[
                                                    pos]
                                                        .capture_full
                                                        .toString()),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          height: 180,
                                          color: Colors.white,
                                          width:
                                          double.infinity,
                                          child:
                                          CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: groupBloc
                                                .state
                                                .groupPosts[
                                            pos]
                                                .image_capture
                                                .toString(),
                                            placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                            errorWidget: (context, url, error) => Container(),
                                          ),

                                         /* Image.network(
                                            cacheHeight:150,
                                            cacheWidth:200,
                                                groupBloc
                                                    .state
                                                    .groupPosts[
                                                pos]
                                                    .image_capture
                                                    .toString(),
                                            width:
                                            double.infinity,
                                            fit: BoxFit.cover,
                                          )*/),
                                    ):


                                    groupBloc.state.groupPosts[pos]
                                        .image !=
                                        null?
                                         GestureDetector(
                                      onTap: () {

                                        if( groupBloc
                                            .state
                                            .groupPosts[pos].video_capture_full!=null &&  groupBloc
                                            .state
                                            .groupPosts[pos].video_capture_full!="")
                                        {
                                          // a video

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FullVideoScreen( groupBloc
                                                  .state
                                                  .groupPosts[pos].video_capture_full!, groupBloc
                                                  .state
                                                  .groupPosts[pos].image!),
                                            ),
                                          );
                                        }
                                        else
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageDisplay(
                                                    image:
                                                    groupBloc
                                                        .state
                                                        .groupPosts[
                                                    pos]
                                                        .image_full
                                                        .toString()),
                                              ),
                                            );

                                          }





                                      },
                                      child: Container(
                                          height: 180,
                                            color: Colors.white,
                                          width: double.infinity,
                                          child:
                                          Stack(
                                            children: [

                                              Container(
                                                height: 180,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:  groupBloc
                                                      .state
                                                      .groupPosts[pos]
                                                      .image!,
                                                  placeholder: (context, url) =>Image.asset('assets/thumb2.jpeg'),
                                                  errorWidget: (context, url, error) => Container(),
                                                ),
                                              ),

                                              groupBloc
                                                  .state
                                                  .groupPosts[pos]
                                                  .video_capture_full!=null &&  groupBloc
                                                  .state
                                                  .groupPosts[pos]
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
                                    ):

                                        groupBloc.state.groupPosts[pos].gif_id !=
                                            null?



                                        GestureDetector(
                                          onTap:
                                              () {
                                            Navigator
                                                .push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageDisplay(image: groupBloc.state.groupPosts[pos].gif_id!.toString()),
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
                                                  imageUrl: groupBloc.state.groupPosts[pos].gif_id!.toString(),
                                                  placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                  errorWidget: (context, url, error) => Container(),
                                                ),

                                            /*    Image.network(
                                                  cacheHeight:150,
                                                  cacheWidth:200,
                                                  groupBloc.state.groupPosts[pos].gif_id!.toString(),
                                                  fit: BoxFit.cover,
                                                )*/),
                                          ),
                                        ):Container(),




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
                                                      return LikesScreen(groupBloc.state.groupPosts[pos].id!);
                                                    },
                                                  ),
                                                );
                                              },
                                              child:
                                              groupBloc.state.groupPosts[
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
                                                    return CommentsScreen( groupBloc.state.groupPosts[
                                                    pos]
                                                        .id!);
                                                  },
                                                ),
                                              );
                                            },
                                            child: Text(
                                              groupBloc.state.groupPosts[
                                              pos]
                                                  .post_reply !=
                                                  null?
                                              groupBloc.state.groupPosts[
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
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child:  Row(
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


                                                        onLikeButtonTapped(groupBloc
                                                            .state
                                                            .groupPosts[pos].id!, pos);
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
                                                  groupBloc
                                                      .state
                                                      .groupPosts[pos].post_likes!.length==0?'':
                                                  groupBloc
                                                      .state
                                                      .groupPosts[pos].post_likes!.length.toString(),
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
                                              color: Colors.white),
                                          Expanded(
                                            flex: 1,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showCommentDialog(groupBloc
                                                      .state
                                                      .groupPosts[pos]
                                                      .id!,pos);
                                                },
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      8.0),
                                                  child: Image.asset(
                                                    'assets/thums_up.gif',
                                                    width: 38,
                                                    height: 38,
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
                      }),



                ],
              )
            ],
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
    fetchBlockValues();

    _executeAPI();
  }
  _refreshNewsFeeds(int pos, String type) async {
    if (type == 'Like') {
      List<GroupPost> list = groupBloc.state.groupPosts;

      PostLike model = PostLike(1, 0,authBloc.state.userId,'','');

      list[pos].post_likes!.add(model);

      setState(() {
        groupBloc.updateGroupReactions(list);
      });
    } else {
      List<GroupPost> list = groupBloc.state.groupPosts;

      PostReply model = PostReply(1, 0,authBloc.state.userId,'','','','');

      list[pos].post_reply!.add(model);
      print('new list');

      setState(() {
        groupBloc.updateGroupReactions(list);
      });
    }
  }
  _executeAPI() {
    var formData = {'auth_key': AppModel.authKey, 'group_id': widget.groupId};
    print('Group ID:${widget.groupId}');
    groupBloc.groupInfo(context, formData);
  }


  _joinGroup() async {
    var formData = {'auth_key': AppModel.authKey, 'group_id': widget.groupId};
    bool apiStatus=await groupBloc.joinGroup(context, formData);
    if(apiStatus)
      {
        _executeAPI();
      }
  }


  _deleteGroup() async {
    var formData = {'auth_key': AppModel.authKey, 'group_id': widget.groupId};
   groupBloc.deleteGroup(context, formData);
  }



  onLikeButtonTapped(int postID,int pos) async {
    var formData = {
      'auth_key': AppModel.authKey,
      'post_id': postID,
    };
    bool apiStatus= await dashboardBloc.likePost(context, formData);
    if(apiStatus)
    {
      _refreshNewsFeeds(pos,'Like');
    }
  }
  _leaveGroup() async {
    var formData = {'auth_key': AppModel.authKey, 'group_id': widget.groupId};
    bool apiStatus=await groupBloc.exitGroup(context, formData);
    if(apiStatus)
    {
      _executeAPI();
    }
  }
 /* Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);
    coverImage = File(pickedFile!.path);
    //userImages.add(_image!);
    setState(() {});
    if(coverImage!=null)
    {
      _updateCoverImage();
    }
  }*/
  /*_updateCoverImage() async {
    FormData requestModel = FormData.fromMap({
      'auth_key': AppModel.authKey,
      'group_avatar':await MultipartFile.fromFile(coverImage!.path),
      'group_id':widget.groupId,
    });
    groupBloc.updateGroupCover(context,requestModel);
  }*/

  Future<void> handleClickReport(String value,int id,int postId) async {
    switch (value) {

      case 'Delete post':

        _deletePost(postId);
        break;
      case 'Report post':
        AppModel.setReportedId(postId);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen('post',true)));
        break;
      case 'Hide':
        _hidePost(id);
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


  addReaction(int postId, String name,int pos) async {
    var requestModel = {
      'post_id': postId,
      'auth_key': AppModel.authKey,
      'emoji': name
    };

    bool apiStatus=await dashboardBloc.addComment(context, requestModel);
    if(apiStatus)
    {
      _refreshNewsFeeds(pos,'Reaction');
    }
  }

  _onEmojiSelected(Emoji emoji, int postId,int pos) {
    Navigator.pop(context);
    addReaction(postId, emoji.emoji,pos);
  }
  bool isLikedPost(int pos){

    bool likePost=false;
    if(groupBloc
        .state
        .groupPosts[pos].post_likes!.length!=0)
    {

      List<dynamic> postLikes=groupBloc
          .state
          .groupPosts[pos].post_likes!;

      for(int i=0;i<postLikes.length;i++)
      {
        if(groupBloc.state.groupPosts[pos].post_likes![i].liked_by_id==authBloc.state.userId)
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

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(
          color: Colors.grey
      )),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete",style: TextStyle(
        color: Colors.red
      ),),
      onPressed:  () {
        Navigator.pop(context);
        _deleteGroup();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Group"),
      content: Text("Are you sure you want to delete this group?"),
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

  _deletePost(int postId) async {

    APIDialog.showAlertDialog(context, 'Deleting Post');

    var requestModel = {
      'auth_key': AppModel.authKey,
      'post_id': postId
    };
    bool status=await friendsBloc.deletePost(context, requestModel);
    if(status)
    {
      _executeAPI();
    }
  }
  String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
  }
  Future<Uint8List> returnThumbnail(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
    return uint8list!;
  }
}
