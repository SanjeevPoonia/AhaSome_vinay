import 'dart:convert';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../models/all_friends_model.dart';

import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/bloc/friends_bloc.dart';
import '../network/bloc/profile_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';

class SendInvites extends StatefulWidget {
  final int groupId;

  SendInvites(this.groupId);

  @override
  GroupState createState() => GroupState();
}

class GroupState extends State<SendInvites> {
  bool isLoading = false;
  var searchController = TextEditingController();
  List<int> selectedMembersId=[];
  List<dynamic> membersList = [];
  List<dynamic> invitedMembers=[];
  List<dynamic> searchMemberList=[];
  List<dynamic> finalMembers=[];
  List<String> ids=[];

  final friendsBloc = Modular.get<FriendsCubit>();
  List<String>? blockList;

  final groupBloc = Modular.get<ProfileCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
        body: Stack(
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
                    icon:
                        const Icon(Icons.more_vert_outlined, color: Colors.white),
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
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Invite Friends',
                    style: TextStyle(
                        color: Color(0xff867983),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),


                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
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
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 12.0, 0.0, 12.0),
                        hintText: 'Search friends',
                        labelStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      )),
                ),

                const SizedBox(height: 10),

                Expanded(
                    child:
                    isLoading?
                        Loader():

                    searchMemberList.length != 0 ||
                        searchController.text.isNotEmpty
                        ?
                    ListView.builder(
                        itemCount:
                        searchMemberList.length,
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
                                                searchMemberList[pos]['id'],
                                              )));
                                },
                                child: Container(
                                    margin:
                                    const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                      //color: Color(0xFFFFC3CA),
                                      color: AppTheme.gradient3
                                          .withOpacity(0.4),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 8,
                                        right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            CircleAvatar(
                                              radius: 23.0,
                                              backgroundImage:
                                              NetworkImage(
                                                  searchMemberList[pos]['avatar']),
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
                                                    searchMemberList[pos]['first_name']+' '+ searchMemberList[pos]['last_name'],
                                                    style: const TextStyle(
                                                        color: AppTheme
                                                            .textColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(

                                                      searchMemberList[pos]['hobbies']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: AppTheme
                                                              .textColor,
                                                          fontSize:
                                                          10),
                                                      maxLines: 2,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  top: 25),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  ids.contains(searchMemberList[pos]['id']
                                                      .toString())
                                                      ? Container(
                                                    margin: const EdgeInsets
                                                        .only(
                                                        left:
                                                        10,
                                                        top:
                                                        5),
                                                    height:
                                                    30,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.white),
                                                          backgroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.green),
                                                        ),
                                                        onPressed: () => print('Tap blocked'),
                                                        child: const Text("Invited", style: TextStyle(fontSize: 15))),
                                                  )
                                                      : Container(
                                                    margin: const EdgeInsets
                                                        .only(
                                                        left:
                                                        10,
                                                        top:
                                                        5),
                                                    height:
                                                    30,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.white),
                                                          backgroundColor:
                                                          MaterialStateProperty.all<Color>(AppTheme.navigationRed),
                                                        ),
                                                        onPressed: () => _inviteUser(membersList[pos]['id']),
                                                        child: const Text("Invite", style: TextStyle(fontSize: 15))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        }):


                    ListView.builder(
                        itemCount:
                        finalMembers.length,
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
                                                finalMembers[pos]['id'],
                                              )));
                                },
                                child: Container(
                                    margin:
                                    const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    decoration: BoxDecoration(
                                      //color: Color(0xFFFFC3CA),
                                      color: AppTheme.gradient3
                                          .withOpacity(0.4),
                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 8,
                                        right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            CircleAvatar(
                                              radius: 28.0,
                                              backgroundImage:
                                              NetworkImage(
                                                  finalMembers[pos]['avatar']),
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
                                                    finalMembers[pos]['first_name']+' '+ finalMembers[pos]['last_name'],
                                                    style: const TextStyle(
                                                        color: AppTheme
                                                            .textColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(

                                                      finalMembers[pos]['hobbies']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: AppTheme
                                                              .textColor,
                                                          fontSize:
                                                          11),
                                                      maxLines: 4,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  top: 25),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  ids.contains(finalMembers[pos]['id']
                                                      .toString())
                                                      ? Container(
                                                    margin: const EdgeInsets
                                                        .only(
                                                        left:
                                                        10,
                                                        top:
                                                        5),
                                                    height:
                                                    30,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.white),
                                                          backgroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.green),
                                                        ),
                                                        onPressed: () => print('Tap blocked'),
                                                        child: const Text("Invited", style: TextStyle(fontSize: 15))),
                                                  )
                                                      : Container(
                                                    margin: const EdgeInsets
                                                        .only(
                                                        left:
                                                        10,
                                                        top:
                                                        5),
                                                    height:
                                                    30,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty.all<Color>(Colors.white),
                                                          backgroundColor:
                                                          MaterialStateProperty.all<Color>(AppTheme.navigationRed),
                                                        ),
                                                        onPressed: () => _inviteUser(finalMembers[pos]['id']),
                                                        child: const Text("Invite", style: TextStyle(fontSize: 15))),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        })),
              ],
            )
          ],
        ),
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
    fetchMemberList();
  }



  _inviteUser(int friendId) async {
   /* if(selectedMembersId.isNotEmpty)
      {
        selectedMembersId.clear();
      }*/


    selectedMembersId.add(friendId);

    var formData = {
      'auth_key': AppModel.authKey,
      'group_id': widget.groupId,
      'friend_id': selectedMembersId
    };
    bool apiStatus = await groupBloc.inviteFriend(context, formData);
    if (apiStatus) {
      selectedMembersId.clear();
      ids.add(friendId.toString());
      setState(() {});
     // fetchMemberList();
    }
  }
  fetchMemberList() async {
    setState(() {
      isLoading=true;
    });
    var formData = {'auth_key': AppModel.authKey,'group_id':widget.groupId};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('InviteFriendList', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    membersList=responseJson['friend_list'];
    invitedMembers=responseJson['invited_friend_list'];

    if(ids.length!=0)
      {
        ids.clear();
      }

    for(int i=0;i<invitedMembers.length;i++)
      {
        ids.add(invitedMembers[i]['id'].toString());
      }

    finalMembers=membersList+invitedMembers;




    print(ids.toString());
    isLoading=false;
    setState(() {});
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = finalMembers;
    } else {
      results = finalMembers
          .where((friend) => friend['first_name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchMemberList = results;
    });
  }



}
