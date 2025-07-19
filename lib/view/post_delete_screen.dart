
import 'dart:io';

import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/change_password_screen.dart';
import 'package:aha_project_files/view/edit_profile_screen.dart';
import 'package:aha_project_files/view/privacy_policy.dart';
import 'package:aha_project_files/view/terms_scereen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
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

class PostDeleteScreen extends StatefulWidget
{
  const PostDeleteScreen({Key? key}) : super(key: key);

  @override
  AboutState createState()=>AboutState();
}
class AboutState extends State<PostDeleteScreen>
{



  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(

        body: Stack(
          children: [

         //  BackgroundWidget(),
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
                    'Post Deleted',
                    style: TextStyle(
                        color:Colors.black,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Image.asset('assets/not_allowed.png',width:80,height:80,color: Colors.red),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'We\'ve removed or disabled access to content that you posted to AHAsome recently because your post contains data which is not allowed under AHAsome policy.',
                    style: TextStyle(
                        color:Colors.brown,
                        height: 2,
                        fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                       // fontWeight: FontWeight.w600,
                        height: 2,
                        color:Colors.brown,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'For more information please visit our '),
                        TextSpan(text: 'Terms & conditions', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                          recognizer:  TapGestureRecognizer()..onTap = () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsScreen2()));


                          },



                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(text: 'Privacy Policy', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                          recognizer:  TapGestureRecognizer()..onTap = () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyScreen()));

                          },

                        ),

                      ],
                    ),
                  ),
                ),


//For more information visit our terms and privacy policy.Thanks

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

  }




}