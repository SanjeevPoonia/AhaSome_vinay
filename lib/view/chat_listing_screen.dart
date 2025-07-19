import 'dart:async';
import 'dart:convert';

import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/chat_screen.dart';
import 'package:aha_project_files/view/group_chat_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/all_friends_model.dart';
import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../network/bloc/friends_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/rounded_image_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends StatefulWidget {
  ChatListState createState() => ChatListState();
}

class ChatListState extends State<ChatListScreen> {
  bool isLoading = false;
  List<dynamic> contactsList = [];
  List<dynamic> searchContactsList = [];
  List<dynamic> refreshContactsList = [];
  var searchController = TextEditingController();
  var searchControllerDialog = TextEditingController();
  final friendsBloc = Modular.get<FriendsCubit>();
  final authBloc = Modular.get<AuthCubit>();
  Timer? _myTimer;

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
                        AppBarNew(
                          onTap: () {
                            _myTimer?.cancel();
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
                            'Chats',
                            style: TextStyle(
                                color: Color(0xFfDD2E44),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
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
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: AppTheme.gradient4,
                                              shape: BoxShape.circle),
                                          child: const Center(
                                              child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                            size: 30,
                                          )),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      fillColor:
                                          AppTheme.gradient2.withOpacity(0.4),
                                      filled: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 12.0, 0.0, 12.0),
                                      hintText: 'Search Friends/groups',
                                      hintStyle: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0XFFA6A6A6),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  _executeFriendsAPI();
                                  searchControllerDialog.clear();
                                  friendsDialog(context);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.navigationRed,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                            child: isLoading
                                ? Loader()
                                : contactsList.length == 0
                                    ? Center(child: Text('No chats found'))
                                    : searchContactsList.length != 0 ||
                                            searchController.text.isNotEmpty
                                        ? searchContactsList.length == 0 &&
                                                searchController.text.isNotEmpty
                                            ? Center(
                                                child: Text('No chats found'))
                                            : ListView.builder(
                                                itemCount:
                                                    searchContactsList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int pos) {
                                                  return searchContactsList[pos]
                                                              ['msg_type'] ==
                                                          'group'
                                                      ?
                                                      //  Group
                                                      Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                _myTimer?.cancel();

                                                                searchContactsList[pos][
                                                                'unseenCounter'] = 0;

                                                                setState(() {});
                                                                final data = await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => GroupChatScreen(
                                                                            searchContactsList[
                                                                            pos]
                                                                            [
                                                                            'id'],
                                                                            searchContactsList[
                                                                            pos]
                                                                            [
                                                                            'group_name'],
                                                                            searchContactsList[
                                                                            pos]
                                                                            [
                                                                            'group_avatar'])));

                                                                if (data != null) {
                                                                  _startTimer();
                                                                }


                                                               /*
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => GroupChatScreen(
                                                                            searchContactsList[pos]
                                                                                [
                                                                                'id'],
                                                                            searchContactsList[pos]
                                                                                [
                                                                                'group_name'],
                                                                            searchContactsList[pos]
                                                                                [
                                                                                'group_avatar'])));*/
                                                              },
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: pos %
                                                                              2 ==
                                                                          0
                                                                      ? Color(
                                                                          0xFFF8E4FF)
                                                                      : Color(
                                                                          0xFFFFDDE0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10,
                                                                        left: 11,
                                                                        right:
                                                                            11),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    RoundedImageWidget(
                                                                        searchContactsList[pos]
                                                                        [
                                                                        'group_avatar']
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Text(
                                                                            searchContactsList[pos]
                                                                                [
                                                                                'group_name'],
                                                                            style: TextStyle(
                                                                                color: AppTheme.textColor,
                                                                                fontSize: 13),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          searchContactsList[pos]['from_id'] ==
                                                                                  authBloc.state.userId
                                                                              ? searchContactsList[pos]['body'] != null && searchContactsList[pos]['body'].toString().isNotEmpty
                                                                                  ? Text(
                                                                                      'You : ' + HtmlCharacterEntities.decode(searchContactsList[pos]['body']),
                                                                                      style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                    )
                                                                                  : searchContactsList[pos]['attachment'] != null
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'You : ' + 'Attachment',
                                                                                              style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                            ),
                                                                                            Icon(Icons.attach_file_sharp, size: 12)
                                                                                          ],
                                                                                        )
                                                                                      : Container()
                                                                              : searchContactsList[pos]['body'] != null && searchContactsList[pos]['body'].toString().isNotEmpty
                                                                                  ? Text(
                                                                            HtmlCharacterEntities.decode(searchContactsList[pos]['body']),
                                                                                      style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                    )
                                                                                  : searchContactsList[pos]['attachment'] != null
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'Attachment',
                                                                                              style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.attach_file_sharp,
                                                                                              size: 12,
                                                                                            )
                                                                                          ],
                                                                                        )
                                                                                      : Container()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 2),
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                          2),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .end,
                                                                        children: [
                                                                          Text(
                                                                            searchContactsList[pos]['max_created_at'] != null
                                                                                ? _parseServerDate(searchContactsList[pos]['max_created_at'].toString())
                                                                                : '',
                                                                            style: const TextStyle(
                                                                                color: Color(0xFFDD3648),
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 11),
                                                                          ),
                                                                          SizedBox(
                                                                              height:
                                                                                  10),
                                                                          searchContactsList[pos]['unseenCounter'] !=
                                                                                  0
                                                                              ? Container(
                                                                                  width: 20,
                                                                                  height: 20,
                                                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFf2180F3)),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      searchContactsList[pos]['unseenCounter'] > 9 ? '9+' : searchContactsList[pos]['unseenCounter'].toString(),
                                                                                      style: TextStyle(color: Colors.white,fontSize: 10),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Container()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 12)
                                                          ],
                                                        )
                                                      :

                                                      // User Chat

                                                      Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                _myTimer
                                                                    ?.cancel();

                                                                searchContactsList[
                                                                        pos][
                                                                    'unseenCounter'] = 0;

                                                                setState(() {});

                                                                final data = await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => ChatScreen(
                                                                            searchContactsList[pos]
                                                                                [
                                                                                'id'],
                                                                            searchContactsList[pos]['first_name'] +
                                                                                ' ' +
                                                                                searchContactsList[pos][
                                                                                    'last_name'],
                                                                            searchContactsList[pos]
                                                                                [
                                                                                'avatar'])));

                                                                if (data !=
                                                                    null) {
                                                                  _startTimer();
                                                                }
                                                              },
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: pos %
                                                                              2 ==
                                                                          0
                                                                      ? Color(
                                                                          0xFFF8E4FF)
                                                                      : Color(
                                                                          0xFFFFDDE0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10,
                                                                        left: 11,
                                                                        right:
                                                                            11),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [

                                                                    RoundedImageWidget(searchContactsList[pos]
                                                                    [
                                                                    'avatar']),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Text(
                                                                            searchContactsList[pos]['first_name'] +
                                                                                ' ' +
                                                                                searchContactsList[pos]['last_name'],
                                                                            style: TextStyle(
                                                                                color: AppTheme.textColor,
                                                                                fontSize: 13),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          searchContactsList[pos]['from_id'] ==
                                                                                  authBloc.state.userId
                                                                              ? searchContactsList[pos]['body'] != null && searchContactsList[pos]['body'].toString().isNotEmpty
                                                                                  ? Text(
                                                                                      'You : ' + HtmlCharacterEntities.decode(searchContactsList[pos]['body']),
                                                                                      style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                      maxLines: 2,
                                                                                    )
                                                                                  : searchContactsList[pos]['attachment'] != null
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'You : ' + 'Attachment',
                                                                                              style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                            ),
                                                                                            Icon(Icons.attach_file_sharp, size: 12)
                                                                                          ],
                                                                                        )
                                                                                      : Container()
                                                                              : searchContactsList[pos]['body'] != null && searchContactsList[pos]['body'].toString().isNotEmpty
                                                                                  ? Text(
                                                                            HtmlCharacterEntities.decode(searchContactsList[pos]['body']),
                                                                                      style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                      maxLines: 2,
                                                                                    )
                                                                                  : searchContactsList[pos]['attachment'] != null
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'Attachment',
                                                                                              style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.attach_file_sharp,
                                                                                              size: 12,
                                                                                            )
                                                                                          ],
                                                                                        )
                                                                                      : Container()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 2),
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                          2),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .end,
                                                                        children: [
                                                                          Text(
                                                                            searchContactsList[pos]['max_created_at'] != null
                                                                                ? _parseServerDate(searchContactsList[pos]['max_created_at'].toString())
                                                                                : '',
                                                                            style: const TextStyle(
                                                                                color: Color(0xFFDD3648),
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 11),
                                                                          ),
                                                                          SizedBox(
                                                                              height:
                                                                                  10),
                                                                          searchContactsList[pos]['unseenCounter'] !=
                                                                                  0
                                                                              ? Container(
                                                                                  width: 20,
                                                                                  height: 20,
                                                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFf2180F3)),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      searchContactsList[pos]['unseenCounter'] > 9 ? '9+' : searchContactsList[pos]['unseenCounter'].toString(),
                                                                                      style: TextStyle(color: Colors.white,fontSize: 10),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Container()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 12)
                                                          ],
                                                        );
                                                })
                                        : ListView.builder(
                                            itemCount: contactsList.length,
                                            itemBuilder:
                                                (BuildContext context, int pos) {
                                              return contactsList[pos]
                                                          ['msg_type'] ==
                                                      'group'
                                                  ?
                                                  //  Group
                                                  Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            _myTimer?.cancel();

                                                            contactsList[pos][
                                                            'unseenCounter'] = 0;

                                                            setState(() {});
                                                            final data = await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => GroupChatScreen(
                                                                        contactsList[
                                                                                pos]
                                                                            [
                                                                            'id'],
                                                                        contactsList[
                                                                                pos]
                                                                            [
                                                                            'group_name'],
                                                                        contactsList[
                                                                                pos]
                                                                            [
                                                                            'group_avatar'])));

                                                            if (data != null) {
                                                              _startTimer();
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: pos % 2 == 0
                                                                  ? Color(
                                                                      0xFFF8E4FF)
                                                                  : Color(
                                                                      0xFFFFDDE0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    left: 11,
                                                                    right: 11),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [

                                                                RoundedImageWidget(contactsList[pos]
                                                                [
                                                                'group_avatar']),
                                                                SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        contactsList[
                                                                                pos]
                                                                            [
                                                                            'group_name'],
                                                                        style: TextStyle(
                                                                            color: AppTheme
                                                                                .textColor,
                                                                            fontSize:
                                                                                13),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      contactsList[pos]['from_id'] ==
                                                                              authBloc
                                                                                  .state.userId
                                                                          ? contactsList[pos]['body'] != null &&
                                                                                  contactsList[pos]['body'].toString().isNotEmpty
                                                                              ? Text(
                                                                                  'You : ' + HtmlCharacterEntities.decode(contactsList[pos]['body']),
                                                                                  style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                )
                                                                              : contactsList[pos]['attachment'] != null
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'You : ' + 'Attachment',
                                                                                          style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                        ),
                                                                                        Icon(Icons.attach_file_sharp, size: 12)
                                                                                      ],
                                                                                    )
                                                                                  : Container()
                                                                          : contactsList[pos]['body'] != null && contactsList[pos]['body'].toString().isNotEmpty
                                                                              ? Text(
                                                                        HtmlCharacterEntities.decode(contactsList[pos]['body']),
                                                                                  style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                )
                                                                              : contactsList[pos]['attachment'] != null
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'Attachment',
                                                                                          style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.attach_file_sharp,
                                                                                          size: 12,
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 2),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                      2),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        contactsList[pos]['max_created_at'] !=
                                                                                null
                                                                            ? _parseServerDate(
                                                                                contactsList[pos]['max_created_at'].toString())
                                                                            : '',
                                                                        style: const TextStyle(
                                                                            color: Color(
                                                                                0xFFDD3648),
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontSize:
                                                                                11),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                      contactsList[pos]['unseenCounter'] !=
                                                                              0
                                                                          ? Container(
                                                                              width:
                                                                                  20,
                                                                              height:
                                                                                  20,
                                                                              decoration:
                                                                                  BoxDecoration(shape: BoxShape.circle, color: Color(0xFf2180F3)),
                                                                              child:
                                                                                  Center(
                                                                                child: Text(
                                                                                  contactsList[pos]['unseenCounter'] > 9 ? '9+' : contactsList[pos]['unseenCounter'].toString(),
                                                                                  style: TextStyle(color: Colors.white,fontSize: 10),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 12)
                                                      ],
                                                    )
                                                  :

                                                  // User Chat

                                                  Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            _myTimer?.cancel();

                                                            contactsList[pos][
                                                                'unseenCounter'] = 0;

                                                            setState(() {});
                                                            final data = await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ChatScreen(
                                                                        contactsList[
                                                                                pos]
                                                                            [
                                                                            'id'],
                                                                        contactsList[pos]
                                                                                [
                                                                                'first_name'] +
                                                                            ' ' +
                                                                            contactsList[pos]
                                                                                [
                                                                                'last_name'],
                                                                        contactsList[
                                                                                pos]
                                                                            [
                                                                            'avatar'])));
                                                            if (data != null) {
                                                              _startTimer();
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: pos % 2 == 0
                                                                  ? Color(
                                                                      0xFFF8E4FF)
                                                                  : Color(
                                                                      0xFFFFDDE0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    left: 11,
                                                                    right: 11),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [

                                                                RoundedImageWidget(contactsList[pos]
                                                                [
                                                                'avatar']),

                                                                SizedBox(
                                                                    width: 10),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        contactsList[pos]
                                                                                [
                                                                                'first_name'] +
                                                                            ' ' +
                                                                            contactsList[pos]
                                                                                [
                                                                                'last_name'],
                                                                        style: TextStyle(
                                                                            color: AppTheme
                                                                                .textColor,
                                                                            fontSize:
                                                                                13),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      contactsList[pos]['from_id'] ==
                                                                              authBloc
                                                                                  .state.userId
                                                                          ? contactsList[pos]['body'] != null &&
                                                                                  contactsList[pos]['body'].toString().isNotEmpty
                                                                              ? Text(
                                                                                  'You : ' +  HtmlCharacterEntities.decode(contactsList[pos]['body']),
                                                                                  style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                  maxLines: 2,
                                                                                )
                                                                              : contactsList[pos]['attachment'] != null
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'You : ' + 'Attachment',
                                                                                          style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                        ),
                                                                                        Icon(Icons.attach_file_sharp, size: 12)
                                                                                      ],
                                                                                    )
                                                                                  : Container()
                                                                          : contactsList[pos]['body'] != null && contactsList[pos]['body'].toString().isNotEmpty
                                                                              ? Text(
                                                                                  contactsList[pos]['body'],
                                                                                  style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                  maxLines: 2,
                                                                                )
                                                                              : contactsList[pos]['attachment'] != null
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'Attachment',
                                                                                          style: TextStyle(color: Color(0xFF414141), fontSize: 11),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons.attach_file_sharp,
                                                                                          size: 12,
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 2),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              2),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        contactsList[pos]['max_created_at'] !=
                                                                                null
                                                                            ? _parseServerDate(
                                                                                contactsList[pos]['max_created_at'].toString())
                                                                            : '',
                                                                        style: const TextStyle(
                                                                            color: Color(
                                                                                0xFFDD3648),
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontSize:
                                                                                11),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                      contactsList[pos]['unseenCounter'] !=
                                                                              0
                                                                          ? Container(
                                                                              width:
                                                                                  20,
                                                                              height:
                                                                                  20,
                                                                              decoration:
                                                                                  BoxDecoration(shape: BoxShape.circle, color: Color(0xFf2180F3)),
                                                                              child:
                                                                                  Center(
                                                                                child: Text(
                                                                                  contactsList[pos]['unseenCounter'] > 9 ? '9+' : contactsList[pos]['unseenCounter'].toString(),
                                                                                  style: TextStyle(color: Colors.white,fontSize: 10),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 12)
                                                      ],
                                                    );
                                            }))
                      ],
                    ),
                  ],
                )),
          ),
        ),
        onWillPop: () {
          _myTimer?.cancel();
          Navigator.pop(context);

          return Future.value(false);
        });
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
    Future.delayed(const Duration(milliseconds: 500), () {
      fetchContacts(context);
    });
  }

  fetchContacts(BuildContext context) async {
    ApiBaseHelper helper = ApiBaseHelper();
    setState(() {
      isLoading = true;
    });
    var response = await helper.getAPIWithHeader('getContacts', context);

    var responseJson = jsonDecode(response.body.toString());
    contactsList = responseJson['contacts'];
    isLoading = false;
    setState(() {});

    _startTimer();
  }

  _startTimer() {
    _myTimer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => refreshContacts(context));
  }

  refreshContacts(BuildContext context) async {
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPIWithHeader('getContacts', context);
    var responseJson = jsonDecode(response.body.toString());
    contactsList = responseJson['contacts'];
    setState(() {});
  }

  void friendsDialog(BuildContext bContext) {
    showDialog(
        context: bContext,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), //this right here
                child: BlocBuilder(
                  bloc: friendsBloc,
                  builder: (context, state) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(right: 13),
                            child: Row(
                              children: [
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close, size: 30)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                                controller: searchControllerDialog,
                                onChanged: (value) {
                                  _runFilterDialog(value);
                                },
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          color: AppTheme.gradient4,
                                          shape: BoxShape.circle),
                                      child: const Center(
                                          child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  // fillColor: AppTheme.gradient2.withOpacity(0.4),
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 12.0, 0.0, 12.0),
                                  hintText: 'Search friends',
                                  hintStyle: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0XFFA6A6A6),
                                  ),
                                )),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Friends',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45),
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: friendsBloc.state.isLoading
                                ? Loader()
                                : friendsBloc.state.friendList.length == 0
                                    ? Center(
                                        child: Text(
                                          'No Friends Found',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : friendsBloc.state.searchFriendList
                                                    .length !=
                                                0 ||
                                            searchController.text.isNotEmpty
                                        ?
                                        //search list
                                        Container(
                                            height: 400,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: friendsBloc.state
                                                    .searchFriendList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int pos) {
                                                  return Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          _myTimer?.cancel();
                                                          Navigator.pop(
                                                              context);

                                                          final data = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ChatScreen(
                                                                      friendsBloc
                                                                          .state
                                                                          .searchFriendList[
                                                                              pos]
                                                                          .id!,
                                                                      friendsBloc
                                                                              .state
                                                                              .searchFriendList[
                                                                                  pos]
                                                                              .first_name! +
                                                                          ' ' +
                                                                          friendsBloc
                                                                              .state
                                                                              .searchFriendList[
                                                                                  pos]
                                                                              .last_name!,
                                                                      friendsBloc
                                                                          .state
                                                                          .searchFriendList[
                                                                              pos]
                                                                          .avatar!)));

                                                          if (data != null) {
                                                            _startTimer();
                                                          }
                                                        },
                                                        child: Card(
                                                          elevation: 5,
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Padding(
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
                                                                        .searchFriendList[
                                                                    pos]
                                                                        .avatar!
                                                                ),



                                                                /* CircleAvatar(
                                                                  radius: 23.0,
                                                                  backgroundImage:
                                                                      NetworkImage(friendsBloc
                                                                          .state
                                                                          .searchFriendList[
                                                                              pos]
                                                                          .avatar!),
                                                                ),*/
                                                                const SizedBox(
                                                                    width: 10),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${friendsBloc.state.searchFriendList[pos].first_name} ${friendsBloc.state.searchFriendList[pos].last_name}',
                                                                      style: const TextStyle(
                                                                          color: AppTheme
                                                                              .textColor,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          150,
                                                                      child:
                                                                          Text(
                                                                        friendsBloc
                                                                            .state
                                                                            .searchFriendList[pos]
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
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
                                        : Container(
                                            height: 400,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: friendsBloc
                                                    .state.friendList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int pos) {
                                                  return Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          _myTimer?.cancel();
                                                          Navigator.pop(
                                                              context);

                                                          final data = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => ChatScreen(
                                                                      friendsBloc
                                                                          .state
                                                                          .friendList[
                                                                              pos]
                                                                          .id!,
                                                                      friendsBloc
                                                                              .state
                                                                              .friendList[
                                                                                  pos]
                                                                              .first_name! +
                                                                          ' ' +
                                                                          friendsBloc
                                                                              .state
                                                                              .friendList[
                                                                                  pos]
                                                                              .last_name!,
                                                                      friendsBloc
                                                                          .state
                                                                          .friendList[
                                                                              pos]
                                                                          .avatar!)));
                                                          if (data != null) {
                                                            _startTimer();
                                                          }
                                                        },
                                                        child: Card(
                                                          elevation: 5,
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Padding(
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





                                                                /* CircleAvatar(
                                                                  radius: 23.0,
                                                                  backgroundImage:
                                                                      NetworkImage(friendsBloc
                                                                          .state
                                                                          .friendList[
                                                                              pos]
                                                                          .avatar!),
                                                                ),*/
                                                                const SizedBox(
                                                                    width: 10),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      '${friendsBloc.state.friendList[pos].first_name} ${friendsBloc.state.friendList[pos].last_name}',
                                                                      style: const TextStyle(
                                                                          color: AppTheme
                                                                              .textColor,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          150,
                                                                      child:
                                                                          Text(
                                                                        friendsBloc
                                                                            .state
                                                                            .friendList[pos]
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                          )
                        ],
                      ),
                    );
                  },
                ));
          });
        });
  }

  _executeFriendsAPI() {
    var formData = {'auth_key': AppModel.authKey};
    friendsBloc.fetchAllFriends(context, formData);
  }

  String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;




    /* var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    final DateFormat timeFormatter = DateFormat('h:mma');
    String dayAsString = timeFormatter.format(dateLocal);
    return dayAsString;*/
  }

  @override
  void dispose() {
    _myTimer!.cancel();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    print(enteredKeyword);
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = contactsList;
    } else {
      List<dynamic> results1 = contactsList
          .where((friend) => friend['first_name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      List<dynamic> results2 = [];

     /* results2 = contactsList
          .where((friend) => friend['group_name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();*/
      results = results1;

      //   results=results1;

    }

    // Refresh the UI
    setState(() {
      searchContactsList = results;
    });
  }

  void _runFilterDialog(String enteredKeyword) {
    List<Friends> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = friendsBloc.state.friendList;
    } else {
      results = friendsBloc.state.friendList
          .where((friend) => friend.first_name!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    friendsBloc.updateSearchList(results);
  }
}
