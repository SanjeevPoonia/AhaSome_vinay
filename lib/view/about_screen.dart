
import 'dart:io';

import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/change_password_screen.dart';
import 'package:aha_project_files/view/edit_profile_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/app_modal.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/loader.dart';

class AboutScreen extends StatefulWidget
{
  const AboutScreen({Key? key}) : super(key: key);

  @override
  AboutState createState()=>AboutState();
}
class AboutState extends State<AboutScreen>
{
  final dashBoardBloc = Modular.get<DashboardCubit>();
  final authBloc = Modular.get<AuthCubit>();
  File? _image;
  final picker = ImagePicker();



  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(

        body: Stack(
          children: [

          // BackgroundWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'About Us',
                    style: TextStyle(
                        color:Colors.black,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'The Purpose of this AHA application is to bring all happy people under one roof who can share their Happy moments, good experience & cheerful feelings to their close ones and friends. The intent is to spread happiness over internet',
                    style: TextStyle(
                        color:Colors.grey,
                        height: 1.6,
                        fontSize: 14),
                  ),
                ),





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
    _callAPI();
  }

  _callAPI(){
    var requestModel={
      'auth_key':AppModel.authKey
    };

    dashBoardBloc.fetchAboutUser(context, requestModel);
  }

  _updateImage() async {
    FormData requestModel = FormData.fromMap({
      'auth_key': AppModel.authKey,
      'avatar':await MultipartFile.fromFile(_image!.path),
    });
    authBloc.updateProfileImage(context,requestModel);
  }

  void _editProfileSheet(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        ),
        builder: (builder){
          return Container(
            height: 350.0,
            color: Colors.transparent,
            child: Container(
                decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Column(
                  children: [

                    SizedBox(height: 20),

                    Row(
                      children: const [
                        Spacer(),
                        Icon(Icons.close),

                        SizedBox(width: 10),


                      ],
                    ),

                    SizedBox(height: 20),








                  ],
                )),
          );
        }
    );
  }
}