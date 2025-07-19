
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:toast/toast.dart';

import '../models/app_modal.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../network/bloc/friends_bloc.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';

class EditHobbyScreen extends StatefulWidget
{
  List<String> hobbiesList;
  EditHobbyScreen(this.hobbiesList);
  EditState createState()=>EditState(hobbiesList);
}
class EditState extends State<EditHobbyScreen>
{
  List<String> tabAddedList;
  EditState(this.tabAddedList);
  List<dynamic> hobbiesAPIList = [];
  List<dynamic> hobbiesSearchAPIList = [];
  final authBloc = Modular.get<AuthCubit>();
  final friendsBloc = Modular.get<FriendsCubit>();
  bool hobbiesVisibility = false;
  TextEditingController hobbiesController = TextEditingController();
  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
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

            const SizedBox(height: 20),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              child: TextField(
                controller: hobbiesController,
                focusNode: focusNode,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    hobbiesVisibility = false;
                  });
                },
                onTap: () {
                  setState(() {
                    hobbiesVisibility = true;
                  });
                },
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: const InputDecoration(
                    labelText: 'Search Hobbies',
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppTheme.navigationRed,
                    )),
              ),
            ),

            SizedBox(height: 20),



            Stack(
              children: [
                Visibility(
                  visible: tabAddedList.isNotEmpty ? true : false,
                  child: SizedBox(
                    height: 42,
                    child: ListView.builder(
                        padding: const EdgeInsets.only(left: 8),
                        itemCount: tabAddedList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int pos) {
                          return Row(
                            children: [
                              Container(
                                height: 42,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: const Color(0xff4DBD33),
                                    borderRadius:
                                    BorderRadius.circular(30)),
                                child: Row(
                                  children: [
                                    Text(
                                      tabAddedList[pos],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () {
                                        tabAddedList
                                            .remove(tabAddedList[pos]);
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          );
                        }),
                  ),
                ),
                Visibility(
                    visible: hobbiesVisibility,
                    child: Container(
                      height: 250,
                      padding: const EdgeInsets.only(left: 10),
                      color: const Color(0xFFF8E4FF),
                      child: hobbiesSearchAPIList.length != 0 ||
                          hobbiesController.text.isNotEmpty
                          ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: hobbiesSearchAPIList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              hobbiesController.clear();
                              hobbiesVisibility = false;
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());

                              if (tabAddedList.length < 3) {
                                if (!tabAddedList.contains(
                                    hobbiesSearchAPIList[index]
                                    ['name'])) {
                                  tabAddedList.add(
                                      hobbiesSearchAPIList[index]
                                      ['name']);
                                }
                              } /*else if (tabAddedListOrange.length <
                                  2) {
                                if (!tabAddedListOrange.contains(
                                    hobbiesSearchAPIList[index]
                                    ['name']) && !tabAddedList.contains(
                                    hobbiesSearchAPIList[index]
                                    ['name'])) {
                                  tabAddedListOrange.add(
                                      hobbiesSearchAPIList[index]
                                      ['name']);
                                }
                              }*/

                              setState(() {});

                              // List Adding Logic
                            },
                            child: Container(
                                color: const Color(0xFFF8E4FF),
                                /*key: ValueKey(
                                                            _foundUsers[index]),*/
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12),
                                      child: Text(
                                        hobbiesSearchAPIList[index]
                                        ['name'],
                                        style: const TextStyle(
                                            fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 1,
                                      color: Colors.white,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                    )
                                  ],
                                )),
                          ))
                          : Container(
                          height: 250,
                          color: const Color(0xFFF8E4FF),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: hobbiesAPIList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  hobbiesController.clear();
                                  hobbiesVisibility = false;

                                  if (tabAddedList.length <5) {
                                    if (!tabAddedList.contains(
                                        hobbiesAPIList[index]
                                        ['name'])) {
                                      tabAddedList.add(
                                          hobbiesAPIList[index]
                                          ['name']);
                                    }
                                  }/* else if (tabAddedListOrange
                                      .length <
                                      2) {
                                    if (!tabAddedListOrange.contains(
                                        hobbiesAPIList[index]
                                        ['name']) && !tabAddedList.contains(
                                        hobbiesAPIList[index]
                                        ['name'])) {
                                      tabAddedListOrange.add(
                                          hobbiesAPIList[index]
                                          ['name']);
                                    }
                                  }*/

                                  /* if (!tabAddedList.contains(
                                                  hobbiesAPIList[index]
                                                      ['name'])) {
                                                tabAddedList.add(
                                                    hobbiesAPIList[index]
                                                        ['name']);
                                              }
*/
                                  setState(() {});
                                },
                                child: Container(
                                    color: const Color(0xFFF8E4FF),
                                    key: ValueKey(
                                        hobbiesAPIList[index]
                                        ['name']),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              top: 12,
                                              bottom: 12),
                                          child: Text(
                                            hobbiesAPIList[index]
                                            ['name'],
                                            style: const TextStyle(
                                                fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          height: 1,
                                          color: Colors.white,
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                        )
                                      ],
                                    )),
                              ))),
                    ))

              ],
            ),

            const SizedBox(height: 20),


            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.themeColor),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12)),
                              side: BorderSide(
                                  color: AppTheme.themeColor)))),
                  onPressed: (){

                    _editHobbies();
                  },
                  child: const Text("Update Hobbies",
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600))),
            ),











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

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = hobbiesAPIList;
    } else {
      results = hobbiesAPIList
          .where((hobbie) => hobbie['name']
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      hobbiesSearchAPIList = results;
    });
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      fetchHobbies(context);
    });
  }
  fetchHobbies(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Fetching hobbies...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('hobbiesList', context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    setState(() {
      hobbiesAPIList = responseJson['show_hobbies'];
    });
  }



  _editHobbies(){

    if(tabAddedList.length<3)
      {
        Toast.show('Please select atleast 3 hobbies',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else
      {
        updateHobbies(context);
      }


  }

  updateHobbies(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Updating hobbies...');
    var formData = {
      'auth_key': AppModel.authKey,
      'hobbies': tabAddedList,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('editHobbies', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    Navigator.pop(context,'Updation Done');
    print(responseJson);
    if (responseJson['status'] == AppConstant.apiSuccess) {
      Toast.show(responseJson['message'],
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    //  _callAPI();
      Navigator.pop(context, 'Profile Updated');
    }
    else
      {
        Toast.show(responseJson['message'],
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
      }
  }

  _callAPI() {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id': authBloc.state.userId
    };
    friendsBloc.fetchFriendProfile(context, requestModel);
  }
}