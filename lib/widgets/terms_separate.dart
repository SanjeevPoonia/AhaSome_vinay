

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../network/api_dialog.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/image_assets.dart';

class TermsScreen extends StatefulWidget
{
  FormData formData;
  TermsScreen(this.formData);
  TermsState createState()=>TermsState();
}

class TermsState extends State<TermsScreen>
{
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  final authBloc = Modular.get<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child:Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/slider_1.jpg'),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.35), BlendMode.multiply),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 65),
                      Image.asset(ImageAssets.logoWithText,
                          width: 240, height: 190),
                      const SizedBox(height: 15),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Terms & conditions',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(

                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Checkbox(
                                            value: check1,
                                            onChanged: (newValue) =>
                                                setState(() => check1 = newValue!),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'I understand this app is not to sell any product or services',
                                            style:
                                            TextStyle(fontSize: 14, color: Colors.brown),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Checkbox(
                                            value: check2,
                                            onChanged: (newValue) =>
                                                setState(() => check2 = newValue!),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'I will use appropriate language and respect other members',
                                            style:
                                            TextStyle(fontSize: 14, color: Colors.brown),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Checkbox(
                                            value: check3,
                                            onChanged: (newValue) =>
                                                setState(() => check3 = newValue!),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'I commit to spread Happiness only',
                                            style:
                                            TextStyle(fontSize: 14, color: Colors.brown),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),








                                  ],
                                )
                              ),

                              Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 6),
                                height: 48,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            AppTheme.themeColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                side: BorderSide(
                                                    color:
                                                    AppTheme.themeColor)))),
                                    onPressed: () {

                                      if (check1 == false || check2 == false || check3 == false)
                                        {
                                          // do nothing
                                        }
                                      else
                                        {
                                          _callSignUpAPI();

                                        }




                                    },
                                    child: const Text("Lets get ready to AHA",
                                        style: TextStyle(fontSize: 14))),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ],
              ),
            ),
          ))),
    );
  }


  _callSignUpAPI() async {
    FormData data=widget.formData;
     APIDialog.showAlertDialog(context, 'Creating user...');
    authBloc.addNewUser(context, data);
  }
}