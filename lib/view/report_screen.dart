

import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/add_report.dart';
import 'package:aha_project_files/view/report_success.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget
{
  final String reportType;
  final bool reportPost;
  ReportScreen(this.reportType,this.reportPost);
  ReportState createState()=>ReportState();
}

class ReportState extends State<ReportScreen>
{
  List<String> reportItem=[
    'Nudity',
    'Violence',
    'Harassment',
    'Self-injury',
    'False information',
    'Spam',
    'Unauthorized sales',
    'Hate speech',
    'Something else',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [



                  Text('Report',style: const TextStyle(
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
            SizedBox(height: 10),
            Padding(
              padding:  EdgeInsets.only(left: 15),
              child: Text('Please select a problem',style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              ),),
            ),


            SizedBox(height: 20),

            Expanded(child: ListView.builder(
                itemCount: reportItem.length,
                itemBuilder: (BuildContext context,int pos)
            {
              return Column(
                children: [
                  InkWell(
                    onTap:(){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddReport(reportItem[pos],widget.reportType,widget.reportPost)));
              },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(reportItem[pos],style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          )),


                          Icon(Icons.arrow_forward_ios_rounded)







                        ],
                      ),
                    ),
                  ),
                  Divider(),



                ],
              );
            }



            ))










          ],
        ),
      )),
    );
  }

}