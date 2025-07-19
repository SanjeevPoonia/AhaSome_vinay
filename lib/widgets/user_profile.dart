import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/small_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../network/api_dialog.dart';
import '../utils/app_theme.dart';
import '../view/report_screen.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/dashboard_card_widget.dart';

class UserProfile extends StatefulWidget {
  final int friendId, pos;

  UserProfile(this.friendId, this.pos);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final friendsBloc = Modular.get<FriendsCubit>();
  String postText = '';
  bool isFriend = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocBuilder(
              bloc: friendsBloc,
              builder: (context, state) {
                return friendsBloc.state.isLoading
                    ? Loader()
                    : ListView(
                  children: [

                    Stack(
                      children: [

                        Container(
                          height: 180,
                          margin: EdgeInsets.only(top: 45),
                          width: MediaQuery.of(context).size.width,
                          decoration:  BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(friendsBloc.state.friendProfile[0].user_bg.toString()),
                            ),
                          ),
                        ),
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


                   /* Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration:  BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(AppConstant.userImageURL+friendsBloc.state.friendProfile[0].user_bg.toString()),
                        ),
                      ),
                    ),*/
                    Container(
                        transform: Matrix4.translationValues(
                            0.0, -20.0, 0.0),
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
                                width: MediaQuery.of(context)
                                    .size
                                    .width,
                                height: MediaQuery.of(context)
                                    .size
                                    .height,
                                padding: const EdgeInsets.only(
                                    top: 20),
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
                              transform:
                              Matrix4.translationValues(
                                  0.0, -40.0, 0.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration:
                                      const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 4,
                                              color: Colors.black,
                                              spreadRadius: 2)
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage:
                                        NetworkImage(
                                            friendsBloc
                                                .state
                                                .friendProfile[0]
                                                .avatar!),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      '${friendsBloc.state.friendProfile[0].first_name} ${friendsBloc.state.friendProfile[0].last_name}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      friendsBloc
                                          .state
                                          .friendProfile[0]
                                          .country!,
                                      style: const TextStyle(
                                          color: AppTheme.gradient1,
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      isFriend
                                          ? InkWell(
                                        onTap: () {

                                          _followUser();

                                        },
                                        child: SizedBox(
                                            width: 160,
                                            height: 47,
                                            child: Card(
                                              elevation: 6,
                                              shadowColor:
                                              Colors
                                                  .black,
                                              margin:
                                              EdgeInsets
                                                  .zero,
                                              color: AppTheme
                                                  .gradient2,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              child:
                                              Container(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    vertical:
                                                    10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    friendsBloc
                                                        .state
                                                        .isRequestLoading
                                                        ? SmallLoader(
                                                        Colors.white)
                                                        : const Text(
                                                      'Happy to Connect',
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                        10)
                                                  ],
                                                ),
                                              ),
                                            )),
                                      )
                                          : InkWell(
                                        onTap: () {},
                                        child: SizedBox(
                                            width: 150,
                                            height: 47,
                                            child: Card(
                                              elevation: 6,
                                              shadowColor:
                                              Colors
                                                  .black,
                                              margin:
                                              EdgeInsets
                                                  .zero,
                                              color: AppTheme
                                                  .gradient4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              child:
                                              Container(
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
                                                    friendsBloc
                                                        .state
                                                        .isRequestLoading
                                                        ? SmallLoader(
                                                        Colors.white)
                                                        : const Text(
                                                      'Requested',
                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                                                    ),

                                                    const SizedBox(
                                                        width:
                                                        10)
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                      SizedBox(width: 12),

                                      Container(
                                        height: 45,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFc5c5c5),
                                          borderRadius: BorderRadius.circular(10),
                                        ),

                                        child:  PopupMenuButton<String>(
                                          icon: Icon(
                                              Icons.more_horiz,
                                              color: Colors.black,size: 20),
                                          onSelected: handleClickReport,
                                          itemBuilder: (BuildContext context) {
                                            return {'Report user','Block'}.map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice,style: TextStyle(
                                                    fontSize: 15
                                                ),),
                                              );
                                            }).toList();
                                          },
                                        ),

                                      )

                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal: 12),
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                    EdgeInsets.only(left: 12),
                                    child: Text(
                                      'About',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Hobbies:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight
                                                  .w500),

                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.65,
                                          child: Text(
                                            friendsBloc
                                                .state
                                                .friendProfile[0]
                                                .hobbies
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15),
                                            maxLines: 3,
                                            overflow: TextOverflow
                                                .visible,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 12),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Country:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        Text(
                                          friendsBloc
                                              .state
                                              .friendProfile[0]
                                              .country!,
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 12),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Email:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight
                                                  .w500),
                                        ),
                                        Text(
                                          friendsBloc
                                              .state
                                              .friendProfile[0]
                                              .email!,
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal: 12),
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 12),
                                    child: Text(
                                      friendsBloc
                                          .state
                                          .friendPostList
                                          .length !=
                                          0
                                          ? 'Posts'
                                          : 'No Posts found',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight:
                                          FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(height: 13),
                                  ListView.builder(
                                      itemCount: friendsBloc.state
                                          .friendPostList.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 5),
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
                                              elevation: 8,
                                              margin:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  5),
                                              color: pos % 2 == 0
                                                  ? AppTheme
                                                  .gradient4
                                                  : AppTheme
                                                  .gradient1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      10)),
                                              child: Container(
                                                width: double
                                                    .infinity,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    7),
                                                // height: 300,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const SizedBox(
                                                        height:
                                                        7),
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius:
                                                          24.0,
                                                          backgroundImage:
                                                          NetworkImage(
                                                              friendsBloc.state.findFriendList[widget.pos].avatar!),
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                            10),
                                                        Expanded(
                                                            child:
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  '${friendsBloc.state.findFriendList[widget.pos].first_name} ${friendsBloc.state.findFriendList[widget.pos].last_name}',
                                                                  style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15),
                                                                ),
                                                                const SizedBox(
                                                                    height: 1),
                                                                Text(
                                                                  friendsBloc.state.friendPostList[pos].created_at!,
                                                                  style:
                                                                  const TextStyle(color: Colors.white, fontSize: 11),
                                                                ),
                                                              ],
                                                            )),

                                                        PopupMenuButton<String>(
                                                          icon: const Icon(Icons.more_horiz,
                                                              color: Colors.white),
                                                          onSelected: handleClickReport2,
                                                          itemBuilder: (BuildContext context) {
                                                            return {'Report post'}.map((String choice) {
                                                              return PopupMenuItem<String>(
                                                                value: choice,
                                                                child: Text(choice,style: TextStyle(
                                                                    fontSize: 15
                                                                ),),
                                                              );
                                                            }).toList();
                                                          },
                                                        )


                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                        7),
                                                    SizedBox(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width,
                                                      child: Text(
                                                        friendsBloc
                                                            .state
                                                            .friendPostList[
                                                        pos]
                                                            .body!,
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            fontSize:
                                                            14),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height:
                                                        10),
                                                    friendsBloc.state.friendPostList[pos].image !=
                                                        null
                                                        ? Container(
                                                        color: Colors
                                                            .white,
                                                        width: double
                                                            .infinity,
                                                        child: Image
                                                            .network(
                                                          height:
                                                          180,
                                                              friendsBloc.state.friendPostList[pos].image!,
                                                          width:
                                                          double.infinity,
                                                          fit:
                                                          BoxFit.cover,
                                                          errorBuilder: (BuildContext context,
                                                              Object exception,
                                                              StackTrace? stackTrace) {
                                                            return Container(height: 0.4, color: Colors.white);
                                                          },
                                                        ))
                                                        : Container(
                                                        height:
                                                        0.4,
                                                        color:
                                                        Colors.white),
                                                    SizedBox(
                                                      height: 55,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          Image
                                                              .asset(
                                                            'assets/emoji_like.gif',
                                                            width:
                                                            35,
                                                            height:
                                                            35,
                                                          ),
                                                          Container(
                                                              width:
                                                              0.5,
                                                              height:
                                                              55,
                                                              color:
                                                              Colors.white),
                                                          Image
                                                              .asset(
                                                            'assets/thums_up.gif',
                                                            width:
                                                            35,
                                                            height:
                                                            35,
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
                                            const SizedBox(
                                                height: 20),
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
            )));
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
    _callAPI();
  }

  _callAPI() {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': widget.friendId
    };
    friendsBloc.fetchFriendProfile(context, requestModel);
  }


  _followUser() async {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': widget.friendId
    };
    bool apiStatus = await friendsBloc.addFriend(context, requestModel);
    if (apiStatus) {
      isFriend=false;
    }
  }

  Future<void> handleClickReport(String value) async {
    switch (value) {
      case 'Report user':
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen('user',false)));
        break;
      case 'Block':
      _blockUser();
        break;


    }
  }

  Future<void> handleClickReport2(String value) async {
    switch (value) {
      case 'Report post':
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen('post',true)));
        break;
/*
      case 'Block user':
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportScreen('user')));
        break;
        */


    }
  }


  _blockUser()  {
    APIDialog.showAlertDialog(context,'Blocking user...');

    Future.delayed(const Duration(seconds: 2), () async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var blockList = prefs.getStringList('blockusers');

      if(blockList==null)
      {
        List<String> blockListNew=[];
        blockListNew.add(friendsBloc.state.friendProfile[0].id.toString());
        prefs.setStringList('blockusers', blockListNew);
      }
      else
      {
        blockList.add(friendsBloc.state.friendProfile[0].id.toString());
        prefs.setStringList('blockusers', blockList);
      }
      Navigator.pop(context);
      Navigator.pop(context,'Refresh');
      Toast.show('User Blocked successfully',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    });
    print('*** Blocked Successfully***');
  }

}
