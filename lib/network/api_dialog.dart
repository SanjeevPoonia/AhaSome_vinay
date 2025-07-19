
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:flutter/material.dart';

class APIDialog
{
  static Future<void> showAlertDialog(BuildContext context,String dialogText) async {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.navigationRed),
          ),
          Container(margin: EdgeInsets.only(left: 9), child: Text(dialogText,maxLines:2,style: TextStyle(color:Colors.blueGrey,fontFamily: 'OpenSans'),)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}






