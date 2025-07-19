import 'dart:convert';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../models/all_friends_model.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';

class GroupMembers extends StatefulWidget {
  final int groupId;
  bool isAdmin;

  GroupMembers(this.groupId, this.isAdmin);

  @override
  GroupState createState() => GroupState();
}

class GroupState extends State<GroupMembers> {
  bool isLoading = false;
  List<dynamic> membersList = [];
  List<dynamic> searchList = [];
  var searchController = TextEditingController();

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
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Members(${membersList.length})',
                    style: TextStyle(
                        color: Color(0xff867983),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 5),
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
                        hintText: 'Search members',
                        labelStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      )),
                ),
                Expanded(
                    child: isLoading
                        ? Loader()
                        : membersList.length == 0
                            ? Center(
                                child: Text('No Members found'),
                              )
                            : searchList.length != 0 ||
                                    searchController.text.isNotEmpty
                                ? ListView.builder(
                                    itemCount: searchList.length,
                                    padding: EdgeInsets.only(top: 15),
                                    itemBuilder: (BuildContext context, int pos) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FriendProfile(
                                              searchList[
                                              pos]
                                                  .id)));
                                            },
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                  //color: Color(0xFFFFC3CA),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 2,
                                                        color: Colors.grey,
                                                        spreadRadius: 1)
                                                  ],
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
                                                                  searchList[pos]
                                                                      ['avatar']),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                searchList[pos][
                                                                        'first_name'] +
                                                                    ' ' +
                                                                    searchList[pos][
                                                                        'last_name'],
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
                                                                  searchList[pos]
                                                                      ['country'],
                                                                  style: const TextStyle(
                                                                      color: AppTheme
                                                                          .textColor,
                                                                      fontSize: 11),
                                                                  maxLines: 4,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),


                                                              const SizedBox(height: 5),



                                                              widget.isAdmin
                                                                  ? GestureDetector(
                                                                onTap: (){
                                                                    removeMember(searchList[pos]['id']);
                                                                },
                                                                    child: const Text(
                                                                    "Remove",
                                                                    style:
                                                                    TextStyle(fontSize: 15,color: Colors.red)),
                                                                  )
                                                                  : Container()

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
                                    })
                                : ListView.builder(
                                    itemCount: membersList.length,
                                    padding: const EdgeInsets.only(top: 15),
                                    itemBuilder: (BuildContext context, int pos) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FriendProfile(
                                              membersList[pos]
                                              ['id'])));
                                            },
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                  //color: Color(0xFFFFC3CA),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 2,
                                                        color: Colors.grey,
                                                        spreadRadius: 1)
                                                  ],
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
                                                                  membersList[pos]
                                                                      ['avatar']),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              membersList[pos][
                                                                      'first_name'] +
                                                                  ' ' +
                                                                  membersList[pos]
                                                                      [
                                                                      'last_name'],
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
                                                                membersList[pos]
                                                                    ['country'],
                                                                style: const TextStyle(
                                                                    color: AppTheme
                                                                        .textColor,
                                                                    fontSize: 11),
                                                                maxLines: 4,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            widget.isAdmin
                                                                ? GestureDetector(
                                                              onTap: (){
                                                                removeMember(membersList[pos]['id']);
                                                              },
                                                              child: const Text(
                                                                  "Remove",
                                                                  style:
                                                                  TextStyle(fontSize: 15,color: Colors.red)),
                                                            )
                                                                : Container()

                                                          ],
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

    fetchMembers(context);
  }

  fetchMembers(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var formData = {'auth_key': AppModel.authKey, 'group_id': widget.groupId};
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('groupMembers', formData, context);
    isLoading = false;
    var responseJson = jsonDecode(response.body.toString());
    membersList = responseJson['group_users'];
    print(responseJson);
    setState(() {});
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = membersList;
    } else {
      results = membersList
          .where((friend) => friend['first_name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchList = results;
    });
  }

  String _parseServerDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.yMMM();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }

  removeMember(int memberID) async {
    APIDialog.showAlertDialog(context, 'Removing member...');
    var formData = {
      'auth_key': AppModel.authKey,
      'group_id': widget.groupId,
      'member_id': memberID
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('removeGroupMember', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    if (responseJson['status'] == 1) {
      Toast.show(responseJson['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      fetchMembers(context);
    }
  }
}
