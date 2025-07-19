
import 'package:aha_project_files/view/about_screen.dart';
import 'package:aha_project_files/view/privacy_policy.dart';
import 'package:aha_project_files/view/terms_scereen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/terms_separate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';

class TermsList extends StatefulWidget
{

  TermsState createState()=>TermsState();
}



class TermsState extends State<TermsList>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:Stack(
        children: [
        //  BackgroundWidget(),
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

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyScreen()));

                },
                child: Container(
                  height: 55,
                  child: Row(
                    children: [

                      SizedBox(width: 10),
                      Text(
                        'Privacy Policy',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 15),
                      ),

                      Spacer(),

                      Icon(Icons.keyboard_arrow_right,size: 32),

                      SizedBox(width: 10),




                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsScreen2()));

                },
                child: Container(
                  height: 55,
                  child: Row(
                    children: [

                      SizedBox(width: 10),
                      Text(
                        'Terms of Use',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 15),
                      ),

                      Spacer(),

                      Icon(Icons.keyboard_arrow_right,size: 32),

                      SizedBox(width: 10),




                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutScreen()));

                },
                child: Container(
                  height: 55,
                  child: Row(
                    children: [

                      SizedBox(width: 10),
                      Text(
                        'About app',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 15),
                      ),

                      Spacer(),

                      Icon(Icons.keyboard_arrow_right,size: 32),

                      SizedBox(width: 10),




                    ],
                  ),
                ),
              )


            ],
          )


        ],
      )


    ));
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

}