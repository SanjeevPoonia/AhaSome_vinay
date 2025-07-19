import 'dart:convert';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/chat_screen.dart';
import 'package:aha_project_files/view/friends_screen.dart';
import 'package:aha_project_files/view/group_chat_screen.dart';
import 'package:aha_project_files/view/my_group_invites.dart';
import 'package:aha_project_files/view/post_delete_screen.dart';
import 'package:aha_project_files/view/post_details_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/rounded_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../network/bloc/dashboard_bloc.dart';
import '../network/constants.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/loader.dart';
import 'notification_audio_screen.dart';
import 'package:timeago/timeago.dart' as timeago;


class NotificationScreen extends StatefulWidget {
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationScreen> {
  List<dynamic> list = [];
  bool isLoading=false;
  bool showCheckbox=false;
  final dashboardBloc = Modular.get<DashboardCubit>();
  List<String> notificationID = [];


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  BackgroundWidget(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientAppBar(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        iconButton: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_outlined,
                              color: Colors.white),
                          onSelected: handleClick,
                          itemBuilder: (BuildContext context) {
                            return {'Settings', 'Logout'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                        showBackIc: true,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Notifications',
                              style: TextStyle(
                                  color: AppTheme.navigationRed, fontSize: 14),
                            ),

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  showCheckbox=true;
                                });
                              },
                              child: Text(
                                'Select',
                                style: TextStyle(
                                    color: AppTheme.navigationRed, fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      ),
                      SizedBox(height: 10),

                           Expanded(
                              child:
                              isLoading?
                              Loader():

                           list.length==0  ? Center(
                                child: Text(
                                  'No notifications found',
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ):





                              ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: list.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (BuildContext context, int pos) {
                                    return Column(
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          elevation: 4,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 10),
                                              decoration: BoxDecoration(
                                                  color: list[pos]['read_at']==null?AppTheme.gradient2.withOpacity(0.4):Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(15)),
                                              child: InkWell(
                                                onTap: () {

                                                if(list[pos]['read_at']==null)
                                                  {
                                                    updateNotificationCount();
                                                  }

                                                  readNotifications(
                                                      list[pos]['id'].toString());


                                                list[pos]['type'] ==
                                                    'App\\Notifications\\PostDelete'
                                                    ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PostDeleteScreen())):



                                                  list[pos]['type'] ==
                                                      'App\\Notifications\\GroupInvite'
                                                      ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GroupInvites())):




                                                  list[pos]['type'] ==
                                                      'App\\Notifications\\ChatNotification'
                                                      ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen(
                                                                int.parse(list[pos]['data']['user_id'].toString()),list[pos]['data']['name'],list[pos]['data']['user_avatar']))):

                                                  list[pos]['type'] ==
                                                      'App\\Notifications\\GroupChatNotification'
                                                      ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              GroupChatScreen(
                                                                  int.parse(list[pos]['data']['to_id'].toString()),list[pos]['data']['name'],list[pos]['data']['user_avatar']))):

                                                  list[pos]['type'] ==
                                                          'App\\Notifications\\FollowUser'
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FriendsScreen(
                                                                      false)))
                                                      : list[pos]['type'] ==
                                                              'App\\Notifications\\RequestAccepted'
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      FriendsScreen(
                                                                          true)))
                                                          : list[pos]['type'] ==
                                                                      'App\\Notifications\\PostLiked' ||
                                                                  list[pos]['type'] ==
                                                                      'App\\Notifications\\PostReaction'
                                                              ? list[pos]['data']
                                                                      .toString()
                                                                      .contains(
                                                                          'post_id')
                                                                  ? list[pos]['data']['post_id']
                                                                          is int
                                                                      ? Navigator.push(
                                                                          context, MaterialPageRoute(builder: (context) => PostDetailsScreen(list[pos]['data']['post_id'])))
                                                                      : Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsScreen(int.parse(list[pos]['data']['post_id']))))
                                                                  : print('')
                                                              : print('');


                                                  list[pos]['read_at']='Reading done';
                                                  setState(() {

                                                  });

                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 15),

                                                 RoundedImageWidget(list[pos][
                                                 'data']
                                                 [
                                                 'user_avatar']),


                                                 /*  CircleAvatar(
                                                            radius: 23.0,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    list[pos][
                                                                            'data']
                                                                        [
                                                                        'user_avatar']),
                                                          ),*/

                                                    SizedBox(width: 12),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 5,right: 3),
                                                              child: Text(
                                                                list[pos]['type'] ==
                                                                    'App\\Notifications\\GroupInvite'
                                                                    ? 'Group Notification':

                                                                list[pos]['type'] ==
                                                                    'App\\Notifications\\PostDelete'
                                                                    ? 'Post Deleted':


                                                                list[pos]['type'] ==
                                                                    'App\\Notifications\\ChatNotification'
                                                                    ? 'Chat Notification':

                                                                list[pos]['type'] ==
                                                                    'App\\Notifications\\GroupChatNotification'
                                                                    ? 'Group Notification':

                                                                list[pos]['type'] ==
                                                                        'App\\Notifications\\FollowUser'
                                                                    ? 'Follow Request'
                                                                    : list[pos]['type'] ==
                                                                            'App\\Notifications\\RequestAccepted'
                                                                        ? 'Request Accepted'
                                                                        : list[pos]['type'] ==
                                                                                'App\\Notifications\\PostLiked'
                                                                            ? 'Post liked'
                                                                            : list[pos]['type'] == 'App\\Notifications\\PostReaction'
                                                                                ? 'Reaction on post'
                                                                                : '',

                                                                // list[pos]['data']['name'],
                                                                style: TextStyle(
                                                                    color:  Colors
                                                                            .brown,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      right: 10),
                                                              child: Text(
                                                                _parseServerDate(list[
                                                                            pos][
                                                                        'created_at']
                                                                    .toString()),
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0XFF9F9F9F),
                                                                    fontSize: 11),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                       Row(
                                                         children: [
                                                           Expanded(
                                                             child: Container(
                                                               padding:
                                                               const EdgeInsets
                                                                   .only(
                                                                   top: 5,
                                                                   right: 5,
                                                                   bottom: 10),
                                                               child: Text(
                                                                 list[pos]['type'] ==
                                                                     'App\\Notifications\\GroupInvite'?
                                                                 list[pos]['data']
                                                                 ['name'] +
                                                                     ' has invited you to join a group!':
                                                                 list[pos]['type'] ==
                                                                     'App\\Notifications\\PostDelete'?
                                                                     'Your post does not match AHA policy':

                                                                 list[pos]['type'] ==
                                                                     'App\\Notifications\\ChatNotification'?
                                                                 list[pos]['data']
                                                                 ['name'] +
                                                                     ' has sent you message !':


                                                                 list[pos]['type'] ==
                                                                     'App\\Notifications\\GroupChatNotification'?
                                                                 list[pos]['data']
                                                                 ['name'] +
                                                                     ' has a new message !':


                                                                 list[pos]['type'] ==
                                                                     'App\\Notifications\\FollowUser'
                                                                     ? list[pos]['data']
                                                                 ['name'] +
                                                                     ' wants to follow you !'
                                                                     : list[pos]['type'] ==
                                                                     'App\\Notifications\\RequestAccepted'
                                                                     ? list[pos]['data']
                                                                 [
                                                                 'name'] +
                                                                     ' accepted your follow request !'
                                                                     : list[pos]['type'] ==
                                                                     'App\\Notifications\\PostLiked'
                                                                     ? list[pos]['data']
                                                                 [
                                                                 'name'] +
                                                                     ' liked your post !'
                                                                     : list[pos]['type'] ==
                                                                     'App\\Notifications\\PostReaction'
                                                                     ? list[pos]['data']['name'] +
                                                                     ' reacted on your post !'
                                                                     : '',
                                                                 style: TextStyle(
                                                                     color: Colors
                                                                         .black
                                                                         .withOpacity(
                                                                         0.5),
                                                                     fontWeight:
                                                                     FontWeight
                                                                         .w500,
                                                                     fontSize: 12),
                                                               ),
                                                             ),
                                                           ),

                                                        /*   Padding(
                                                             padding: const EdgeInsets.only(right: 10),
                                                             child: InkWell(
                                                               onTap: (){
                                                                 showDeleteDialog(context,list[pos]['id'],pos);
                                                               },
                                                               child: Icon(Icons.delete,size: 17,color: AppTheme.navigationRed),
                                                             )
                                                           ),

*/




                                                           showCheckbox?

                                                           notificationID.contains(list[pos]['id'])
                                                               ? GestureDetector(
                                                               onTap: () {
                                                                 notificationID.remove(list[pos]['id']);
                                                                 if(notificationID.length==0)
                                                                   {
                                                                     showCheckbox=false;
                                                                   }
                                                                 setState(() {});
                                                               },
                                                               child: Padding(
                                                                 padding: const EdgeInsets.all(4.0),
                                                                 child: const Icon(Icons.check_box, size: 20, color: AppTheme.navigationRed),
                                                               ))
                                                               : InkWell(
                                                               onTap: () {
                                                                 notificationID.add(list[pos]['id']);
                                                                 setState(() {});
                                                               },
                                                               child:  Padding(
                                                                 padding: const EdgeInsets.all(4.0),
                                                                 child: Icon(Icons.check_box_outline_blank_sharp, size: 20),
                                                               )):Container(),


                                                           SizedBox(width: 5)


                                                         ],
                                                       )
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    );
                                  })),


                      notificationID.length != 0
                          ? Center(
                          child: InkWell(
                            onTap: () {


                              showDeleteDialog(context);

                            },
                            child: Container(
                              height: 44,
                              width: 90,
                              margin: EdgeInsets.only(bottom: 5,top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red),
                              child: Center(
                                child: Text('Delete',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13)),
                              ),
                            ),
                          ))
                          : Container()

                    ],
                  )
                ],
              ))),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotifications();
  }

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
      case 'Settings':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationAudio()));
        break;
    }
  }

  fetchNotifications() async {
  setState(() {
    isLoading=true;
  });
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('allnotifications', formData, context);
    isLoading=false;
    var responseJson = jsonDecode(response.body.toString());
    list = responseJson['notifications'];
    print(responseJson);
    setState(() {});
  }

  readNotifications(String id) async {
    var formData = {'auth_key': AppModel.authKey, 'notfication_id': id};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('markedAsRead', formData, context);
    print(response.toString());

  }

  String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
    /*DateTime dateTime = DateTime.parse(date).toLocal();
    String timeStamp = timeago.format(dateTime).toString();
    return timeStamp;*/
  }
  deleteNotification() async {
    APIDialog.showAlertDialog(context, 'Deleting notifications...');
    var formData = {'auth_key': AppModel.authKey, 'notification_id': notificationID};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('deleteNotification', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());

    showCheckbox=false;
    notificationID.clear();
    AppModel.setNotificationDelete(true);
    fetchNotifications();
    print(responseJson);
  }
  updateNotificationCount() {
    print('called');
    int? currentCount = dashboardBloc.state.notCount;
    currentCount = currentCount! - 1;
    dashboardBloc.updateNotificationCount(currentCount);
  }
  showDeleteDialog(BuildContext context) {
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
        deleteNotification();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete notification"),
      content:
      notificationID.length>1?

      Text("Are you sure you want to delete these notifications ?"):

      Text("Are you sure you want to delete this notification ?"),
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

