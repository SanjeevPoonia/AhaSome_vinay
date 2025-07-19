import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/app_bar_widget.dart';



class TermsScreen2 extends StatefulWidget
{
  PrivacyPolicyState createState()=>PrivacyPolicyState();
}
class PrivacyPolicyState extends State<TermsScreen2> {
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
        Stack(
          children: <Widget>[

            WebView(
                initialUrl: 'https://aha-me.com/aha/terms_and_conditions',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                }
            ),
            isLoading ? Center( child: CircularProgressIndicator())
                : Stack(),
            TermsAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              showBackIc: true,
            ),

          ],
        ),

      ),
    );
  }
// /initialUrl: 'https://aha-me.com/aha/terms_and_conditions',

  /*JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }*/
}
