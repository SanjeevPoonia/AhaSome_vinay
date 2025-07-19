

import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget
{
  final String menuText;
  final Function onTap;
  NavigationWidget({required this.menuText,required this.onTap});
  @override
  Widget build(BuildContext context) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      InkWell(
        onTap: (){
          onTap();
        },
        child:  Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 9,left: 10),
          height: 35,
          child:  Text(
            menuText,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.white),
          ),
        ),
      ),


       Divider(
         color: Colors.white,
         thickness: 0.2,
       ),



     ],
   );
  }

}