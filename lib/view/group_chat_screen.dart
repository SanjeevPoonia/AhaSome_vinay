import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/group_detail_screen.dart';
import 'package:aha_project_files/view/image_display.dart';
import 'package:aha_project_files/view/report_screen.dart';
import 'package:aha_project_files/view/webview_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:al_downloader/al_downloader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as Diot;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'package:file_picker/file_picker.dart';

import '../utils/utils.dart';
import '../widgets/chat_video_widget.dart';
import '../widgets/full_image.dart';
import '../widgets/list_video_widget.dart';
import '../widgets/loader.dart';
import '../widgets/rounded_image_widget.dart';
import '../widgets/small_loader.dart';
import 'full_video_screen.dart';

import 'image_display_local.dart';
import 'local_video_screen.dart';

class GroupChatScreen extends StatefulWidget {
  final int id;
  final String groupName;
  final String groupImageUrl;

  GroupChatScreen(this.id, this.groupName, this.groupImageUrl);

  GroupChatState createState() => GroupChatState();
}
class GroupChatState extends State<GroupChatScreen> {
  File? selectedFile;
  String? imageUrl;
  int scrollPosition = 0;
  int _page = 1;
  bool loadMoreData = true;
  bool localVideo = false;
  bool isPagLoading = false;
  double uploadingProgress=0.0;
  int uploadingIndex = 999999;
  bool isLoading = false;
  String chatMessage = '';
  final picker = ImagePicker();
  GlobalKey gifBtnKey = GlobalKey();
  bool? isDisplaySticker;
  bool localMessage = false;
  int uploadingPosition = 9999;
  Timer? _myTimer;
  int downloadingPosition = 9999;
  int messageIndex = 99999;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  List<dynamic> chatList = [];
  List<dynamic> chatRefreshList = [];
  int uploadPercentage = 0;
  double downloadingProgress = 0.0;
  bool fileUploading = false;
  bool fileDownloading = false;
  bool emojiShowing = false;
  final authBloc = Modular.get<AuthCubit>();
  String currentDate = '';
  List<String>? blockList;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
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
                          Container(
                            height: 63,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            color: const Color(0xFFFDD217),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (WidgetsBinding
                                        .instance.window.viewInsets.bottom >
                                        0.0) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    } else if (emojiShowing) {
                                      setState(() {
                                        emojiShowing = !emojiShowing;
                                      });
                                    } else {
                                      _myTimer?.cancel();
                                      Navigator.pop(context, 'restart timer');
                                    }
                                  },
                                  child: Image.asset('assets/back_ic.png',
                                      width: 20, height: 20),
                                ),
                                const SizedBox(width: 15),

                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupDetail(widget.id)));
                                  },
                                  child:   RoundedImageWidget(widget.groupImageUrl),
                                ),

                                /* Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Colors.grey,
                                          spreadRadius: 3)
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 22.0,
                                    backgroundImage: NetworkImage(
                                            widget.imageUrl),
                                  ),
                                ),*/
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupDetail(widget.id)));



                                  /*  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendProfile(widget.id)));*/
                                  },
                                  child: Text(
                                    widget.groupName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.white),
                                  onSelected: handleClickReport,
                                  itemBuilder: (BuildContext context) {
                                    return {'Logout'}
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(
                                          choice,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            ),
                          ),

                          isPagLoading
                              ? Container(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: SmallLoader(Colors.blue),
                            ),
                          )
                              : Container(),

                          /*  Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                currentDate,
                                style: TextStyle(
                                  color: Color(0xFFDD2E44),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),*/

                          //const SizedBox(height: 10),

                          Expanded(
                              child: isLoading
                                  ? Loader()
                                  : Stack(
                                children: [
                                  ListView.builder(
                                      addAutomaticKeepAlives: false,
                                      itemCount: chatList.length,
                                      reverse: true,
                                      physics: const BouncingScrollPhysics(),
                                      cacheExtent: 1000,
                                      padding: const EdgeInsets.only(top: 32),
                                      scrollDirection: Axis.vertical,
                                      controller: listScrollController,
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Column(
                                          /* crossAxisAlignment:
                                                    CrossAxisAlignment.start,*/
                                          children: [
                                            chatList[pos]['from_id'] !=
                                                authBloc.state.userId
                                                ?

                                            //receiver layout
                                            Container(
                                              child: Column(
                                                /*  crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,*/
                                                children: [
                                                  chatList[pos]
                                                  ['body']
                                                      .toString()
                                                      .isNotEmpty
                                                      ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5,
                                                        right:
                                                        40),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child:
                                                          ChatBubble(
                                                            clipper:
                                                            ChatBubbleClipper1(type: BubbleType.receiverBubble),
                                                            margin:
                                                            const EdgeInsets.only(top: 8, left: 10),
                                                            alignment:
                                                            Alignment.topLeft,
                                                            backGroundColor:
                                                            const Color(0xFFDBF4B4),
                                                            child:
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  chatList[pos]['sender']['first_name']+' '+chatList[pos]['sender']['last_name'],
                                                                  style: const TextStyle(color: AppTheme.gradient1, fontSize: 13, fontWeight: FontWeight.w500),
                                                                ),

                                                                Text(
                                                                  HtmlCharacterEntities.decode(chatList[pos]['body']),
                                                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                                                                ),
                                                                Text(
                                                                  _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                  style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w300),
                                                                  textAlign: TextAlign.right,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        // Spacer()
                                                      ],
                                                    ),
                                                  )
                                                      : Container(),
                                                  const SizedBox(
                                                      height: 10),
                                                  chatList[pos][
                                                  'attachment'] !=
                                                      null
                                                      ? Row(
                                                    children: [
                                                      const SizedBox(
                                                        width:
                                                        15,
                                                      ),
                                                      lookupMimeType(
                                                          _returnUrlFile(
                                                            chatList[pos]
                                                            [
                                                            'attachment'],
                                                          )).toString().startsWith(
                                                          'video/')
                                                          ? Material(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        clipBehavior: Clip.hardEdge,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => FullVideoScreen(
                                                                        _returnUrlFile(
                                                                          chatList[pos]['attachment'],
                                                                        ),
                                                                        _returnUrl(
                                                                          chatList[pos]['attachment'],
                                                                        ))));
                                                          },
                                                          child: Container(
                                                            color: Color(0xFFEEEDE7).withOpacity(0.4),
                                                            padding:EdgeInsets.all(2),
                                                            child: Column(
                                                              crossAxisAlignment:CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  width:130,
                                                                  padding:EdgeInsets.only(left:5,right:3,top:2,bottom:2),
                                                                  child: Text(
                                                                    chatList[pos]['sender']['first_name']+' '+chatList[pos]['sender']['last_name'],
                                                                    style: const TextStyle(color: AppTheme.gradient1, fontSize: 13, fontWeight: FontWeight.w500),
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      // remove comments
                                                                   /*   decoration:BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                      ),*/
                                                                      width: 130.0,
                                                                      height: 130.0,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            width: 130.0,
                                                                            height: 130.0,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.cover,
                                                                                imageUrl: _returnUrl(
                                                                                  chatList[pos]['attachment'],
                                                                                ),
                                                                                placeholder: (context, url) => Container(
                                                                                  child: CircularProgressIndicator(
                                                                                    valueColor: AlwaysStoppedAnimation(AppTheme.gradient4),
                                                                                  ),
                                                                                  width: 130.0,
                                                                                  height: 130.0,
                                                                                  padding: EdgeInsets.all(55.0),
                                                                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
                                                                                ),
                                                                                errorWidget: (context, url, error) => Container(),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Center(
                                                                            child: Icon(Icons.play_arrow, color: Colors.white),
                                                                          ),


                                                                          Align(
                                                                            alignment: Alignment.bottomRight,
                                                                            child:  Padding(
                                                                              padding: const EdgeInsets.only(right: 5,bottom: 5),
                                                                              child: Text(
                                                                                _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300),
                                                                              ),
                                                                            ),
                                                                          )



                                                                        ],
                                                                      ),
                                                                    ),
                                                                    fileDownloading && downloadingPosition == pos
                                                                        ? SizedBox(
                                                                      width: 130.0,
                                                                      height: 130.0,
                                                                      child: Center(
                                                                        child: Container(
                                                                          width: 60,
                                                                          height: 60,
                                                                          padding: const EdgeInsets.all(2),
                                                                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                          child: CircularPercentIndicator(
                                                                            radius: 28,
                                                                            lineWidth: 5.0,
                                                                            percent: downloadingProgress,
                                                                            center: Text(
                                                                              (downloadingProgress * 100).round().toString() + " %",
                                                                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            progressColor: Colors.green,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                        : Container(),
                                                                  ],
                                                                ),

                                                              ],
                                                            ),
                                                          )
                                                        ),
                                                      )
                                                          : lookupMimeType(_returnUrl(
                                                        chatList[pos]['attachment'],
                                                      )).toString().startsWith('image/')
                                                          ? GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ImageDisplay(
                                                                        image: _returnUrlFile(
                                                                          chatList[pos]['attachment'],
                                                                        ))));
                                                          },
                                                          child: Container(
                                                          /*  width: 130.0,
                                                            height: 130.0,*/

                                                              padding:EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                              color: Color(0xFFEEEDE7).withOpacity(0.8),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    width:130,
                                                                    padding:EdgeInsets.only(left:5,right:3,top:2,bottom:2),
                                                                    child: Text(
                                                                      chatList[pos]['sender']['first_name']+' '+chatList[pos]['sender']['last_name'],
                                                                      style: const TextStyle(color: AppTheme.gradient1, fontSize: 13, fontWeight: FontWeight.w500),
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      width: 130.0,
                                                                     height: 130.0,
                                                                    child: Stack(
                                                                      children: [
                                                                        Material(
                                                                          child: CachedNetworkImage(
                                                                            placeholder: (context, url) => Container(
                                                                              child: CircularProgressIndicator(
                                                                                valueColor: AlwaysStoppedAnimation(AppTheme.gradient4),
                                                                              ),
                                                                              width: 130.0,
                                                                              height: 130.0,
                                                                              padding: EdgeInsets.all(55.0),
                                                                              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
                                                                            ),
                                                                            errorWidget: (context, url, error) => Material(
                                                                              child: Container(),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              clipBehavior: Clip.hardEdge,
                                                                            ),
                                                                            imageUrl: _returnUrl(chatList[pos]['attachment']),
                                                                            width: 130.0,
                                                                            height: 130.0,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          clipBehavior: Clip.hardEdge,
                                                                        ),
                                                                        fileDownloading && downloadingPosition == pos
                                                                            ? SizedBox(
                                                                          width: 130.0,
                                                                          height: 130.0,
                                                                          child: Center(
                                                                            child: Container(
                                                                              width: 60,
                                                                              height: 60,
                                                                              padding: EdgeInsets.all(2),
                                                                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                              child: CircularPercentIndicator(
                                                                                radius: 28,
                                                                                lineWidth: 5.0,
                                                                                percent: downloadingProgress,
                                                                                center: Text(
                                                                                  (downloadingProgress * 100).round().toString() + " %",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                                ),
                                                                                progressColor: Colors.green,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : Container(),
                                                                        Align(
                                                                          alignment: Alignment.bottomRight,
                                                                          child:  Padding(
                                                                            padding: const EdgeInsets.only(right: 5,bottom: 5),
                                                                            child: Text(
                                                                              _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),


                                                                ],
                                                            )
                                                          )

                                                        /*  Container(
                                                            width: 120,
                                                            height: 150,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8.0),
                                                              child: Image.network(AppConstant
                                                                  .postImageURL +
                                                                  _returnUrl(chatList[
                                                                  pos]
                                                                  [
                                                                  'attachment'])),
                                                            )),*/
                                                      )
                                                          : Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap:(){

                                                              _launchUrl(_returnUrl(chatList[pos]['attachment'].toString()));

                                                            },
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width*0.5,
                                                              decoration: BoxDecoration(color: Color(0xFFDBF4B4), borderRadius: BorderRadius.circular(10)),
                                                              padding: EdgeInsets.all(10),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(height: 8),
                                                                  Row(
                                                                    children: [
                                                                      Icon(Icons.file_copy_outlined, size: 22),
                                                                      SizedBox(width: 5),
                                                                      Text(_returnUrl(chatList[pos]['attachment'].toString()).split('.').last + ' attachment', style: TextStyle(color: Color(0xff867983), fontSize: 12, fontWeight: FontWeight.w500))
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                    style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          fileDownloading && downloadingPosition == pos
                                                              ? SizedBox(
                                                            child: Center(
                                                              child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                padding: EdgeInsets.all(2),
                                                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                child: CircularPercentIndicator(
                                                                  radius: 17,
                                                                  lineWidth: 5.0,
                                                                  percent: downloadingProgress,
                                                                  center: Text(
                                                                    (downloadingProgress * 100).round().toString() + " %",
                                                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                  ),
                                                                  progressColor: Colors.green,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : Container(),
                                                        ],
                                                      ),

                                                      /* const SizedBox(
                                                                            width:
                                                                                15),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            chatList
                                                                                .removeAt(pos);

                                                                            setState(
                                                                                () {});
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                40,
                                                                            padding:
                                                                                const EdgeInsets.all(15),
                                                                            height:
                                                                                40,
                                                                            decoration: const BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: Color(0xFFC42562)),
                                                                            child: Image.asset(
                                                                                'assets/cross_ic.png',
                                                                                width: 25,
                                                                                height: 25),
                                                                          ),
                                                                        ),*/
                                                      const SizedBox(
                                                          width:
                                                          15),
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          print(
                                                              'Downloading Started');
                                                          _downloadFile(
                                                              _returnUrl(chatList[pos]['attachment']),
                                                              pos);
                                                        },
                                                        child:
                                                        Container(
                                                          width:
                                                          40,
                                                          padding:
                                                          const EdgeInsets.all(15),
                                                          height:
                                                          40,
                                                          decoration: const BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Color(0xFF42BFB7)),
                                                          child: Image.asset(
                                                              'assets/arrow_down.png',
                                                              width: 25,
                                                              height: 25),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                      : Container(),
                                                ],
                                              ),
                                            )
                                                :

                                            //my chat layout

                                            //*********************************************************************************//

                                            Container(
                                              child: Column(
                                                //mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  chatList[pos]
                                                  ['body']
                                                      .toString()
                                                      .isNotEmpty
                                                      ? Container(
                                                    margin: EdgeInsets.only(
                                                        right:
                                                        5,
                                                        left:
                                                        40),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child:
                                                          ChatBubble(
                                                            clipper:
                                                            ChatBubbleClipper1(type: BubbleType.sendBubble),
                                                            alignment:
                                                            Alignment.topRight,
                                                            margin:
                                                            EdgeInsets.only(top: 8, right: 10),
                                                            backGroundColor:
                                                            Color(0xFFE7F4FA),
                                                            child:
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  HtmlCharacterEntities.decode(chatList[pos]['body']),
                                                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
                                                                ),
                                                                Container(
                                                                  width: 127,
                                                                  child: Row(
                                                                    children: [
                                                                      Spacer(),
                                                                      localMessage && messageIndex == pos
                                                                          ? Container()
                                                                          : GestureDetector(
                                                                          onTap: () {
                                                                            showDeleteDialog(context, chatList[pos]['id'].toString(), pos);
                                                                          },
                                                                          child: Icon(Icons.delete, size: 15)),
                                                                      SizedBox(width: 4),
                                                                      Text(
                                                                        _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                        style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w300),
                                                                      ),
                                                                      Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 2),
                                                                          child: localMessage && messageIndex == pos
                                                                              ? Image.asset('assets/clock_ic.png', color: Colors.grey, width: 12, height: 12)
                                                                              : chatList[pos]['seen'] == 0
                                                                              ? Icon(Icons.done, size: 15)
                                                                              : Icon(Icons.done_all_outlined, size: 15))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                      : Container(),
                                                  const SizedBox(
                                                      height: 10),
                                                  chatList[pos][
                                                  'attachment'] !=
                                                      null
                                                      ? chatList[pos]['attachment'] ==
                                                      'file' /*&&
                                                      chatList[pos]['sender'] ==
                                                          'progress'*/
                                                      ? Row(
                                                    children: [
                                                      const Spacer(),
                                                      localVideo && uploadingIndex == pos
                                                          ? Container()
                                                          : InkWell(
                                                        onTap: () {
                                                          /*  print('Downloading Started Mine Chat');
                                                                                _downloadFile(_returnUrl(chatList[pos]['attachment']), pos);*/
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          padding: const EdgeInsets.all(15),
                                                          height: 40,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF42BFB7)),
                                                          child: Image.asset('assets/arrow_down.png', width: 25, height: 25),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: 15),
                                                      InkWell(
                                                        onTap:
                                                            () {
                                                          showDeleteDialog(context, chatList[pos]['id'].toString(), pos);
                                                        },
                                                        child:
                                                        Container(
                                                          width: 40,
                                                          padding: const EdgeInsets.all(15),
                                                          height: 40,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFC42562)),
                                                          child: Image.asset('assets/cross_ic.png', width: 25, height: 25),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 10),
                                                      lookupMimeType(chatList[pos]['updated_at']).toString().startsWith('video/')
                                                          ? Stack(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LocalVideoScreen(chatList[pos]['updated_at'])));
                                                            },
                                                            child: Container(
                                                              // remove comments
                                                                width: 130.0,
                                                                height: 130.0,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: Colors.black87,
                                                                ),
                                                                margin: const EdgeInsets.only(right: 15),
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      width: 130.0,
                                                                      height: 130.0,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                      child: VideoWidget(
                                                                        play: false,
                                                                        iconSize: 22,
                                                                        url: chatList[pos]['updated_at'],
                                                                        loaderColor: Colors.transparent,
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child: Icon(Icons.play_arrow, color: Colors.white),
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.bottomRight,
                                                                      child: Row(
                                                                        children: [
                                                                          Spacer(),

                                                                          //DateTime.now().toUtc().toString()
                                                                          Text(
                                                                            _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300),
                                                                          ),
                                                                          SizedBox(width: 5),
                                                                          Padding(padding: EdgeInsets.only(right: 5, bottom: 5), child:
                                                                          fileUploading && uploadingIndex == pos?
                                                                          Image.asset('assets/clock_ic.png', color: Colors.white, width: 12, height: 12):

                                                                          chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 15,color: Colors.white) : Icon(Icons.done_all_outlined, size: 15,color: Colors.white)),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                )),
                                                          ),

                                                          fileUploading && uploadingIndex == pos
                                                              ? SizedBox(
                                                            width: 130.0,
                                                            height: 130.0,
                                                            child: Center(
                                                              child:

                                                              Container(
                                                                width: 48,
                                                                height: 48,
                                                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                child: CircularPercentIndicator(
                                                                  radius: 23,
                                                                  lineWidth: 5.0,
                                                                  percent: uploadingProgress/100,
                                                                  center: Text(
                                                                    uploadingProgress.round().toString()+" %",
                                                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                  ),
                                                                  progressColor: Colors.green,
                                                                ),
                                                              ),



                                                              /*Container(
                                                                                                  width: 40,
                                                                                                  height: 40,
                                                                                                  padding: EdgeInsets.all(10),
                                                                                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                                                  child: CircularProgressIndicator(
                                                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                                  ),
                                                                                                ),*/
                                                            ),
                                                          )
                                                              : Container(),
                                                          //Video Loader
                                                        ],
                                                      )
                                                          : lookupMimeType(chatList[pos]['updated_at']).toString().startsWith('image/')
                                                          ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDisplayLocal(image: chatList[pos]['updated_at'])));
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(right: 15),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          width: 130.0,
                                                          height: 130.0,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                width: 130.0,
                                                                height: 130.0,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  image: DecorationImage(
                                                                    image: FileImage(File(chatList[pos]['updated_at'])),
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),

                                                              Align(
                                                                alignment: Alignment.bottomRight,
                                                                child: Row(
                                                                  children: [
                                                                    Spacer(),
                                                                    Text(
                                                                      _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300),
                                                                    ),
                                                                    SizedBox(width: 5),

                                                                    Padding(padding: EdgeInsets.only(right: 10, bottom: 5), child: localVideo && uploadingIndex == pos ? Image.asset('assets/clock_ic.png', color: Colors.white, width: 12, height: 12) : Icon(Icons.done, size: 15, color: Colors.white)),
                                                                  ],
                                                                ),
                                                              ),

                                                              fileUploading && uploadingIndex == pos
                                                                  ? SizedBox(
                                                                width: 130.0,
                                                                height: 130.0,
                                                                child: Center(
                                                                  child: Container(
                                                                    width: 48,
                                                                    height: 48,
                                                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                    child: CircularPercentIndicator(
                                                                      radius: 23,
                                                                      lineWidth: 5.0,
                                                                      percent: uploadingProgress/100,
                                                                      center: Text(
                                                                        uploadingProgress.round().toString()+" %",
                                                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                      ),
                                                                      progressColor: Colors.green,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(),

                                                              // Image Loader
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                          : Container(
                                                        width: MediaQuery.of(context).size.width*0.5,
                                                        margin: EdgeInsets.only(right: 20),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(context).size.width*0.5,
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(color: Color(0xFFE7F4FA), borderRadius: BorderRadius.circular(10)),
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Column(
                                                                      children: [
                                                                        SizedBox(height: 8),
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.file_copy_outlined, size: 22),
                                                                            SizedBox(width: 5),
                                                                            selectedFile != null ? Text(selectedFile!.path.toString().split('.').last + ' attachment', style: TextStyle(color: Color(0xff867983), fontSize: 12, fontWeight: FontWeight.w500)) : Text('attachment', style: TextStyle(color: Color(0xff867983), fontSize: 12, fontWeight: FontWeight.w500))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                              style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w300),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                            chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 15) : Icon(Icons.done_all_outlined, size: 15)
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  fileUploading && uploadingIndex == pos
                                                                      ?
                                                                  SizedBox(
                                                                    child: Center(
                                                                      child: Container(
                                                                        width: 48,
                                                                        height: 48,
                                                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                        child: CircularPercentIndicator(
                                                                          radius: 23,
                                                                          lineWidth: 5.0,
                                                                          percent: uploadingProgress/100,
                                                                          center: Text(
                                                                            uploadingProgress.round().toString()+" %",
                                                                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                          ),
                                                                          progressColor: Colors.green,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ):Container()
                                                                ],
                                                              ),
                                                            ),
                                                           /* fileUploading && uploadingIndex == pos
                                                                ?
                                                            SizedBox(
                                                              child: Center(
                                                                child: Container(
                                                                  width: 48,
                                                                  height: 48,
                                                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                  child: CircularPercentIndicator(
                                                                    radius: 23,
                                                                    lineWidth: 5.0,
                                                                    percent: uploadingProgress/100,
                                                                    center: Text(
                                                                      uploadingProgress.round().toString()+" %",
                                                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                    ),
                                                                    progressColor: Colors.green,
                                                                  ),
                                                                ),
                                                              ),
                                                            ):Container()*/
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                  /* : chatList[pos]['attachment'] ==
                                                                              'file'
                                                                          ? Row(
                                                                              children: [
                                                                                const Spacer(),
                                                                                localVideo && uploadingIndex == pos
                                                                                    ? Container()
                                                                                    : InkWell(
                                                                                        onTap: () {
                                                                                          *//*  print('Downloading Started Mine Chat');
                                                                                _downloadFile(_returnUrl(chatList[pos]['attachment']), pos);*//*
                                                                                        },
                                                                                        child: Container(
                                                                                          width: 40,
                                                                                          padding: const EdgeInsets.all(15),
                                                                                          height: 40,
                                                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF42BFB7)),
                                                                                          child: Image.asset('assets/arrow_down.png', width: 25, height: 25),
                                                                                        ),
                                                                                      ),
                                                                                SizedBox(width: 15),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    showDeleteDialog(context, chatList[pos]['id'].toString(), pos);
                                                                                  },
                                                                                  child: Container(
                                                                                    width: 40,
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    height: 40,
                                                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFC42562)),
                                                                                    child: Image.asset('assets/cross_ic.png', width: 25, height: 25),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(width: 10),
                                                                                lookupMimeType(chatList[pos]['updated_at']).toString().startsWith('video/')
                                                                                    ? Stack(
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => LocalVideoScreen(chatList[pos]['updated_at'])));
                                                                                            },
                                                                                            child: Container(
                                                                                                // remove comments
                                                                                                width: 130.0,
                                                                                                height: 130.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                                  color: Colors.black87,
                                                                                                ),
                                                                                                margin: const EdgeInsets.only(right: 15),
                                                                                                child: Stack(
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      width: 130.0,
                                                                                                      height: 130.0,
                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                                                      child: VideoWidget(
                                                                                                        play: false,
                                                                                                        iconSize: 22,
                                                                                                        url: chatList[pos]['updated_at'],
                                                                                                        loaderColor: Colors.transparent,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Icon(Icons.play_arrow, color: Colors.white),
                                                                                                    ),
                                                                                                    Align(
                                                                                                      alignment: Alignment.bottomRight,
                                                                                                      child: Padding(padding: EdgeInsets.only(right: 10, bottom: 5), child: chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 15,color: Colors.white) : Icon(Icons.done_all_outlined, size: 15,color: Colors.white)),
                                                                                                    )
                                                                                                  ],
                                                                                                )),
                                                                                          ),

                                                                                          fileUploading && uploadingIndex == pos
                                                                                              ? SizedBox(
                                                                                                  width: 130.0,
                                                                                                  height: 130.0,
                                                                                                  child: Center(
                                                                                                    child: Container(
                                                                                                      width: 40,
                                                                                                      height: 40,
                                                                                                      padding: EdgeInsets.all(10),
                                                                                                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                                                      child: CircularProgressIndicator(
                                                                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                              : Container(),
                                                                                          //Video Loader
                                                                                        ],
                                                                                      )
                                                                                    : lookupMimeType(chatList[pos]['updated_at']).toString().startsWith('image/')
                                                                                        ? GestureDetector(
                                                                                            onTap: () {
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDisplayLocal(image: chatList[pos]['updated_at'])));
                                                                                            },
                                                                                            child: Container(
                                                                                              margin: EdgeInsets.only(right: 15),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                              ),
                                                                                              width: 130.0,
                                                                                              height: 130.0,
                                                                                              child: Stack(
                                                                                                children: [
                                                                                                  Container(
                                                                                                    width: 130.0,
                                                                                                    height: 130.0,
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                                      image: DecorationImage(
                                                                                                        image: FileImage(File(chatList[pos]['updated_at'])),
                                                                                                        fit: BoxFit.fill,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),

                                                                                                  Align(
                                                                                                    alignment: Alignment.bottomRight,
                                                                                                    child: Padding(padding: EdgeInsets.only(right: 10, bottom: 5), child: chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 15,color: Colors.white) : Icon(Icons.done_all_outlined, size: 15,color: Colors.white)),
                                                                                                  ),

                                                                                                  fileUploading && uploadingIndex == pos
                                                                                                      ? SizedBox(
                                                                                                          width: 130.0,
                                                                                                          height: 130.0,
                                                                                                          child: Center(
                                                                                                            child: Container(
                                                                                                              width: 40,
                                                                                                              height: 40,
                                                                                                              padding: EdgeInsets.all(10),
                                                                                                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                                                              child: CircularProgressIndicator(
                                                                                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      : Container(),

                                                                                                  // Image Loader
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : InkWell(
                                                                                  onTap:(){
                                                                                    //_launchUrl(chatList[pos]['updated_at'].toString());
                                                                                    OpenFile.open(chatList[pos]['updated_at'].toString().trim());
                                                                                  },
                                                                                          child: Container(
                                                                                              height: 65,
                                                                                              margin: EdgeInsets.only(right: 20),
                                                                                              child: Stack(
                                                                                                children: [
                                                                                                  Container(
                                                                                                    decoration: BoxDecoration(color: Color(0xFFE7F4FA), borderRadius: BorderRadius.circular(10)),
                                                                                                    padding: EdgeInsets.all(10),
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        SizedBox(height: 8),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Icon(Icons.file_copy_outlined, size: 22),
                                                                                                            SizedBox(width: 5),
                                                                                                             Text(chatList[pos]['updated_at'].toString().split('.').last + ' attachment', style: TextStyle(color: Color(0xff867983), fontSize: 12, fontWeight: FontWeight.w500))
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                                                              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w300),
                                                                                                            ),
                                                                                                            SizedBox(width: 5),
                                                                                                            chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 15) : Icon(Icons.done_all_outlined, size: 15)
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                 *//* SizedBox(
                                                                                                    child: Center(
                                                                                                      child: Container(
                                                                                                        width: 40,
                                                                                                        height: 40,
                                                                                                        padding: EdgeInsets.all(10),
                                                                                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                                                        child: CircularProgressIndicator(
                                                                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  )*//*
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                        )
                                                                              ],
                                                                            )*/
                                                      : Row(
                                                    children: [
                                                      const Spacer(),
                                                      InkWell(
                                                        onTap: () {
                                                          _downloadFile(_returnUrl(chatList[pos]['attachment']), pos);
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          padding: const EdgeInsets.all(15),
                                                          height: 40,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF42BFB7)),
                                                          child: Image.asset('assets/arrow_down.png', width: 25, height: 25),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      InkWell(
                                                        onTap: () {
                                                          showDeleteDialog(context, chatList[pos]['id'].toString(), pos);
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          padding: const EdgeInsets.all(15),
                                                          height: 40,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFC42562)),
                                                          child: Image.asset('assets/cross_ic.png', width: 25, height: 25),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      lookupMimeType(_returnUrlFile(
                                                        chatList[pos]['attachment'],
                                                      )).toString().startsWith('video/')
                                                          ? Stack(
                                                        children: [
                                                          Material(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            clipBehavior: Clip.hardEdge,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => FullVideoScreen(
                                                                            _returnUrlFile(
                                                                              chatList[pos]['attachment'],
                                                                            ),
                                                                            _returnUrl(
                                                                              chatList[pos]['attachment'],
                                                                            ))));
                                                              },
                                                              child: Container(
                                                                // remove comments
                                                                width: 130.0,
                                                                height: 130.0,
                                                                child: Stack(
                                                                  children: [
                                                                    Container(
                                                                      width: 130.0,
                                                                      height: 130.0,
                                                                      child: CachedNetworkImage(
                                                                        fit: BoxFit.cover,
                                                                        imageUrl: _returnUrl(
                                                                          chatList[pos]['attachment'],
                                                                        ),
                                                                        placeholder: (context, url) => Container(
                                                                          child: CircularProgressIndicator(
                                                                            valueColor: AlwaysStoppedAnimation(AppTheme.gradient4),
                                                                          ),
                                                                          width: 130.0,
                                                                          height: 130.0,
                                                                          padding: EdgeInsets.all(55.0),
                                                                          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
                                                                        ),
                                                                        errorWidget: (context, url, error) => Container(),
                                                                      ),
                                                                      /*  CachedVideoPreviewWidget(
                                                                                                        path: _returnUrl(
                                                                                                          chatList[pos]['attachment'],
                                                                                                        ),
                                                                                                        type: SourceType.remote,
                                                                                                        remoteImageBuilder: (BuildContext context, url) =>

                                                                                                            Image.network(url,
                                                                                                              fit: BoxFit.fill,
                                                                                                            ),

                                                                                                    ),*/
                                                                    ),
                                                                    Center(
                                                                      child: Icon(Icons.play_arrow, color: Colors.white, size: 25),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // CODE ZIP
                                                          Container(
                                                            width: 130.0,
                                                            height: 130.0,
                                                            child: Align(
                                                                alignment: Alignment.bottomRight,
                                                                child: Row(
                                                                  children: [

                                                                    Spacer(),

                                                                    Text(
                                                                      _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),

                                                                    ),

                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                                                                      child: chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 17, color: Colors.white) : Icon(Icons.done_all, size: 17, color: Colors.white),
                                                                    ),
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                          fileDownloading && downloadingPosition == pos
                                                              ? SizedBox(
                                                            width: 130.0,
                                                            height: 130.0,
                                                            child: Center(
                                                              child: Container(
                                                                width: 60,
                                                                height: 60,
                                                                padding: EdgeInsets.all(2),
                                                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                child: CircularPercentIndicator(
                                                                  radius: 28,
                                                                  lineWidth: 5.0,
                                                                  percent: downloadingProgress,
                                                                  center: Text(
                                                                    (downloadingProgress * 100).round().toString() + " %",
                                                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                  ),
                                                                  progressColor: Colors.green,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : Container(),
                                                        ],
                                                      )
                                                          : lookupMimeType(_returnUrl(
                                                        chatList[pos]['attachment'],
                                                      )).toString().startsWith('image/')
                                                          ? Stack(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => ImageDisplay(
                                                                          image: _returnUrlFile(
                                                                            chatList[pos]['attachment'],
                                                                          ))));
                                                            },
                                                            child: Material(
                                                              child: CachedNetworkImage(
                                                                placeholder: (context, url) => Container(
                                                                  child: CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation(AppTheme.gradient4),
                                                                  ),
                                                                  width: 130.0,
                                                                  height: 130.0,
                                                                  padding: EdgeInsets.all(55.0),
                                                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
                                                                ),
                                                                errorWidget: (context, url, error) => Material(
                                                                  child: Container(),
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  clipBehavior: Clip.hardEdge,
                                                                ),
                                                                imageUrl: _returnUrl(chatList[pos]['attachment']),
                                                                width: 130.0,
                                                                height: 130.0,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              borderRadius: BorderRadius.circular(8.0),
                                                              clipBehavior: Clip.hardEdge,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 130.0,
                                                            height: 130.0,
                                                            padding: EdgeInsets.only(right: 5, bottom: 5),
                                                            child:

                                                            Align(
                                                                alignment: Alignment.bottomRight,
                                                                child: Row(
                                                                  children: [

                                                                    Spacer(),

                                                                    Text(
                                                                      _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),

                                                                    ),

                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                                                                      child: chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 17, color: Colors.white) : Icon(Icons.done_all, size: 17, color: Colors.white),
                                                                    ),
                                                                  ],
                                                                )
                                                            ),





                                                            /*Align(
                                                                                                  alignment: Alignment.bottomRight,
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(right: 10, bottom: 5),
                                                                                                    child: chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 17, color: Colors.white) : Icon(Icons.done_all, size: 17, color: Colors.white),
                                                                                                  ),
                                                                                                ),*/
                                                          ),
                                                          fileDownloading && downloadingPosition == pos
                                                              ? SizedBox(
                                                            width: 130.0,
                                                            height: 130.0,
                                                            child: Center(
                                                              child: Container(
                                                                width: 60,
                                                                height: 60,
                                                                padding: EdgeInsets.all(2),
                                                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                child: CircularPercentIndicator(
                                                                  radius: 28,
                                                                  lineWidth: 5.0,
                                                                  percent: downloadingProgress,
                                                                  center: Text(
                                                                    (downloadingProgress * 100).round().toString() + " %",
                                                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                  ),
                                                                  progressColor: Colors.green,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : Container(),
                                                        ],
                                                      )
                                                          : InkWell(
                                                        onTap: (){
                                                          print('triggered');
                                                          _launchUrl(_returnUrl(chatList[pos]['attachment'].toString()));

                                                        },
                                                        child: Container(
                                                         width: MediaQuery.of(context).size
                                                          .width
                                                          *0.5,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(color: Color(0xFFE7F4FA), borderRadius: BorderRadius.circular(10)),
                                                                padding: EdgeInsets.all(10),
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(height: 8),
                                                                    Row(
                                                                      children: [
                                                                        Icon(Icons.file_copy_outlined, size: 22),
                                                                        SizedBox(width: 5),
                                                                        Text(_returnUrl(chatList[pos]['attachment'].toString()).split('.').last + ' attachment', style: TextStyle(color: Color(0xff867983), fontSize: 12, fontWeight: FontWeight.w500))
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          _parseServerTime(chatList[pos]['created_at'].toString()),
                                                                          style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w300),
                                                                        ),
                                                                        SizedBox(width: 5),
                                                                        chatList[pos]['seen'] == 0 ? Icon(Icons.done, size: 15) : Icon(Icons.done_all_outlined, size: 15)
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              fileDownloading && downloadingPosition == pos
                                                                  ? SizedBox(
                                                                child: Center(
                                                                  child: Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    padding: EdgeInsets.all(2),
                                                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                                                                    child: CircularPercentIndicator(
                                                                      radius: 17,
                                                                      lineWidth: 5.0,
                                                                      percent: downloadingProgress,
                                                                      center: Text(
                                                                        (downloadingProgress * 100).round().toString() + " %",
                                                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                      ),
                                                                      progressColor: Colors.green,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                    ],
                                                  )
                                                      : Container(),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 13),

                                            //  chatDummyList[pos]['post_type']=='Image'? SizedBox(height: 10):Container(),

                                            // My (Sender) messages
                                          ],
                                        );
                                      }),
                                  /* Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 37,
                                              decoration: BoxDecoration(
                                                  color: AppTheme.gradient1
                                                      .withOpacity(0.3),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12),
                                                      bottomRight:
                                                          Radius.circular(12))),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text(
                                                    currentDate,
                                                    style: TextStyle(
                                                      color: Colors.brown,
                                                      fontSize: 14.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),*/
                                ],
                              )),
                          // send message layout

                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child:
                            /*  Container(
                    height: 66.0,
                    color: Colors.blue,
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                                controller: textEditingController,
                                style: const TextStyle(
                                    fontSize: 20.0, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(
                                      left: 16.0,
                                      bottom: 8.0,
                                      top: 8.0,
                                      right: 16.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                )),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                              onPressed: () {
                                // send message
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                        )
                      ],
                    )),*/
                            blockList == null
                                ? Container()
                                : blockList!.contains(widget.id.toString())
                                ? Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(15),
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Text(
                                    'You have blocked this contact'),
                              ),
                            )
                                : Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    // height: 50,
                                    child: TextFormField(
                                        textCapitalization:
                                        TextCapitalization
                                            .sentences,
                                        keyboardType:
                                        TextInputType.multiline,
                                        maxLines: null,
                                        controller:
                                        textEditingController,
                                        focusNode: focusNode,
                                        /*enabled: false,*/
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          prefixIcon: Material(
                                            color:
                                            Colors.transparent,
                                            child: IconButton(
                                              onPressed: () {
                                                if (WidgetsBinding
                                                    .instance
                                                    .window
                                                    .viewInsets
                                                    .bottom >
                                                    0.0) {
                                                  FocusManager
                                                      .instance
                                                      .primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    emojiShowing =
                                                    !emojiShowing;
                                                  });
                                                } else {
                                                  setState(() {
                                                    emojiShowing =
                                                    !emojiShowing;
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                Icons
                                                    .emoji_emotions_outlined,
                                                color: emojiShowing
                                                    ? Colors.blue
                                                    : Color(
                                                    0xffC4C4C4),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                          suffixIcon: SizedBox(
                                            width: 70,
                                            height: 50,
                                            child: Row(
                                              //  mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                          Colors
                                                              .transparent,
                                                          context:
                                                          context,
                                                          builder:
                                                              (builder) =>
                                                              bottomSheet());

                                                      //   showDialog();
                                                    },
                                                    child: const Icon(
                                                        Icons
                                                            .attach_file_sharp,
                                                        color: Color(
                                                            0xFFA7A9AA))),
                                                const SizedBox(
                                                    width: 3),
                                                InkWell(
                                                    onTap: () {
                                                      getImageFromCamera();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 10),
                                                      child: Icon(Icons.camera_alt,color:Color(0xFFA7A9AA)),
                                                    )
                                                ),

                                              ],
                                            ),
                                          ),
                                          border:
                                          OutlineInputBorder(
                                            borderSide:
                                            const BorderSide(
                                              width: 0,
                                              style:
                                              BorderStyle.none,
                                            ),
                                            borderRadius:
                                            BorderRadius
                                                .circular(25.0),
                                          ),
                                          fillColor: const Color(
                                              0xffEEEEEE),
                                          filled: true,
                                          contentPadding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20.0,
                                              12.0,
                                              5.0,
                                              12.0),
                                          hintText: 'Message',
                                          labelStyle:
                                          const TextStyle(
                                            fontSize: 14.0,
                                            color:
                                            Color(0XFFA6A6A6),
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(width: 5),

                                InkWell(
                                  onTap: () {
                                    if (textEditingController
                                        .text
                                        .isNotEmpty) {
                                      chatMessage =
                                          textEditingController
                                              .text;
                                      textEditingController
                                          .clear();
                                      localMessage =
                                      true;
                                      _sendMessage();
                                    }
                                  },
                                  child: Container(
                                      padding:
                                      const EdgeInsets
                                          .all(
                                          12),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape
                                              .circle,
                                          color: AppTheme.gradient1),
                                      child:
                                      const Icon(
                                        Icons.send,
                                        color: Colors
                                            .white,
                                      )

                                    /*Image.asset(
                                                        'assets/send_ic.png'),*/
                                  ),
                                ),



                                const SizedBox(width: 10),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          Offstage(
                            offstage: !emojiShowing,
                            child: SizedBox(
                              height: 250,
                              child: EmojiPicker(
                                  onEmojiSelected:
                                      (Category? category, Emoji emoji) {
                                    print(category);
                                    _onEmojiSelected(emoji);
                                  },
                                  onBackspacePressed: _onBackspacePressed,
                                  config: Config(
                                      columns: 7,
                                      emojiSizeMax:
                                      32 * (Platform.isIOS ? 1.30 : 1.0),
                                      verticalSpacing: 0,
                                      horizontalSpacing: 0,
                                      gridPadding: EdgeInsets.zero,
                                      initCategory: Category.RECENT,
                                      bgColor: const Color(0xFFF2F2F2),
                                      indicatorColor: Colors.blue,
                                      categoryIcons: const CategoryIcons(),
                                      iconColor: Colors.grey,
                                      iconColorSelected: Colors.blue,
                                      backspaceColor: Colors.blue,
                                      skinToneDialogBgColor: Colors.white,
                                      skinToneIndicatorColor: Colors.grey,
                                      enableSkinTones: true,
                                      showRecentsTab: true,
                                      recentsLimit: 28,
                                      replaceEmojiOnLimitExceed: false,
                                      noRecents: const Text(
                                        'No Recents',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black26),
                                        textAlign: TextAlign.center,
                                      ),
                                      tabIndicatorAnimDuration:
                                      kTabScrollDuration,
                                      buttonMode: ButtonMode.MATERIAL)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))),
        ),
        onWillPop: () {
          if (emojiShowing) {
            setState(() {
              emojiShowing = !emojiShowing;
            });
          } else if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
            FocusManager.instance.primaryFocus?.unfocus();
          } else {
            _myTimer?.cancel();
            Navigator.pop(context, 'restart timer');
          }

          return Future.value(false);
        });
  }

  onFocusChange() {
    // Hide sticker whenever keypad appears
    if (focusNode.hasFocus) {
      if (emojiShowing) {
        setState(() {
          emojiShowing = !emojiShowing;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBlockValues();
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent &&
          chatList.length > 99) {
        _page++;
        if (loadMoreData) {
          setState(() {
            isPagLoading = true;
          });
          paginatePosts();
        }
      }
    });

    focusNode.addListener(onFocusChange);
    /* listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
       // updateDate();
      }
    });*/

    fetchChatList(context);
    makeSeen();
  }

  updateDate() {
    if (chatList.length != 0) {
      currentDate = _parseServerDate2(chatList[0]['created_at'].toString());
      setState(() {});
    }
  }

  static String _parseServerDate2(String date) {
    DateTime dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.yMMMMd();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }

  Future<Uint8List> returnThumbnail(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      quality: 75,
    );
    return uint8list!;
  }

  fetchChatList(BuildContext context) async {
    loadMoreData = true;
    _page = 1;
    ApiBaseHelper helper = ApiBaseHelper();
    var apiParams = {
      'id': widget.id,
      'type': 'group',
      'per_page': 100,
      'page': 1
    };
    setState(() {
      isLoading = true;
    });
    var response =
    await helper.postAPIWithHeader('fetchMessages', apiParams, context);
    var responseJson = jsonDecode(response.body.toString());
    chatList = responseJson['messages'];
    // chatList = chatList.reversed.toList();
    isLoading = false;
    /* print('Last item');
    print(chatList[chatList.length]);
    print(chatList[0]);*/
    setState(() {});
    _myTimer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => refreshChatList(context));

    /* Future.delayed(const Duration(seconds: 1), () {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut);

      _myTimer = Timer.periodic(
          Duration(seconds: 5), (Timer t) => refreshChatList(context));


    });*/
  }

  refreshFileUpload(BuildContext context) async {
    ApiBaseHelper helper = ApiBaseHelper();
    var apiParams = {'id': widget.id, 'type': 'group', 'per_page': 5, 'page': 1};
    var response =
    await helper.postAPIWithHeader('fetchMessages', apiParams, context);
    var responseJson = jsonDecode(response.body.toString());
    chatRefreshList = responseJson['messages'];
    // chatRefreshList = chatRefreshList.reversed.toList();
    print('Length of chat list' + chatList.length.toString());
    print('Length of refresh chat list' + chatRefreshList.length.toString());

    if (chatRefreshList[0]['id'].toString() !=
        chatList[0]['id'].toString() /*&& chatList[0]['attachment']=='file'*/) {
      print('New Item uploaded in chat');
      print('Adding in chat bort');

      for (int i = 0; i <= 4; i++) {
        chatList[i] = chatRefreshList[i];
      }

      //chatList[0]=chatRefreshList[0];
      fileUploading = false;

      _myTimer = Timer.periodic(
          Duration(seconds: 5), (Timer t) => refreshChatList(context));

      setState(() {});

      /*   listScrollController.animateTo(
          listScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut);


      setState(() {
      });*/

    }
  }

  refreshChatList(BuildContext context) async {
    ApiBaseHelper helper = ApiBaseHelper();
    var apiParams = {'id': widget.id, 'type': 'group', 'per_page': 5, 'page': 1};
    var response =
    await helper.postAPIWithHeader('fetchMessages', apiParams, context);
    var responseJson = jsonDecode(response.body.toString());
    chatRefreshList = responseJson['messages'];
    // chatRefreshList = chatRefreshList.reversed.toList();
    print('Length of chat list' + chatList.length.toString());
    print('Length of refresh chat list' + chatRefreshList.length.toString());
    if (chatRefreshList[0]['id'].toString() != chatList[0]['id'].toString() && !fileUploading && !localMessage) {
      print('New Item arrived in chat');
      print('Adding in chat bort');

      for (int i = 0; i <= 4; i++) {
        /*     if (chatList[i]['attachment'] == 'file' && chatList[i]['body']==null) {

          chatList[i]['id']= chatRefreshList[i]['id'];
          chatList[i]['seen']=chatRefreshList[i]['seen'];

          chatRefreshList[i] = chatList[i];
        }*/ chatList[i] = chatRefreshList[i];
      }

      setState(() {});

      /* listScrollController.animateTo(
          listScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut);

      setState(() {
      });*/

      makeSeen();
    }
  }

  paginatePosts() async {
    ApiBaseHelper helper = ApiBaseHelper();
    var apiParams = {
      'id': widget.id,
      'type': 'group',
      'per_page': 50,
      'page': _page
    };
    var response =
    await helper.postAPIWithHeader('fetchMessages', apiParams, context);
    var responseJson = jsonDecode(response.body.toString());
    List<dynamic> newChatList = responseJson['messages'];
    isPagLoading = false;
    if (newChatList.length == 0) {
      loadMoreData = false;
    } else {
      print('Page Data' + newChatList.length.toString());
      newChatList = newChatList.reversed.toList();
      List<dynamic> list = newChatList + chatList;
      chatList = list;
    }
    setState(() {});
    /* listScrollController.animateTo(
        newChatList.length.toDouble(),
        duration: Duration(seconds: 1),
        curve: Curves.easeOut);*/
  }

  makeSeen() async {
    ApiBaseHelper helper = ApiBaseHelper();
    var apiParams = {'id': widget.id, 'type': 'group'};
    var response =
    await helper.postAPIWithHeader('makeSeen', apiParams, context);
    print(response.toString());
  }

  String _returnUrl(String response) {
    var files = json.decode(response);
    return files['new_name'];
  }

  String _returnUrlFile(String response) {
    var files = json.decode(response);
    return files['full_name'];
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  _onEmojiSelected(Emoji emoji) {
    textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  _onBackspacePressed() {
    textEditingController
      ..text = textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  _downloadFile(String url, int listPosition) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    downloadingProgress = 0;
    fileDownloading = true;
    downloadingPosition = listPosition;
    setState(() {});
    //downloadProgressDialog(context);
    /// Download
    await ALDownloader.download(url,
        downloaderHandlerInterface:
        ALDownloaderHandlerInterface(progressHandler: (progress) {
          setState(() {
            downloadingProgress = progress;
          });

          debugPrint("ALDownloader | download progress = $progress");
        }, succeededHandler: () {
          debugPrint("ALDownloader | download succeeded");
          setState(() {
            fileDownloading = false;
          });
          showSuccessDialog(context);
        }, failedHandler: () {
          debugPrint("ALDownloader | download failed");
        }, pausedHandler: () {
          debugPrint("ALDownloader | download paused");
        }));

    // /storage/emulated/0/Android/data/com.happy.aha/files
  }

  showSuccessDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Download success"),
      content: Text(
        Platform.isIOS
            ? "File downloaded at\n/var/mobile/Containers/Data/Application/F0316412-3F14-4F3C-9D38-0247095E1E1D/Documents"
            : "File downloaded at\n/storage/emulated/0/Android/data/com.happy.aha/files",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      actions: [
        okButton,
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

  Widget bottomSheet() {
    return Container(
      height: 165,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.only(left: 32, right: 32, top: 18, bottom: 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),*/

              iconCreation(Icons.file_copy, AppTheme.dashboardGrey, "Docs", () {
                pickDocs();
              }),
              iconCreation(
                  Icons.insert_photo, AppTheme.dashboardGrey, "Gallery", () {
                pickGalleryFile();
              }),
              iconCreation(
                  Icons.video_call, AppTheme.dashboardGrey, "Recording", () {
                captureVideo();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, Function onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  deleteMessage(String messageID, int pos) async {
    APIDialog.showAlertDialog(context, 'Deleting message...');
    var formData = {'auth_key': AppModel.authKey, 'message_id': messageID};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPIWithHeader('deleteConversation', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());

    setState(() {
      chatList.removeAt(pos);
    });
    print(responseJson);
  }

  _sendMessage() {
    listScrollController.animateTo(
        listScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut);

    setState(() {});
    chatList.insert(0, {
      "id": 123456,
      "type": "group",
      "from_id": authBloc.state.userId,
      "to_id": 7,
      "body": chatMessage,
      "attachment": null,
      "seen": 0,
      "created_at": DateTime.now().toUtc().toString(),
      "updated_at": "2022-07-13 07:28:54"
    });

    setState(() {});
    _sendMessageAPI();
    /*  Future.delayed(const Duration(milliseconds: 100), () {
      listScrollController.animateTo(
          listScrollController.position.maxScrollExtent,
          duration: Duration(microseconds: 500),
          curve: Curves.easeOut);
    });*/
  }

  _sendFile() {
    // _myTimer!.cancel();
    print('Send File Functioon');

    print(selectedFile!.path);

    listScrollController.animateTo(
        listScrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut);
    /*setState(() {

    });*/
    chatList.insert(0, {
      "id": 1805691638,
      "type": "group",
      "from_id": authBloc.state.userId,
      "to_id": 7,
      "body": "",
      "attachment": 'file',
      "seen": 0,
      "created_at": DateTime.now().toUtc().toString(),
      "updated_at": selectedFile!.path,
      "sender": 'progress'
    });

    //  setState(() {});
    _sendMessageAPI();
    /* Future.delayed(const Duration(milliseconds: 100), () {

    });*/
  }

  Future getImageFromCamera() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      selectedFile = File(pickedFile.path);
      int sizeInBytes = selectedFile!.lengthSync();
      if (sizeInBytes > 16000000) {
        showFileDialog();
      } else {
        if(Platform.isIOS)
        {
          selectedFile= await FlutterExifRotation.rotateImage(path: selectedFile!.path);
          if (!fileUploading) {
            _sendFile();
          }

        }
        else
        {
          if (!fileUploading) {
            _sendFile();
          }
        }
      }
    }
    print('This camera error');
  }

  showFileDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Limit exceeded",
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
      content: Text(
        "File cannot be greater then 16mb",
        style: TextStyle(
          fontSize: 12.0,
          color: AppTheme.gradient1,
        ),
      ),
      actions: [
        okButton,
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

  Future pickGalleryFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowCompression: true, type: FileType.media);
    if (result != null) {
      selectedFile = File(result.files.single.path.toString());
      int sizeInBytes = selectedFile!.lengthSync();

      if (sizeInBytes > 16000000) {
        showFileDialog();
      } else {

        // Rotate IOS Image

        if (!fileUploading) {
          if(lookupMimeType(selectedFile!.path).toString().startsWith('image/') && Platform.isIOS)
          {
            selectedFile= await FlutterExifRotation.rotateImage(path: selectedFile!.path);
            _sendFile();
          }
          else
          {
            _sendFile();
          }





        }
      }
    }
  }
  Future pickDocs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      selectedFile = File(result.files.single.path.toString());

      if (!fileUploading) {
        _sendFile();
        // _sendMessageAPI();
      }
    }
  }

  Future captureVideo() async {
    final _selectedVideo = await picker.pickVideo(source: ImageSource.camera);
    if (_selectedVideo != null) {
      selectedFile = File(_selectedVideo.path);
      int sizeInBytes = selectedFile!.lengthSync();
      if (sizeInBytes > 16000000) {
        showFileDialog();
      } else {
        if (!fileUploading) {
          _sendFile();
        }
      }

      //  selectedFile = File(_selectedVideo.path);

      /* int sizeInBytes = selectedFile!.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb > 15) {
        showFileDialog();
      } else {
        _sendFile();
        _sendMessageAPI();
      }*/
    }
  }

  _sendMessageAPI() async {
    uploadingProgress=0.0;
    if (_myTimer!.isActive) {
      _myTimer!.cancel();
      print('Timer Stopped');
    }

    if (fileUploading) {
      _sendOnlyMessageAPI();
    } else {
      if (selectedFile != null) {
        localVideo = true;
        fileUploading = true;
        uploadingIndex = 0;
        setState(() {});
      }

      try {
        Diot.Dio dio = Diot.Dio();
        dio.options.headers['Content-Type'] = 'multipart/form-data';
        dio.options.headers['Authorizations'] = AppModel.authKey;
        var requestModel = Diot.FormData.fromMap({
          'message': chatMessage == '' ? null : chatMessage,
          'id': widget.id,
          'type': 'group',
          'temporaryMsgId': 'temp_1',
          'file': selectedFile == null
              ? null
              : await Diot.MultipartFile.fromFile(
            selectedFile!.path,
          ),
        });

        print(requestModel.fields);
        print('Bloc Started');
        if (chatMessage != '') {
          messageIndex = 0;
          setState(() {});
        }
        final response = await dio.post(
          AppConstant.chatBaseURL + 'sendMessage',
          data: requestModel,
          onSendProgress: (int sent, int total) {
            print('$sent $total');

            int mul=sent*100;
            uploadingProgress=mul/total;
            print(uploadingProgress.toString()+'% ^^^');
            setState(() {

            });

          },
        );
        var responseBody = response.data;
        print(responseBody.toString());

        if (chatMessage != '') {
          messageIndex = 9999;
          chatMessage = '';
          localMessage=false;
        } else {
          print('FILE UPLOADED SUCCESSFULLY');
          //chatList[0]['sender'] = 'done';
          selectedFile = null;
          fileUploading = false;
          localVideo = false;
          uploadingIndex = 99999;
        }

        setState(() {});
        // refreshFileUpload(context);
        _myTimer = Timer.periodic(
            Duration(seconds: 5), (Timer t) => refreshChatList(context));
      } catch (errorMessage) {}
    }
  }

  _sendOnlyMessageAPI() async {
    try {
      Diot.Dio dio = Diot.Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers['Authorizations'] = AppModel.authKey;
      var requestModel = Diot.FormData.fromMap({
        'message': chatMessage == '' ? null : chatMessage,
        'id': widget.id,
        'type': 'group',
        'temporaryMsgId': 'temp_1',
        'file': null
      });

      print(requestModel.fields);
      print('Bloc Started');
      if (chatMessage != '') {
        messageIndex = 0;
        setState(() {});
      }
      final response = await dio.post(
        AppConstant.chatBaseURL + 'sendMessage',
        data: requestModel,
      );
      var responseBody = response.data;
      print(responseBody.toString());

      if (chatMessage != '') {
        messageIndex = 9999;
        chatMessage = '';
      }
      setState(() {});
      // refreshFileUpload(context);

    } catch (errorMessage) {}
  }

  String _parseServerTime(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    final DateFormat timeFormatter = DateFormat('ddMMM,h:mm a');
    String dayAsString = timeFormatter.format(dateLocal);
    return dayAsString;
  }

  Future<void> handleClickReport(String value) async {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
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

  _blockUser() {
    APIDialog.showAlertDialog(context, 'Blocking user...');

    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var blockList = prefs.getStringList('blockusers');

      if (blockList == null) {
        List<String> blockListNew = [];
        blockListNew.add(widget.id.toString());
        prefs.setStringList('blockusers', blockListNew);
      } else {
        blockList.add(widget.id.toString());
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
  String getFileName(String url)
  {
    String fileName = url.split('/').last;
    return fileName;
  }

  _launchUrl(String url) async {
    print('***&&&&');
    print(url);
    _myTimer!.cancel();
    final data=await Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewScreen(url)));
    if(data!=null)
    {
      _myTimer = Timer.periodic(
          Duration(seconds: 5), (Timer t) => refreshChatList(context));
    }

  }
  String _returnUrlWithFileName(String response) {
    var files = json.decode(response);
    String str= files['new_name'];
    String fileName = str.split('/').last;
    return fileName;
  }
  @override
  void dispose() {
    _myTimer!.cancel();
    focusNode.removeListener(onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  showDeleteDialog(BuildContext context, String messageID, int pos) {
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
        deleteMessage(messageID, pos);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete message"),
      content: Text("Are you sure you want to delete this message ?"),
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



