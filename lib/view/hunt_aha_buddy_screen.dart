import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/friend_profile.dart';
import 'package:aha_project_files/view/map_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_modal.dart';
import '../models/find_friends_model.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/rounded_image_widget.dart';
import '../widgets/user_profile.dart';
/*enum SelectedTab {
  Male,
  Female
}*/
class HuntAHABuddy extends StatefulWidget {
  const HuntAHABuddy({Key? key}) : super(key: key);

  @override
  HuntAHAState createState() => HuntAHAState();
}

class HuntAHAState extends State<HuntAHABuddy> {
  bool tab1 = true;
  bool tab2 = false;
  final authBloc = Modular.get<AuthCubit>();

  bool tab3 = false;
  String hintText='Search Friends by hobbies';
  final friendsBloc=Modular.get<FriendsCubit>();
  List<FindFriend> searchFriendList=[];
  var searchController=TextEditingController();
  List<String>? blockList;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child:

          Scaffold(
            backgroundColor: Colors.white,
            body: BlocBuilder(
              bloc: friendsBloc,
              builder: (context,state)
              {
                return Stack(
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
                            icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
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
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child:
                          Text(
                            'Hunt AHA Buddy',
                            style: TextStyle(
                                color: Color(0xFfDD2E44),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),

                        ),
                        const SizedBox(height: 13),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 45,
                          color: const Color(0xffFFC3CA).withOpacity(0.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  tab1 = true;
                                  tab2 = false;
                                  tab3 = false;
                                  searchController.text='';
                                  /* if(searchFriendList.length!=0)
                                {
                                  searchFriendList.clear();
                                }*/
                                  hintText='Search Friends by hobbies';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: tab1
                                      ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppTheme.gradient4,
                                          width: tab2 ? 1.3 : 0))
                                      : const BoxDecoration(),
                                  child:  Text(
                                    'Hobbies',
                                    style:
                                    TextStyle(color:tab1?AppTheme.navigationRed:Colors.black87, fontSize: 15),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  tab1 = false;
                                  tab2 = true;
                                  tab3 = false;
                                  searchController.text='';
                                  /* if(searchFriendList.length!=0)
                                {
                                  searchFriendList.clear();
                                }*/

                                  hintText='Search Friends by name';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: tab2
                                      ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppTheme.gradient4,
                                          width: tab2 ? 1.3 : 0))
                                      : const BoxDecoration(),
                                  child:  Text(
                                    'Name',
                                    style:
                                    TextStyle(color:tab2?AppTheme.navigationRed:Colors.black87, fontSize: 15),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  tab1 = false;
                                  tab2 = false;
                                  tab3 = true;
                                  searchController.text='';
                                  /* if(searchFriendList.length!=0)
                                {
                                  searchFriendList.clear();
                                }*/
                                  hintText='Search Friends by location';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: tab3
                                      ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppTheme.gradient4,
                                          width: tab3 ? 1.3 : 0))
                                      : const BoxDecoration(),
                                  child: Text(
                                    'Location',
                                    style:
                                    TextStyle(color:tab3?AppTheme.navigationRed:Colors.black87,fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 13),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                              controller: searchController,

                              onChanged: (value) {

                                if(tab1)
                                {
                                  _runFilterHobbies(value);

                                }
                                else if(tab2)
                                {
                                  _runFilter(value);
                                }
                                else
                                {
                                  _runFilterLocation(value);
                                }


                              },

                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFfDD2E44), shape: BoxShape.circle),
                                  child: const Center(
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                fillColor: AppTheme.gradient1.withOpacity(0.4),
                                filled: true,
                                contentPadding:
                                const EdgeInsets.fromLTRB(20.0, 12.0, 0.0, 12.0),
                                hintText: hintText,
                                labelStyle: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                            child:
                            friendsBloc.state
                                .isLoading?Center(
                              child: Loader(),
                            ):
                            Container(
                                padding: const EdgeInsets.only(top: 25),
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFFC3CA).withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child:
                                searchFriendList.length != 0 || searchController.text.isNotEmpty?
                                ListView.builder(
                                    itemCount: searchFriendList.length,
                                    itemBuilder: (BuildContext context, int pos) {
                                      return
                                        blockList!.contains(friendsBloc
                                            .state
                                            .findFriendList[
                                        pos]
                                            .id!.toString())?
                                        Container():



                                        Column(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                print(searchFriendList[pos].first_name);
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfile(searchFriendList[pos].id!)));
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.gradient1.withOpacity(0.4),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10, left: 8, right: 8),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    RoundedImageWidget(
                                                        searchFriendList[pos].avatar!
                                                    ),
                                                    /* CircleAvatar(
                                                radius: 28.0,
                                                backgroundImage:
                                                NetworkImage(searchFriendList[pos].avatar!),
                                              ),*/
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '${searchFriendList[pos].first_name} ${searchFriendList[pos].last_name}',
                                                            style: const TextStyle(
                                                                color: AppTheme.textColor,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 13),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),


                                                          Text(
                                                            tab3?
                                                            searchFriendList[pos].country!:
                                                            searchFriendList[pos].hobbies.toString(),
                                                            style: const TextStyle(
                                                                color: AppTheme.textColor,
                                                                fontSize: 11),
                                                            maxLines: 3,
                                                            overflow: TextOverflow.visible,
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(width: 5),

                                                    searchFriendList[pos].friend_status==null?
                                                    GestureDetector(
                                                      onTap: (){


                                                        _followUser(searchFriendList[pos].id!);
                                                      },
                                                      child:  Container(
                                                          margin: EdgeInsets.only(
                                                              top: 15, right: 3),
                                                          padding:EdgeInsets.only(top: 5,left: 5,bottom: 5),
                                                          child:



                                                          Icon(
                                                            Icons.person_add_alt_1_rounded,
                                                            color: AppTheme.gradient4,
                                                            size: 33,
                                                          )),
                                                    ):

                                                    searchFriendList[pos].friend_status==1?
                                                    // friends
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 15, right: 5),
                                                        child:

                                                        Icon(
                                                          Icons.done_outline,
                                                          color: Colors.green,
                                                          size: 30,
                                                        )):


                                                    searchFriendList[pos].friend_status==0?


                                                    searchFriendList[pos].request_from_id==authBloc.state.userId?
                                                    // My Sent Pending Requests
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 15, right: 5),
                                                        child:

                                                        Container(
                                                          //  color: Colors.red,
                                                          width:38,
                                                          height:30,
                                                          child: Stack(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: Colors.limeAccent,
                                                                size: 30,
                                                              ),

                                                              Align(
                                                                alignment:Alignment.topRight,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 2),
                                                                  child: Icon(
                                                                    Icons.done,
                                                                    color: Colors.limeAccent,
                                                                    size: 17,
                                                                  ),
                                                                ),
                                                              )

                                                            ],
                                                          ),
                                                        )
                                                      // Image.asset('assets/my_pending_icc.png',width: 35,height: 35,color: Colors.yellow,)
                                                    ):


                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 15, right: 5),
                                                        child:

                                                        Container(
                                                          //  color: Colors.red,
                                                          width:34,
                                                          height:30,
                                                          child: Stack(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: Colors.limeAccent,
                                                                size: 30,
                                                              ),

                                                              Align(
                                                                alignment:Alignment.topRight,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 2),
                                                                  child: Icon(
                                                                    Icons.subdirectory_arrow_left,
                                                                    color: Colors.limeAccent,
                                                                    size: 17,
                                                                  ),
                                                                ),
                                                              )

                                                            ],
                                                          ),
                                                        )




                                                      /* Icon(
                                                    Icons.people_alt,
                                                    color: Colors.green,
                                                    size: 30,
                                                  )*/
                                                    ):
                                                    Container()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        );
                                    }):


                                ListView.builder(
                                    itemCount: friendsBloc.state.findFriendList.length,
                                    itemBuilder: (BuildContext context, int pos) {
                                      return

                                        blockList!.contains(friendsBloc
                                            .state
                                            .findFriendList[
                                        pos]
                                            .id!.toString())?
                                        Container():




                                        Column(
                                          children: [
                                            InkWell(

                                              onTap:() async {

                                                final data=await Navigator.push(context, MaterialPageRoute(builder: (context)=>FriendProfile(friendsBloc.state
                                                    .findFriendList[pos].id!)));


                                                if(data!=null)
                                                {
                                                  fetchBlockValues();
                                                }



                                              },


                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.gradient1.withOpacity(0.4),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10, left: 8, right: 8),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RoundedImageWidget(
                                                        friendsBloc.state.findFriendList[pos].avatar!
                                                    ),



                                                    /*   CircleAvatar(
                                                radius: 28.0,
                                                backgroundImage:
                                                NetworkImage(friendsBloc.state.findFriendList[pos].avatar!),
                                              ),*/
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '${friendsBloc.state.findFriendList[pos].first_name} ${friendsBloc.state.findFriendList[pos].last_name}',
                                                            style: const TextStyle(
                                                                color: AppTheme.textColor,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 13),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            tab3?
                                                            friendsBloc.state.findFriendList[pos].country!:
                                                            friendsBloc.state.findFriendList[pos].hobbies.toString(),
                                                            style: const TextStyle(
                                                                color: AppTheme.textColor,
                                                                fontSize: 11),
                                                            maxLines: 3,
                                                            overflow: TextOverflow.visible,
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(width: 5),

                                                    friendsBloc.state.findFriendList[pos].friend_status==null?
                                                    GestureDetector(
                                                      onTap: (){
                                                       // print('Click triggered');

                                                        _followUser(friendsBloc.state.findFriendList[pos].id!);
                                                      },
                                                      child:  Container(
                                                          margin: EdgeInsets.only(
                                                              top: 15, right: 3),
                                                          padding:EdgeInsets.only(top: 5,left: 5,bottom: 5),
                                                          child:



                                                          Icon(
                                                            Icons.person_add_alt_1_rounded,
                                                            color: AppTheme.gradient4,
                                                            size: 33,
                                                          )),
                                                    ):

                                                    friendsBloc.state.findFriendList[pos].friend_status==1?
                                                    // friends
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 15, right: 5),
                                                        child:

                                                        Icon(
                                                          Icons.done_outline,
                                                          color: Colors.green,
                                                          size: 30,
                                                        )):


                                                    friendsBloc.state.findFriendList[pos].friend_status==0?


                                                    friendsBloc.state.findFriendList[pos].request_from_id==authBloc.state.userId?
                                                    // My Sent Pending Requests
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 15, right: 5),
                                                        child:

                                                        Container(
                                                          //  color: Colors.red,
                                                          width:38,
                                                          height:30,
                                                          child: Stack(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: Colors.limeAccent,
                                                                size: 30,
                                                              ),

                                                              Align(
                                                                alignment:Alignment.topRight,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 2),
                                                                  child: Icon(
                                                                    Icons.done,
                                                                    color: Colors.limeAccent,
                                                                    size: 17,
                                                                  ),
                                                                ),
                                                              )

                                                            ],
                                                          ),
                                                        )
                                                      // Image.asset('assets/my_pending_icc.png',width: 35,height: 35,color: Colors.yellow,)
                                                    ):


                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 15, right: 5),
                                                        child:

                                                        Container(
                                                          //  color: Colors.red,
                                                          width:34,
                                                          height:30,
                                                          child: Stack(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: Colors.limeAccent,
                                                                size: 30,
                                                              ),

                                                              Align(
                                                                alignment:Alignment.topRight,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 2),
                                                                  child: Icon(
                                                                    Icons.subdirectory_arrow_left,
                                                                    color: Colors.limeAccent,
                                                                    size: 17,
                                                                  ),
                                                                ),
                                                              )

                                                            ],
                                                          ),
                                                        )




                                                      /* Icon(
                                                    Icons.people_alt,
                                                    color: Colors.green,
                                                    size: 30,
                                                  )*/
                                                    ):
                                                    Container()






                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        );
                                    })
                            ))
                      ],
                    ),
                  ],
                );
              }


              ,
            )
          )


      ),
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

  _executeAPI() async {
    var requestModel = {'auth_key': AppModel.authKey};
    friendsBloc.fetchFindFriends(context, requestModel);

  }


  void _runFilter(String enteredKeyword) {
    List<FindFriend> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = friendsBloc.state.findFriendList;
    } else {
      results = friendsBloc.state.findFriendList
          .where((friend) => friend.first_name!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchFriendList = results;
    });
  }


  void _runFilterHobbies(String enteredKeyword) {
    List<FindFriend> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = friendsBloc.state.findFriendList;
    } else {
      results = friendsBloc.state.findFriendList
          .where((friend) => friend.hobbies.toString()
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchFriendList = results;
    });
  }

  void _runFilterLocation(String enteredKeyword) {
    List<FindFriend> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = friendsBloc.state.findFriendList;
    } else {
      results = friendsBloc.state.findFriendList
          .where((friend) => friend.country!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchFriendList = results;
    });
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

  _followUser(int id) async {
    var requestModel = {
      'auth_key': AppModel.authKey,
      'friend_id':id
    };
    bool apiStatus = await friendsBloc.addFriend(context, requestModel);
    if (apiStatus) {
      _executeAPI();
    }
  }

}
