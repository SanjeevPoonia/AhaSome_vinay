
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ProfileWidget extends StatelessWidget
{
  final String iconURI,title;
  final Color iconColor;
  bool showDivider;
  ProfileWidget({required this.title,required this.iconURI,required this.iconColor,required this.showDivider});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1),

        Row(
          children: [

            Image.asset(iconURI,width: 35,height: 35,color: iconColor),

            SizedBox(width: 10,),

            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),



          ],
        ),
        SizedBox(height: 10),


        showDivider?

        Divider(
          color: Colors.white,
          thickness: 0.5,
        ):Container()



      ],
    );
  }

}

class ProfileIconWidget extends StatelessWidget
{
  final String title;
  final IconData iconURI;
  final Color iconColor;
  ProfileIconWidget({required this.title,required this.iconURI,required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          children: [

            Icon(iconURI,color: iconColor,size: 30),
            SizedBox(width: 10,),

            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),



          ],
        ),
        SizedBox(height: 7),

        Divider(
          color: Colors.white,
          thickness: 0.5,
        )



      ],
    );
  }

}
