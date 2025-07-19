import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/about_screen.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/no_internet_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:aha_project_files/view/add_post_screen.dart';
import 'package:aha_project_files/view/comments_screen.dart';
import 'package:aha_project_files/view/group_chat_screen.dart';
import 'package:aha_project_files/view/group_screen.dart';
import 'package:aha_project_files/view/likes_screen.dart';
import 'package:aha_project_files/view/my_group_invites.dart';
import 'package:aha_project_files/view/my_posts.dart';
import 'package:aha_project_files/view/notification_screen.dart';
import 'package:aha_project_files/view/post_delete_screen.dart';
import 'package:aha_project_files/view/post_details_screen.dart';
import 'package:aha_project_files/view/report_screen.dart';
import 'package:aha_project_files/view/splash2.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:aha_project_files/view/terms_list_screen.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:readmore/readmore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/login_response.dart';
import 'package:aha_project_files/view/chat_listing_screen.dart';
import 'package:aha_project_files/view/friends_screen.dart';
import 'package:aha_project_files/view/full_video_screen.dart';
import 'package:aha_project_files/view/gratitude_screens.dart';
import 'package:aha_project_files/view/hunt_aha_buddy_screen.dart';
import 'package:aha_project_files/view/login_screen.dart';
import 'package:aha_project_files/view/profile_new_sceen.dart';
import 'package:aha_project_files/utils/image_assets.dart';
import 'package:aha_project_files/utils/strings.dart';
import 'package:aha_project_files/view/shoutouts_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/add_post_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_drawer/bloc/home_page_bloc.dart';
import '../widgets/custom_drawer/bloc/shadow_bloc.dart';
import '../widgets/custom_drawer/drawer_screen.dart';
import '../widgets/custom_drawer/shadow.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/list_video_widget.dart';
import '../widgets/navigation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/rounded_image_widget.dart';
import 'albums.dart';
import 'chat_screen.dart';
import 'image_display.dart';
import 'notification_audio_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
/*  final player = AudioPlayer();
  SharedPreferences prefs=await SharedPreferences.getInstance();
  String uri=prefs.getString('notify')!;
  if(uri==null)
  {
    FlutterRingtonePlayer.playNotification();
  }
  else
  {

    player.setUrl(           // Load a URL
        uri);
    player.play();
  }*/
  print('EVENT TRIGGERED BACKGROUND');
  print('Handling a background message ${message.messageId}');
}

class HomeScreen extends StatefulWidget {
  LoginModel model;
  HomeScreen(this.model);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  int _page = 1;
  bool loadMoreData = true;
  int? selectedFilerID=null;
  int notCount = 0;
  bool isNotLoaded = false;
  late ScrollController _scrollController;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  List<String> answerList = [];
  String question = '';
  int likedPosition = 9999;
  String selectedAnswer = '';
  int questionID = 0;
  String answer1 = '';
  String answer2 = '';
  String answer3 = '';
  String answer4 = '';
  Map<String, dynamic>? notificationPayload;
  bool triggerDrawer = false;
  String? selectedCategory;
  int? selectedID;
  bool isLoading = true;
  bool isPagLoading = false;
  List<dynamic> filterList = [];
  Timer? _myTimer;
  int? postId;
  List<dynamic> smileyList = [];
  int popUpPosition = 0;
  List<String> filterListAsString = [];
  var shoutController = TextEditingController();
  var addPostController = TextEditingController();
  String? selectedPostType;
  final dashboardBloc = Modular.get<DashboardCubit>();
  final authBloc = Modular.get<AuthCubit>();
  final picker = ImagePicker();
  List<File> userImages = [];
  List<dynamic> postList = [];
  List<dynamic> newsFeedList = [];
  List<dynamic> postListAsString = [];
  String profileImage = '', name = '';
  List<dynamic> promisesList = [];
  List<String>? blockList;
  String promiseText = '';
  String ahaByMe = '';
  String groupCount = '';
  String friendsCount = '';
  String gratitudeCount = '';
  bool filterLoader = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: AnimatedDrawer(
              homePageXValue: 190,
              homePageYValue: 100,
              homePageAngle: -0.2,
              homePageSpeed: 250,
              shadowXValue: 162,
              shadowYValue: 130,
              shadowAngle: -0.275,
              shadowSpeed: 550,
              openIcon: const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(Icons.menu_open, color: Colors.white),
              ),
              closeIcon: const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              shadowColor: Colors.black45.withOpacity(0.3),
              backgroundGradient: const LinearGradient(
                colors: [
                  AppTheme.gradient2,
                  AppTheme.gradient1,
                  AppTheme.gradient3,
                  AppTheme.gradient4
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 0, 0.52, 1],
              ),
              menuPageContent: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/background.png'))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  BlocBuilder(
                      bloc: authBloc,
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.only(top: 100.0, left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage:
                                    NetworkImage(authBloc.state.profileImage),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 13),
                              Text(
                                '${authBloc.state.firstName} ${authBloc.state.lastName}',
                                style: const TextStyle(
                                    color: AppTheme.gradient1,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      authBloc.state.hobbies.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11.5),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.white,
                                thickness: 1,
                              ),
                              Expanded(
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    /*  NavigationWidget(
                                      menuText: 'Home',
                                      onTap: () {
                                        _closeDrawer();
                                      },
                                    ),*/
                                    NavigationWidget(
                                      menuText: 'New AHA Post',
                                      onTap: () {
                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddPostScreen(),
                                          ),
                                        ).then((value) {
                                          refreshPosts();
                                        });



                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: AppStrings.profile,
                                      onTap: () {
                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfileScreenNew(),
                                          ),
                                        ).then((value) {
                                          refreshPosts();
                                        });





                                        /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreenNew()));*/
                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: 'Happily Following',
                                      onTap: () {

                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FriendsScreen(true),
                                          ),
                                        ).then((value) {
                                         _startTimer();
                                        });




                                    /*    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendsScreen(true)));*/
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen('', '')));
                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: 'Albums',
                                      onTap: () {
                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AlbumScreen(),
                                          ),
                                        ).then((value) {
                                          _startTimer();
                                        });

                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: AppStrings.chatText,
                                      onTap: () {
                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatListScreen(),
                                          ),
                                        ).then((value) {
                                          _startTimer();
                                        });

                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: 'Hunt AHA Buddy',
                                      onTap: () {
                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HuntAHABuddy(),
                                          ),
                                        ).then((value) {
                                          _startTimer();
                                        });

                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: AppStrings.shoutOuts,
                                      onTap: () {
                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ShoutOuts(),
                                          ),
                                        ).then((value) {
                                          _startTimer();
                                        });

                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: AppStrings.gratitude,
                                      onTap: () {

                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GratitudeScreen(),
                                          ),
                                        ).then((value) {
                                          _startTimer();
                                        });
                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: 'Groups',
                                      onTap: () {



                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GroupScreen(),
                                          ),
                                        ).then((value) {
                                          refreshPosts();
                                        });


                                       /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => GroupScreen()));*/





                                      },
                                    ),
                                    NavigationWidget(
                                      menuText: 'Terms & Privacy',
                                      onTap: () {

                                        _stopTimer();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TermsList(),
                                          ),
                                        ).then((value) {
                                          _startTimer();
                                        });

                                      },
                                    ),

                                    /*      NavigationWidget(
                                      menuText: 'About',
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AboutScreen()));
                                      },
                                    ),*/

                                      Platform.isIOS?
                                    NavigationWidget(
                                      menuText: 'Delete account',
                                      onTap: () {
                                        showAlertDialog(context);
                                      },
                                    ):Container(),
                                    NavigationWidget(
                                      menuText: 'Logout',
                                      onTap: () {
                                        showLogOutDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
              homePageContent: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Stack(
                  children: [
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.gradient4),
                            ),
                          )
                        : Stack(
                            children: [
                              BackgroundWidget(),
                              RefreshIndicator(
                                color: Colors.blue,
                                onRefresh: refreshData,
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _scrollController,
                                  padding: const EdgeInsets.only(top: 45),
                                  children: [
                                    BlocBuilder(
                                        bloc: dashboardBloc,
                                        builder: (context, state) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            width: double.infinity,
                                            color: AppTheme.dashboardTopBg,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 15),
                                                promiseText == ''
                                                    ? Container()
                                                    : Container(
                                                        padding: const EdgeInsets.only(
                                                            top: 15),
                                                        height: 40,
                                                        width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width,
                                                        child: Marquee(
                                                          text: promiseText,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Colors.black87,
                                                          ),
                                                          scrollAxis:
                                                              Axis.horizontal,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          blankSpace: 20.0,
                                                          velocity: 100.0,
                                                          pauseAfterRound:
                                                              const Duration(
                                                                  seconds: 1),
                                                          startPadding: 10.0,
                                                          accelerationDuration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          accelerationCurve:
                                                              Curves.linear,
                                                          decelerationDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          decelerationCurve:
                                                              Curves.easeOut,
                                                        ),
                                                      ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: DashboardCard(
                                                          'My Posts',
                                                          ImageAssets.postImage,
                                                          dashboardBloc.state
                                                                      .ahaByMe ==
                                                                  null
                                                              ? ''
                                                              : dashboardBloc
                                                                  .state.ahaByMe
                                                                  .toString(),
                                                          AppTheme.dashboardRed,
                                                          () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => const MyPostsScreen(),
                                                              ),
                                                            ).then((value) {
                                                              refreshPosts();
                                                            });




                                                       /* Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    const ProfileScreenNew()));*/
                                                      }),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Expanded(
                                                      flex: 1,
                                                      child: DashboardCard(
                                                          'My Groups',
                                                          ImageAssets.loveImage,
                                                          dashboardBloc.state
                                                                      .groupCount ==
                                                                  null
                                                              ? ''
                                                              : dashboardBloc
                                                                  .state
                                                                  .groupCount
                                                                  .toString(),
                                                          AppTheme
                                                              .dashboardYellow,
                                                          () {

                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => GroupScreen(),
                                                              ),
                                                            ).then((value) {
                                                              refreshPosts();
                                                            });



                                                            /*  Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    GroupScreen()));*/
                                                      }),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 7),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: DashboardCard(
                                                          'Happily Following',
                                                          ImageAssets.usersImage,
                                                          dashboardBloc.state
                                                                      .friendsCount ==
                                                                  null
                                                              ? ''
                                                              : dashboardBloc
                                                                  .state
                                                                  .friendsCount
                                                                  .toString(),
                                                          AppTheme.gradient2, () {
                                                        _stopTimer();
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>  FriendsScreen(
                                                                true),
                                                          ),
                                                        ).then((value) {
                                                          _startTimer();
                                                        });

                                                      }),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Expanded(
                                                      flex: 1,
                                                      child: DashboardCard(
                                                          'Gratitude',
                                                          ImageAssets
                                                              .thumbsUpImage,
                                                          dashboardBloc.state
                                                                      .gratitudeCount ==
                                                                  null
                                                              ? ''
                                                              : dashboardBloc
                                                                  .state
                                                                  .gratitudeCount
                                                                  .toString(),
                                                          AppTheme.dashboardTeal,
                                                          () {
                                                            _stopTimer();
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>  GratitudeScreen(
                                                                    ),
                                                              ),
                                                            ).then((value) {
                                                              _startTimer();
                                                            });

                                                      }),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 18),
                                              ],
                                            ),
                                          );
                                        }),
                                    Container(
                                      width: double.infinity,
                                      height: 85,
                                      color:
                                          AppTheme.navigationRed.withOpacity(0.3),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          Image.asset(
                                            ImageAssets.thumbsUpImage,
                                            width: 55,
                                            height: 55,
                                          ),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () {




                                              shoutController.clear();
                                              showCustomDialog(context);
                                            },
                                            child: Card(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 7),
                                              color: AppTheme.navigationRed,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              child: const SizedBox(
                                                height: 45,
                                                child: Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: Text(
                                                      'SHOUT OUT OF THE DAY',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                          Image.asset(
                                            ImageAssets.thumbsUpImage,
                                            width: 55,
                                            height: 55,
                                          ),
                                          const SizedBox(width: 5),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BlocBuilder(
                                              bloc: authBloc,
                                              builder: (context, state) {
                                                return CircleAvatar(
                                                  radius: 26.0,
                                                  backgroundImage: NetworkImage(
                                                      authBloc
                                                          .state.profileImage),
                                                );
                                              }),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: InkWell(
                                            onTap: () async {
                                              _stopTimer();
                                              final closeStatus =
                                                  await Navigator.of(context)
                                                      .push(
                                                CupertinoPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) {
                                                    return AddPostWidget(
                                                        'Home', null);
                                                  },
                                                ),
                                              );

                                              if (closeStatus != null) {
                                                fetchPosts(context, null, 1);
                                              }
                                            },
                                            child: TextFormField(
                                                enabled: false,
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  suffixIcon: const Icon(
                                                      Icons.photo,
                                                      size: 32),
                                                  border: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  fillColor: AppTheme.gradient1
                                                      .withOpacity(0.4),
                                                  filled: true,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
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
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5),
                                        Expanded(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 15),
                                            height: 45,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            //width: MediaQuery.of(context).size.width*0.5,
                                            child: DropdownButtonFormField2(
                                              focusColor: Colors.green,
                                              selectedItemHighlightColor:
                                                  Colors.blue,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              isExpanded: true,
                                              hint: const Text(
                                                'Post type',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_outlined,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              iconSize: 30,
                                              buttonHeight: 58,
                                              buttonPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 10),
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              items: filterListAsString
                                                  .map((item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              /* validator: (value) {
                                  if (value == null) {
                                    return 'Please select country code';
                                  }
                                },*/
                                              onChanged: (value) {
                                                selectedCategory =
                                                    value.toString();
                                                print(value);
                                                String result = selectedCategory!
                                                    .substring(
                                                        0,
                                                        selectedCategory!
                                                            .indexOf('('))
                                                    .trim();
                                                print(result);

                                                int? selectedIdDropDown;
                                                for (int i = 0;
                                                    i < filterList.length;
                                                    i++) {
                                                  if (filterList[i]['name'] ==
                                                      result) {
                                                    selectedIdDropDown =
                                                        filterList[i]
                                                            ['category_id'];
                                                    break;
                                                  }
                                                }
                                                print('Selected Filter ID: '+selectedIdDropDown.toString());
                                                loadMoreData = true;
                                                _page = 1;
                                                selectedFilerID=selectedIdDropDown!;

                                                filterPosts(
                                                    context, selectedIdDropDown);
                                              },
                                              onSaved: (value) {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    filterLoader
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 15),
                                              child: Loader(),
                                            ),
                                          )
                                        : ListView.builder(

                                            itemCount: newsFeedList.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder:
                                                (BuildContext context, int pos) {
                                              int userId = newsFeedList[pos]
                                                  ['userpost'][0]['id'];
                                              return blockList!.contains(
                                                      newsFeedList[pos]
                                                                  ['userpost'][0]
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
                                                              : AppTheme
                                                                  .gradient1,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                const EdgeInsets
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
                                                                              builder: (context) => const ProfileScreenNew(),
                                                                            ),
                                                                          ).then((value) {
                                                                            refreshPosts();
                                                                          });
                                                                        } else {
                                                                          _stopTimer();
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) =>  FriendProfile(newsFeedList[pos]['userpost'][0]['id'])
                                                                            ),
                                                                          ).then((value) {
                                                                            _startTimer();
                                                                          });

                                                                        }

                                                          },
                                                                      child:
                                                                      RoundedImageWidget(
                                                                          newsFeedList[pos]
                                                                          [
                                                                          'userpost'][0]
                                                                          [
                                                                          'avatar']),
                                                                    ),


                                                                    /*  CachedNetworkImage(
                                                                      imageUrl: newsFeedList[pos]['userpost'][0]
                                                                      [
                                                                      'avatar'],
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                        width: 50.0,
                                                                        height: 50.0,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          image: DecorationImage(
                                                                              image: imageProvider, fit: BoxFit.cover),
                                                                        ),
                                                                      ),
                                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                    ),*/

                                                                    /* CircleAvatar(
                                                                      radius:
                                                                          24.0,
                                                                      backgroundImage:
                                                                          NetworkImage(newsFeedList[pos]['userpost'][0]
                                                                              [
                                                                              'avatar']),
                                                                    ),*/
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
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
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => const ProfileScreenNew(),
                                                                                ),
                                                                              ).then((value) {
                                                                                refreshPosts();
                                                                              });
                                                                            } else {
                                                                              _stopTimer();
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) =>  FriendProfile(newsFeedList[pos]['userpost'][0]['id'])
                                                                                ),
                                                                              ).then((value) {
                                                                                _startTimer();
                                                                              });
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
                                                                          _parseServerDate(
                                                                              newsFeedList[pos]['created_at'].toString()),
                                                                          style: const TextStyle(
                                                                              color:
                                                                                  Colors.white,
                                                                              fontSize: 11),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                    newsFeedList[pos]['userpost'][0]
                                                                                [
                                                                                'id'] ==
                                                                            authBloc
                                                                                .state
                                                                                .userId
                                                                        ? PopupMenuButton<
                                                                            String>(
                                                                            icon: const Icon(
                                                                                Icons.more_horiz,
                                                                                color: Colors.white),
                                                                            onSelected: (String value) => actionPopUpItemSelected(
                                                                                value,
                                                                                userId,
                                                                                newsFeedList[pos]['id']),
                                                                            itemBuilder:
                                                                                (BuildContext context) {
                                                                              return {
                                                                                'View Reactions'
                                                                              }.map((String
                                                                                  choice) {
                                                                                return PopupMenuItem<String>(
                                                                                  value: choice,
                                                                                  child: Text(
                                                                                    choice,
                                                                                    style: TextStyle(fontSize: 15),
                                                                                  ),
                                                                                );
                                                                              }).toList();
                                                                            },
                                                                          )
                                                                        : PopupMenuButton<
                                                                            String>(
                                                                            icon: const Icon(
                                                                                Icons.more_horiz,
                                                                                color: Colors.white),
                                                                            onSelected: (String value) => actionPopUpItemSelected(
                                                                                value,
                                                                                userId,
                                                                                newsFeedList[pos]['id']),
                                                                            itemBuilder:
                                                                                (BuildContext context) {
                                                                              return {
                                                                                'Report post',
                                                                                'Hide',
                                                                              }.map((String
                                                                                  choice) {
                                                                                return PopupMenuItem<String>(
                                                                                  value: choice,
                                                                                  child: Text(
                                                                                    choice,
                                                                                    style: TextStyle(fontSize: 15),
                                                                                  ),
                                                                                );
                                                                              }).toList();
                                                                            },
                                                                          )
                                                                  ],
                                                                ),

                                                                     const SizedBox(
                                                                        height:
                                                                            7),
                                                                newsFeedList[pos]
                                                                                [
                                                                                'body'] ==
                                                                            null ||
                                                                        newsFeedList[pos]
                                                                                [
                                                                                'body'] ==
                                                                            ""
                                                                    ? Container(height: 5,)
                                                                    : SizedBox(
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
                                                                newsFeedList[pos][
                                                                                'body'] ==
                                                                            null ||
                                                                        newsFeedList[pos]
                                                                                [
                                                                                'body'] ==
                                                                            ""
                                                                    ? Container()
                                                                    : const SizedBox(
                                                                        height:
                                                                            10),
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


                                                                              */ /*    CachedVideoPreviewWidget(
                                                                                      path: newsFeedList[pos]['image'],
                                                                                      type: SourceType.remote,
                                                                                      remoteImageBuilder: (BuildContext context, url) =>

                                                                                          Image.network(url,fit: BoxFit.cover)


                                                                                  ),*/ /*
                                                                                ),

                                                                                Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40))


                                                                              ],
                                                                            )
                                                                        )

                                                                        */ /* VideoWidget(
                                                                          iconSize:
                                                                              70,
                                                                          play:
                                                                              false,
                                                                          url:
                                                                              newsFeedList[pos]['image'],
                                                                          loaderColor:
                                                                              Colors.white,
                                                                        ),*/ /*
                                                                        )
                                                                    : */
                                                                newsFeedList[pos][
                                                                                'image'] ==
                                                                            null &&
                                                                        newsFeedList[pos]
                                                                                [
                                                                                'image_capture'] ==
                                                                            null &&
                                                                        /* newsFeedList[pos]['video_recording'] ==
                                                                                null &&*/
                                                                        newsFeedList[pos]
                                                                                [
                                                                                'gif_id'] ==
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





                                                                                */ /*  VideoWidget(
                                                                                  iconSize: 70,
                                                                                  play: false,
                                                                                  url:  newsFeedList[pos]['video_recording'],
                                                                                  loaderColor: Colors.white,
                                                                                ),*/ /*
                                                                                )
                                                                            : */
                                                                    newsFeedList[pos]
                                                                                [
                                                                                'image_capture'] !=
                                                                            null
                                                                        ? GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                                  _stopTimer();
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) =>  ImageDisplay(image: newsFeedList[pos]['capture_full'])
                                                                                    ),
                                                                                  ).then((value) {
                                                                                    _startTimer();
                                                                                  });

                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height:
                                                                                  180,
                                                                              color:
                                                                                  Colors.white,
                                                                              width:
                                                                                  double.infinity,
                                                                              child:
                                                                                  CachedNetworkImage(
                                                                                fit: BoxFit.cover,
                                                                                imageUrl: newsFeedList[pos]['image_capture'],
                                                                                placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                                errorWidget: (context, url, error) => Container(),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        :
                                                                        //Gif
                                                                        newsFeedList[pos]['gif_id'] !=
                                                                                null
                                                                            ? GestureDetector(
                                                                                onTap: () {

                                                                                  _stopTimer();
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) =>  ImageDisplay(image: newsFeedList[pos]['gif_id'])
                                                                                    ),
                                                                                  ).then((value) {
                                                                                    _startTimer();
                                                                                  });
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
                                                                                      if (newsFeedList[pos]['video_capture_full'] != null && newsFeedList[pos]['video_capture_full'] != '') {
                                                                                        // a video

                                                                                        _stopTimer();
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => FullVideoScreen(newsFeedList[pos]['video_capture_full'],newsFeedList[pos]['image'])
                                                                                          ),
                                                                                        ).then((value) {
                                                                                          _startTimer();
                                                                                        });

                                                                                       /* Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                            builder: (context) => FullVideoScreen(newsFeedList[pos]['video_capture_full'],newsFeedList[pos]['image']),
                                                                                          ),
                                                                                        );*/
                                                                                      } else {

                                                                                        _stopTimer();
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => ImageDisplay(image: newsFeedList[pos]['image_full'])
                                                                                          ),
                                                                                        ).then((value) {
                                                                                          _startTimer();
                                                                                        });



/*
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                            builder: (context) => ImageDisplay(image: newsFeedList[pos]['image_full']),
                                                                                          ),
                                                                                        );*/
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
                                                                                                placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                                                                                errorWidget: (context, url, error) => Container(),
                                                                                              ),
                                                                                            ),
                                                                                            newsFeedList[pos]['video_capture_full'] != null && newsFeedList[pos]['video_capture_full'] != '' ? Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 40)) : Container()
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

                                                                // Like and comments code

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
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex: 1,
                                                                          child:
                                                                              Row(
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

                                                                                            onLikeButtonTapped(newsFeedList[pos]['id'], pos);
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
                                                                                newsFeedList[pos]['post_likes'].length == 0 ? '' : newsFeedList[pos]['post_likes'].length.toString(),
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                                                              )
                                                                            ],
                                                                          )),
                                                                      Container(
                                                                          width:
                                                                              0.5,
                                                                          height:
                                                                              55,
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
                                                                              showCommentDialog(newsFeedList[pos]['id'],
                                                                                  pos);
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  const EdgeInsets.all(8.0),
                                                                              child:
                                                                                  Image.asset(
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
                                                        const SizedBox(
                                                            height: 20),
                                                      ],
                                                    );
                                            }),
                                    isPagLoading
                                        ? Container(
                                            transform: Matrix4.translationValues(
                                                0.0, -10.0, 0.0),
                                            //padding: EdgeInsets.only(top: 10, bottom: 40),
                                            child: Center(
                                              child: Loader(),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    BlocBuilder(
                        bloc: dashboardBloc,
                        builder: (context, state) {
                          return HomeAppBar(
                            onTap: () {},
                            onNotificationTap: (){
                              _stopTimer();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              ).then((value) {

                                var formData = {'auth_key': AppModel.authKey};
                                dashboardBloc.fetchHomeCounts(context, formData);
                                _startTimer();
                              });
                            },
                            onChatTap: (){
                              _stopTimer();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatListScreen(),
                                ),
                              ).then((value) {
                                _startTimer();
                              });
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
                            showBackIc: false,
                          );
                        })
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<void> handleClick(String value) async {
    switch (value) {
      //Change Notification ringtone
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

  void actionPopUpItemSelected(String value, int id, int postId) async {
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

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)),
          content: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
            //  margin: const EdgeInsets.symmetric(horizontal: 20),
          /*    decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),*/
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset(ImageAssets.thumbsUpImage, width: 75, height: 75),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    elevation: 2,
                    shadowColor: AppTheme.gradient4,
                    child: Container(
                      // height: 50,

                      child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: shoutController,
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(5)),
                            //contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 19.0),
                            hintText: 'Post something',
                            hintStyle: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.gradient1),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                    side: BorderSide(
                                        color: AppTheme.gradient1)))),
                        onPressed: () {
                          if (shoutController.text.isNotEmpty) {

                            if(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                            {
                              FocusManager.instance.primaryFocus?.unfocus();

                              Navigator.pop(context);
                              _addPromise();
                            }
                            else
                              {
                                Navigator.pop(context);
                                _addPromise();
                              }
                          }
                        },
                        child: const Text("ADD SHOUTOUT",
                            style: TextStyle(fontSize: 14))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
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
      },
    );
  }

  _logOut(bool showMessage) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
    if (showMessage) {
      Toast.show('Session expired! Please login to continue',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }
  }

  _addPromise() async {
    var formData = {
      'promise': shoutController.text,
      'auth_key': AppModel.authKey
    };
    APIDialog.showAlertDialog(context, 'Please wait...');
    bool status = await dashboardBloc.addPromises(context, formData);
    if (status) {
      fetchPosts(context, null, 1);
    }
  }

  Future<void> refreshData() async {
    fetchPosts(context, null, 1);
  }
  refreshPosts() async {

    if(AppModel.newPost)
      {
        loadMoreData = true;
        _page = 1;
        selectedFilerID=null;
        var formData = {'auth_key': AppModel.authKey,'hit_count':1};
        print(formData);
        ApiBaseHelper helper = ApiBaseHelper();
        var response = await helper.postAPI('newfeed', formData, context);
        var responseJson = jsonDecode(response.body.toString());
        print(responseJson);
        newsFeedList = responseJson['show_post'];
        AppModel.setNewPost(false);
        setState(() {});
        _startTimer();
      }
    else
      {
        _startTimer();
      }

  }

  refreshTimerPosts() async {

      var formData = {'auth_key': AppModel.authKey,'hit_count':1};
      print(formData);
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI('newfeed', formData, context);
      var responseJson = jsonDecode(response.body.toString());
      print(responseJson);
      List<dynamic> latestPosts = responseJson['show_post'];

      print('TIMER STARTED****');

      if(latestPosts[0].toString()!=newsFeedList[0].toString())
        {
          newsFeedList=latestPosts;
          loadMoreData = true;
          _page = 1;
          selectedFilerID=null;
          setState(() {});
        }
  }




  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    authBloc.fetchCheckInDetails(widget.model);
    fetchFCMToken();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page++;
        if (loadMoreData) {
          setState(() {
            isPagLoading = true;
          });
          if(selectedFilerID==null)
            {
              fetchPostsPaginate(context, null, _page);
            }
          else
            {
              fetchPostsPaginate(context, selectedFilerID!, _page);
            }

        }
      }
    });

    _initializeFirebase();
    fetchBlockValues();
    fetchPosts(context, null, 1);

  }

  checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => NoInternetScreen()));
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>NoInternetScreen()));

    }
  }

  fetchBlockValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    blockList = prefs.getStringList('blockusers');
    if (blockList == null) {
      blockList = [];
    }Dio
    setState(() {});
    print('Fetching Block Data');
    print(blockList);
  }

  onLikeButtonTapped(int postID, int pos) async {
    var formData = {
      'auth_key': AppModel.authKey,
      'post_id': postID,
    };
    bool apiStatus = await dashboardBloc.likePost(context, formData);
    if (apiStatus) {
      _refreshNewsFeeds(pos, 'Like', postID);
    }
  }

  fetchPosts(BuildContext context, int? selectedID, int page) async {
    if(_myTimer!=null)
      {
        _stopTimer();
      }
    loadMoreData = true;
    _page = 1;
    selectedFilerID=null;
    setState(() {
      isLoading = true;
    });
    var formData = {
      'auth_key': AppModel.authKey,
      'category_ids': selectedID,
      'hit_count': page
    };
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('newfeed', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);

    if (responseJson['message'] == 'User not found') {
      _logOut(true);
    } else {
      var formData = {'auth_key': AppModel.authKey};
      dashboardBloc.fetchHomeCounts(context, formData);
      newsFeedList = responseJson['show_post'];
      isLoading = false;
      promisesList = responseJson['user_promise'];
      question = responseJson['random_question']['question'];
      questionID = responseJson['random_question']['id'];
      answer1 = responseJson['random_question']['answer_1'] ?? '';
      answer2 = responseJson['random_question']['answer_2'] ?? '';
      answer3 = responseJson['random_question']['answer_3'] ?? '';
      answer4 = responseJson['random_question']['answer_4'] ?? '';
      if (promisesList.isNotEmpty) {
        promiseText = promisesList[0];
      }
      filterList = responseJson['categories_post_count'];

      if (filterListAsString.length != 0) {
        filterListAsString.clear();
      }

      for (int i = 0; i < filterList.length; i++) {
        filterListAsString.add(filterList[i]['name'] +
            ' (' +
            filterList[i]['number'].toString() +
            ' Posts)');
      }

      setState(() {});
      _startTimer();
      _checkQuestionDialog();
    }
  }

  fetchPostsPaginate(BuildContext context, int? selectedID, int page) async {
    var formData = {
      'auth_key': AppModel.authKey,
      'category_ids': selectedFilerID,
      'hit_count': page
    };
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('newfeed', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    isPagLoading = false;
    if (responseJson['message'] == 'User not found') {
      _logOut(true);
    } else {
      List<dynamic> newPosts = responseJson['show_post'];
      if (newPosts.length == 0) {
        loadMoreData = false;
      } else {
        List<dynamic> combo = newsFeedList + newPosts;
        newsFeedList = combo;
      }

      setState(() {});
    }
  }

  filterPosts(BuildContext context, int? selectedID) async {
    if(_myTimer!=null)
    {
      _stopTimer();
    }
    setState(() {
      filterLoader = true;
    });
    var formData = {'auth_key': AppModel.authKey, 'category_ids': selectedID,'hit_count': 1};
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('newfeed', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    newsFeedList = responseJson['show_post'];
    filterLoader = false;
    setState(() {});
  }

  _refreshNewsFeeds(int pos, String type, int postID) async {
    if (type == 'Like') {
      newsFeedList[pos]['post_likes'].add({
        "id": 1,
        "post_id": postID,
        "liked_by_id": authBloc.state.userId,
        "created_at": "2022-08-26 12:27:26",
        "updated_at": "2022-08-26 12:27:26"
      });

      setState(() {});
    } else {
      newsFeedList[pos]['post_reply'].add({
        "id": 1,
        "post_id": postID,
        "reacted_by_id": 86,
        "emoji": "😘",
        "gif": null,
        "created_at": "2022-08-26 12:27:12",
        "updated_at": "2022-08-26 12:27:12"
      });

      setState(() {});
    }
  }

  _checkQuestionDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastDay = prefs.getInt('lastDay');
    int today = DateTime.now().day;
    if (lastDay == null || lastDay != today) {
      //Show the dialog
      prefs.setInt('lastDay', today);
      showQuestionsDialog(context);
    }
  }

  fetchCounts() async {
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('ahaDashboard', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    ahaByMe = responseJson['post_count'].toString();
    groupCount = responseJson['joined_group_count'].toString();
    friendsCount = responseJson['friend_count'].toString();
    gratitudeCount = responseJson['gratitude_count'].toString();
    notCount = int.parse(responseJson['notifications_count'].toString());
    print('Notification&&&&');
    print(notCount.toString());
    isNotLoaded = true;
    setState(() {});
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

  /*fetchSmileys() async {
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('allEmoji', context);
    var responseJson = jsonDecode(response.body.toString());
    smileyList = responseJson['data'];
    setState(() {});
  }*/

  String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
  }

  submitDailyQuestion() async {
    var formData = {
      'auth_key': AppModel.authKey,
      'question_id': questionID,
      'answer': selectedAnswer
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saveResponses', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
  }

  void showQuestionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          String dailyQuestions = 'music';
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/post_1.jpg'))),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ques: ',
                                  style: TextStyle(
                                      color: AppTheme.gradient4,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Expanded(
                                  child: Text(
                                    question,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                height: 24.0,
                                width: 24.0,
                                child: Radio(
                                    value: answer1,
                                    groupValue: dailyQuestions,
                                    onChanged: (value) {
                                      selectedAnswer = value.toString();
                                      setState(() {
                                        dailyQuestions = value.toString();
                                      });
                                    }),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  answer1,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 24.0,
                                width: 24.0,
                                child: Radio(
                                    value: answer2,
                                    groupValue: dailyQuestions,
                                    onChanged: (value) {
                                      selectedAnswer = value.toString();
                                      selectedAnswer = value.toString();
                                      setState(() {
                                        dailyQuestions = value.toString();
                                      });
                                    }),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  answer2,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          answer3 == ''
                              ? Container()
                              : Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 24.0,
                                      width: 24.0,
                                      child: Radio(
                                          value: answer3,
                                          groupValue: dailyQuestions,
                                          onChanged: (value) {
                                            selectedAnswer = value.toString();
                                            setState(() {
                                              dailyQuestions = value.toString();
                                            });
                                          }),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        answer3,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                          answer3 == '' ? Container() : SizedBox(height: 7),
                          answer4 == ''
                              ? Container()
                              : Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 24.0,
                                      width: 24.0,
                                      child: Radio(
                                          value: answer4,
                                          groupValue: dailyQuestions,
                                          onChanged: (value) {
                                            selectedAnswer = value.toString();
                                            setState(() {
                                              dailyQuestions = value.toString();
                                            });
                                          }),
                                    ),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        answer4,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                          answer4 == '' ? Container() : SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // api call
                                    submitDailyQuestion();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: 100,
                                      height: 42,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFF007BFF)),
                                      child: const Center(
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.5),
                                        ),
                                      )),
                                ),
                                SizedBox(width: 15),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: 100,
                                      height: 42,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFF6C757D)),
                                      child: const Center(
                                        child: Text(
                                          'Skip',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.5),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  addReaction(int postId, String name, int pos) async {
    var requestModel = {
      'post_id': postId,
      'auth_key': AppModel.authKey,
      'emoji': name
    };

    bool apiStatus = await dashboardBloc.addComment(context, requestModel);
    if (apiStatus) {
      _refreshNewsFeeds(pos, 'Reaction', postId);
    }
  }

  _onEmojiSelected(Emoji emoji, int postId, int pos) {
    Navigator.pop(context);
    addReaction(postId, emoji.emoji, pos);
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload:' + payload.toString());
      String type = notificationPayload!['notification_type'];
      print('TYPE');
      print(type);

      if (type == 'FollowUser') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FriendsScreen(false)));
      }
     else if (type == 'PostDelete') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostDeleteScreen()));
      }


      else if (type == 'Chat Notification') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                    int.parse(notificationPayload!['id'].toString()),
                    notificationPayload!['name'],
                    notificationPayload!['image'])));
      } else if (type == 'Group Notification') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatScreen(
                    int.parse(notificationPayload!['id'].toString()),
                    notificationPayload!['name'],
                    notificationPayload!['image'])));
      } else if (type == 'RequestAccepted') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FriendsScreen(true)));
      } else if (type == 'PostLiked' || type == 'PostReaction') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostDetailsScreen(
                    int.parse(notificationPayload!['post_id'].toString()))));
      }
      else if(type=='GroupInvite')
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupInvites()));
        }
    }
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  _initializeFirebase() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.subscribeToTopic('refresh22');

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/tr_logo');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        announcement: true,
        carPlay: true,
        criticalAlert: true,
      );
    }

  //  print('Permission');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('EVENT TRIGGERED GETINITIALMESSAGE');
        print('the message is ' + message.toString());

        print(message.data);
        print(message.data['post_id']);
        String type = message.data['notification_type'];

        if (type == 'FollowUser') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FriendsScreen(false)));
        }
        else if (type == 'PostDelete') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostDeleteScreen()));
        }


        else if (type == 'Chat Notification') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      int.parse(message.data['id'].toString()),
                      message.data['name'],
                      message.data['image'])));
        } else if (type == 'Group Notification') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupChatScreen(
                      int.parse(message.data['id'].toString()),
                      message.data['name'],
                      message.data['image'])));
        } else if (type == 'RequestAccepted') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FriendsScreen(true)));
        } else if (type == 'PostLiked' || type == 'PostReaction') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailsScreen(
                      int.parse(message.data['post_id'].toString()))));
        }
        else if(type=='GroupInvite')
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupInvites()));
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FIREBASE MESSAGE');
      print(message.data);
      RemoteNotification? notification = message.notification;
      Map<String, dynamic> data = message.data;
      if(Platform.isIOS)
      {
       playSound();
      }
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Map<String, dynamic> data = message.data;
        notificationPayload = data;
        print('NOTIFICATION ARRIVED'+notification.body.toString());
        // var messageData = FirebaseMessageObject.fromJson(message.data);

        playSound();

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              //icon: 'tr_logo',
            ),
          ),
          payload: data.toString(),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('EVENT TRIGGERED ONMESSAGEOPEN');
      print(message.data);
      // print(message.data['post_id']);

      String type = message.data['notification_type'];

      if (type == 'FollowUser') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FriendsScreen(false)));
      }
      else if (type == 'PostDelete') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostDeleteScreen()));
      }

      else if (type == 'Chat Notification') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                    int.parse(message.data['id'].toString()),
                    message.data['name'],
                    message.data['image'])));
      } else if (type == 'Group Notification') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatScreen(
                    int.parse(message.data['id'].toString()),
                    message.data['name'],
                    message.data['image'])));
      } else if (type == 'RequestAccepted') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FriendsScreen(true)));
      } else if (type == 'PostLiked' || type == 'PostReaction') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostDetailsScreen(
                    int.parse(message.data['post_id'].toString()))));
      }
      else if(type=='GroupInvite')
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupInvites()));
      }
    });
  }

  fetchFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token');
    print(token);
  }

  _closeDrawer() {
    HomePageBloc().closeDrawer();
    //ShadowBLOC().closeDrawer();
    setState(() {});
    //shadowState!.setState(() {});
  }

  playSound() async {
    final player = AudioPlayer();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uri = prefs.getString('notify');
    if (uri != null) {
      player.setUrl(// Load a URL
          uri);
      player.play();
    } else {
      FlutterRingtonePlayer.playNotification();
    }
  }

  bool isLikedPost(int pos) {
    bool likePost = false;
    if (newsFeedList[pos]['post_likes'].length != 0) {
      List<dynamic> postLikes = newsFeedList[pos]['post_likes'];

      for (int i = 0; i < postLikes.length; i++) {
        if (postLikes[i]['liked_by_id'] == authBloc.state.userId) {
          likePost = true;
          break;
        } else {
          likePost = false;
        }
      }
    }
    return likePost;
  }

  showLogOutDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Log Out",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
        Utils.logoutUser(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout?"),
      content: Text("Are you sure you want to logout?"),
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
  @override
  void dispose() {
    _myTimer?.cancel();
    super.dispose();
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


  _startTimer(){
    _myTimer = Timer.periodic(
        Duration(seconds: 12), (Timer t) => refreshTimerPosts());
  }

  _stopTimer(){
    print('TIMER STOPPED');
    _myTimer?.cancel();
  }
}
