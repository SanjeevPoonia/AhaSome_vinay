import 'dart:convert';

import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/view/gratitude_success_screen.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/utils/image_assets.dart';
import 'package:aha_project_files/utils/strings.dart';
import 'package:aha_project_files/view/report_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:toast/toast.dart';

import '../network/api_helper.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/background_widget.dart';

class AddReport extends StatefulWidget {
  final String reportType;
  final String reportName;
  final bool reportPost;
  AddReport(this.reportType,this.reportName,this.reportPost);
  @override
  AddReportState createState() => AddReportState();
}

class AddReportState extends State<AddReport> {
  var postController = TextEditingController();
  final authBloc = Modular.get<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body:   Column(
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [



                        Text('Submit Report',style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),),


                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close)),







                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            widget.reportType,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(

                              top: 20,
                              bottom: 15),
                          child: TextField(
                            maxLines: 6,
                            controller: postController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(
                                    color:
                                    Colors.grey,
                                    fontSize: 14,
                                    fontFamily: 'Baumans'),
                                hintText:
                                'Add Details',
                                fillColor: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: (){
                           sendReport();
                          },
                          child: Card(

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                                height: 47,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.themeColor,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    AppStrings.submit,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ))),
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

  sendReport() async {
    int status=1;
    if(widget.reportPost)
      {
        status=2;
      }
    APIDialog.showAlertDialog(context, 'Submitting Report...');
    var formData = {'auth_key': AppModel.authKey,'description':widget.reportType,'status':status,'reported_id':AppModel.reportedID};
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('userReport', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    if(responseJson['status']==1)
      {
        if(widget.reportPost)
          {
            Toast.show('Post Reported successfully !',
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.blue);
          }
        else
          {
            Toast.show('User Reported successfully !',
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.blue);
          }

        int count=0;
        Navigator.of(context).popUntil((_) => count++ >= 2);

      }

  //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportSuccess(widget.reportName)));
  }
}
