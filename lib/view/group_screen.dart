import 'dart:io';

import 'package:aha_project_files/network/bloc/profile_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/view/group_detail_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../models/all_groups_model.dart';
import '../models/app_modal.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';
import 'my_group_invites.dart';

class GroupScreen extends StatefulWidget {
  GroupState createState() => GroupState();
}

class GroupState extends State<GroupScreen> {
  final groupBloc = Modular.get<ProfileCubit>();
  File? _image;
  final picker = ImagePicker();
  var groupNameController = TextEditingController();
  var groupDescController = TextEditingController();
  List<AllGroup> groupSearchList = [];
  var searchController = TextEditingController();
  final authBloc = Modular.get<AuthCubit>();


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
              Column(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [



                        Expanded(
                          child: Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: SizedBox(
                              height: 45,
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
                                    suffixIcon: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.search,
                                          color: AppTheme.gradient4,
                                          size: 25,
                                        )),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 12.0, 0.0, 12.0),
                                    hintText: 'Search Group',
                                    hintStyle: const TextStyle(
                                      fontSize: 17.0,
                                      color: Color(0XFFA6A6A6),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 17),
                        height: 40,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppTheme.navigationRed),
                            ),
                            onPressed: (){
                              groupNameController.text='';
                              groupDescController.text='';
                              _image=null;
                              addGroupDialog(context);


          },
                            child: const Text("Create Group",
                                style: TextStyle(fontSize: 15))),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () async {
                            final data= await Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInvites()));
                            if(data!=null)
                            {
                              _executeAPI();
                            }
                          },
                          child: const Text(
                            'Group Invites',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                Colors.blueGrey,
                                fontSize: 14),
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: groupBloc.state.isLoading
                          ? Loader():

                      groupBloc.state.myGroupList.length==0?

                      Center(
                        child: Text('No Groups found'),
                      )

                          :
                      groupSearchList.length != 0 ||
                          searchController.text.isNotEmpty
                          ?
                      ListView.builder(
                          itemCount: groupSearchList.length,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    bool isAdmin=false;
                                    if (groupSearchList[pos].created_by == authBloc.state.userId) {
                                      isAdmin = true;
                                    }
                                    print(groupSearchList[pos].group_name!);
                                    final data= await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupDetail(groupSearchList[pos].id!)));
                                    if(data!=null)
                                    {
                                      _executeAPI();
                                    }
                                  },
                                  child: Card(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                    elevation: 4,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 11,
                                          right: 11),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [

                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child:
                                            CachedNetworkImage(
                                              width: 63,
                                              height: 63,
                                              fit: BoxFit.cover,
                                              imageUrl:groupSearchList[pos]
                                                  .group_avatar_tem!
                                                  .toString(),
                                              placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                              errorWidget: (context, url, error) => Container(),
                                            ),



                                         /*   Image.network(
                                                groupSearchList[pos]
                                                    .group_avatar_tem!,
                                                width: 63,
                                                height: 63,
                                                fit: BoxFit.cover),*/
                                          ),




                                          /*  ClipOval(
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(30),
                                                  // Image radius
                                                  child: Image.network(
                                                      AppConstant.groupImageURL +
                                                          groupBloc
                                                              .state
                                                              .allGroupList[pos]
                                                              .group_avatar,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),*/

                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 7),
                                                Text(
                                                  groupSearchList[pos]
                                                      .group_name!,
                                                  style: const TextStyle(
                                                      color:
                                                      Color(0xFf414141),
                                                      fontSize: 15),
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 5),
                                                  child: Text(
                                                    groupSearchList[pos]
                                                        .group_about!,
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                        FontWeight.w300,
                                                        fontSize: 11),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          groupSearchList[pos].created_by==authBloc.state.userId?Text('Admin',style: TextStyle(
                                              color: Colors.green
                                          ),):Container()

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12)
                              ],
                            );
                          }):


                      ListView.builder(
                          itemCount: groupBloc.state.myGroupList.length,
                          itemBuilder: (BuildContext context, int pos) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    bool isAdmin=false;
                                    if (groupBloc.state.myGroupList[pos].created_by == authBloc.state.userId) {
                                      isAdmin = true;
                                    }
                                    final data= await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupDetail(groupBloc.state.myGroupList[pos].id!)));
                                    if(data!=null)
                                    {
                                      _executeAPI();
                                    }
                                  },
                                  child: Card(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                    elevation: 4,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 11,
                                          right: 11),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [

                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child:
                                            CachedNetworkImage(
                                              width: 63,
                                              height: 63,
                                              fit: BoxFit.cover,
                                              imageUrl: groupBloc
                                                  .state
                                                  .myGroupList[pos]
                                                  .group_avatar_tem!
                                                  .toString(),
                                              placeholder: (context, url) => Image.asset('assets/thumb2.jpeg'),
                                              errorWidget: (context, url, error) => Container(),
                                            ),


/*
                                            Image.network(
                                                groupBloc
                                                    .state
                                                    .myGroupList[pos]
                                                    .group_avatar_tem!,
                                                width: 63,
                                                height: 63,
                                                fit: BoxFit.cover),*/
                                          ),




                                          /*  ClipOval(
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(30),
                                                  // Image radius
                                                  child: Image.network(
                                                      AppConstant.groupImageURL +
                                                          groupBloc
                                                              .state
                                                              .allGroupList[pos]
                                                              .group_avatar,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),*/

                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 7),
                                                Text(
                                                  groupBloc
                                                      .state
                                                      .myGroupList[pos]
                                                      .group_name!,
                                                  style: const TextStyle(
                                                      color:
                                                      Color(0xFf414141),
                                                      fontSize: 15),
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      right: 5),
                                                  child: Text(
                                                    groupBloc
                                                        .state
                                                        .myGroupList[pos]
                                                        .group_about!,
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                        FontWeight.w300,
                                                        fontSize: 11),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          groupBloc
                                              .state
                                              .myGroupList[pos].created_by==authBloc.state.userId?Text('Admin',style: TextStyle(
                                              color: Colors.green
                                          ),):Container()

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12)
                              ],
                            );
                          }))
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

  void addGroupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), //this right here
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Create Group',
                                style: TextStyle(
                                    color: Color(0XFF606060),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: _image != null
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10.0),
                              child: Image.file(
                                _image!,
                                width: 100,
                                height: 80,
                              ),
                            )
                                : GestureDetector(
                              onTap: () async {
                                bool status = await getImage();
                                if (status) {
                                  setState(() {});
                                }
                              },
                              child:



                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: AppTheme.gradient4
                                        .withOpacity(0.4)),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Group avatar',
                              style: TextStyle(
                                  color: Color(0XFF606060), fontSize: 17),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 50,
                            margin:
                            const EdgeInsets.symmetric(horizontal: 7),
                            child: TextField(
                              controller: groupNameController,
                              textInputAction: TextInputAction.go,
                              onTap: () {},
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                hintText: 'Group Name',
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              maxLines: 2,
                              controller: groupDescController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.5),
                                      fontSize: 14,
                                      fontFamily: 'Baumans'),
                                  hintText: 'Description/About',
                                  fillColor: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: 6),
                            height: 35,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppTheme.navigationRed)),
                                onPressed: () {
                                  if (groupNameController.text.isNotEmpty &&
                                      groupDescController.text.isNotEmpty) {
                                    _createGroup();
                                    Navigator.pop(context);
                                  }
                                  else
                                    {
                                      Toast.show('Description/Group name cannot be left empty',
                                          duration: Toast.lengthShort,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.blue);
                                    }
                                },
                                child: const Text("Create",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  @override
  void initState() {
    super.initState();
    _executeAPI();
  }

  _executeAPI() {
    var formData = {'auth_key': AppModel.authKey};
    groupBloc.fetchAllGroups(context, formData);
  }

  _createGroup() async {
    var requestModel;
    if (_image == null) {
      requestModel = FormData.fromMap({
        'group_name': groupNameController.text,
        'group_about': groupDescController.text,
        'auth_key': AppModel.authKey,
      });
    } else {
      requestModel = FormData.fromMap({
        'group_name': groupNameController.text,
        'group_about': groupDescController.text,
        'auth_key': AppModel.authKey,
        'group_avatar': await MultipartFile.fromFile(_image!.path),
      });
    }
 bool apiStatus=await groupBloc.createGroup(context, requestModel);
    if(apiStatus)
      {
        _executeAPI();
      }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);
    if (pickedFile != null) {
      _image = File(pickedFile.path);

      if(Platform.isIOS)
        {
          _image= await FlutterExifRotation.rotateImage(path: _image!.path);
        }

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  void _runFilter(String enteredKeyword) {
    List<AllGroup> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all hobbies
      results = groupBloc.state.myGroupList;
    } else {
      results = groupBloc.state.myGroupList
          .where((friend) => friend.group_name!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      groupSearchList = results;
    });
  }
}
