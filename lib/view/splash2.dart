

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';
import '../network/bloc/auth_bloc.dart';
import 'home_screen.dart';

class SplashScreen2 extends StatefulWidget
{
  final String token;
  SplashScreen2(this.token);
  SplashState createState()=>SplashState();
}
class SplashState extends State<SplashScreen2>
{
  final authBloc = Modular.get<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
    /*  body: Center(
        child: Padding(
          padding: EdgeInsets.all(80),
          child: Image.asset('assets/logo_with_text.png'),
        )
      ),*/
    ));
  }
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 /*   var userPref = prefs.getString('userdata');
    LoginModel userData = LoginModel.fromJson(json.decode(userPref.toString()));
    authBloc.fetchCheckInDetails(userData);*/
 /*   Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
            (context) =>
        const HomeScreen()
        )
    );*/
   /* Timer(const Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            const HomeScreen()
            )
        )
    );*/
  }
}