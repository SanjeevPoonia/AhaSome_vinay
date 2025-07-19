import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen(this.url);
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewScreen> {
  bool isLoading=true;
  final _key = UniqueKey();
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(
        backgroundColor: Colors.white,
          body:Column(
            children: [
              GradientAppBar(
                onTap: () {
                  Navigator.pop(context,'restart timer');
                },
                iconButton: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_outlined,
                      color: Colors.white),
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {
                      'Logout',
                    }.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
                showBackIc: true,
              ),
              Expanded(child:  Stack(
                children: <Widget>[
                  WebView(
                    key: _key,
                    initialUrl: 'https://docs.google.com/viewer?url='+widget.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading ? Center( child: CircularProgressIndicator(),)
                      : Stack(),
                ],
              ))

            ],
          )
      )),
    ), onWillPop: (){
      Navigator.pop(context,'restart timer');
      return Future.value(false);
    });


    /*WebView(
      initialUrl: 'https://docs.google.com/viewer?url='+widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );*/
  }
  void handleClick(String value) {
    switch (value) {
    //Deactivate account
      case 'Logout':
        Utils.logoutUser(context);
        break;

    }
  }
}