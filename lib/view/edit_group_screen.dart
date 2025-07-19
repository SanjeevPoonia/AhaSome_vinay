import 'dart:convert';
import 'dart:io';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/add_gratitude.dart';
import 'package:aha_project_files/utils/strings.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/small_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import '../network/api_helper.dart';
import '../network/bloc/profile_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/image_assets.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/cover_image_widget.dart';
import '../widgets/input_field_simple.dart';

class EditGroupScreen extends StatefulWidget {

  final String groupName,groupDesc,groupImage;
  final int groupId;

  EditGroupScreen(this.groupName,this.groupDesc,this.groupImage,this.groupId);

  @override
  GratitudeState createState() => GratitudeState();
}

class GratitudeState extends State<EditGroupScreen> {

  final authBloc = Modular.get<AuthCubit>();
  File? coverImage;
  TextEditingController nameController = TextEditingController();
  var descController = TextEditingController();


  List<Color> colorList = [
    AppTheme.gratitudeOrange,
    AppTheme.gratitudePink,
    AppTheme.dashboardTeal
  ];
  final groupBloc = Modular.get<ProfileCubit>();

  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          color: AppTheme.navigationRed,
          child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  body: Form(
                    key: _formKey,
                    child:
                    Stack(
                      children: [
                        BackgroundWidget(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                GroupCoverWidget(widget.groupImage.toString()),
                                AppBarNew(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  iconButton: PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert_outlined,
                                        color: Colors.white),
                                    onSelected: handleClick,
                                    itemBuilder: (BuildContext context) {
                                      return {'Report group','Logout'}.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  showBackIc: true,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    getCoverImage();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 60),
                                    height: 200,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 15, bottom: 25),
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Center(
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                              size: 25,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                'Edit Group Info',
                                style: TextStyle(
                                    color: Color(0xFF8A8A8A),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFieldSimple(
                                controller: nameController,
                                labeltext: 'Group Name*',
                                validator: nameValidator,
                                disable: true,
                              ),
                            ),


                            const SizedBox(height: 15),

                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                              ),
                              child: TextFormField(
                                maxLines: 5,
                                validator: nameValidator,
                                style: TextStyle(
                                  fontSize: 13
                                ),
                                maxLength: 250,
                                controller: descController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color:
                                        Colors.grey.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Baumans'),
                                    hintText:
                                    'Group Description',
                                    fillColor: Colors.white),
                              ),
                            ),

                            SizedBox(height: 15),

                            Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 15),
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppTheme.themeColor),
                                  ),
                                  onPressed: () =>
                                      _submitHandler(context),
                                  child: const Text("UPDATE",
                                      style: TextStyle(fontSize: 17))),
                            ),


                          ],
                        )
                      ],
                    )

                    ,
                  ))),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        });
  }

  void _submitHandler(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    updateGroupInfo(context);
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

  updateGroupInfo(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Updating...');
    var formData = {
      'auth_key': AppModel.authKey,
      'group_id':widget.groupId,
      'group_name':nameController.text,
      'group_about':descController.text

    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('updateGroupInfo', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    Navigator.pop(context);
    print(responseJson);
    if (responseJson['status'] == AppConstant.apiSuccess) {
      Toast.show('Updated Successfully',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      var formData22 = {'auth_key': AppModel.authKey};
      groupBloc.fetchAllGroups(context, formData22);
      Navigator.pop(context, 'Group Info Updated');
    }
  }

  @override
  void initState() {

    super.initState();
    fetchValues();

  }

  fetchValues(){
    nameController.text=widget.groupName;
    descController.text=widget.groupDesc;
    setState(() {

    });
  }




  String _parseServerDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.MMMEd();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }








   @override
   void dispose() {
     super.dispose();
   }
  Future getCoverImage() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    if(pickedFile!=null)
      {
        coverImage = File(pickedFile.path);
         if(Platform.isIOS)
    {
      coverImage= await FlutterExifRotation.rotateImage(path: coverImage!.path);
    }
        setState(() {});
        _updateCoverImage();
      }
  }
  _updateCoverImage() async {

    FormData requestModel = FormData.fromMap({
      'auth_key': AppModel.authKey,
      'group_avatar':await MultipartFile.fromFile(coverImage!.path),
      'group_id':widget.groupId,
    });
    updateGroupCover(context,requestModel);
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty || !RegExp(r"[a-zA-Z]").hasMatch(value)) {
      return 'Cannot be empty';
    }
    return null;
  }
  updateGroupCover(BuildContext context, FormData requestModel) async {

    APIDialog.showAlertDialog(context, 'Please wait...');


    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'updateGroupBgImage',
          data: requestModel);
      Navigator.pop(context);
      var responseBody = response.data;
      final jsonData = jsonDecode(responseBody.toString());
      if (jsonData['status'] == AppConstant.apiSuccess) {
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
        var formData = {'auth_key': AppModel.authKey};
        groupBloc.fetchAllGroups(context, formData);
        Navigator.pop(context,'Group Info Updated');
      } else {
        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } catch (errorMessage) {
      String message = errorMessage.toString();
      print(message);
    }
  }
}
