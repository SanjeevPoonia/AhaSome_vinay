
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';
import '../utils/strings.dart';

class ReportSuccess extends StatelessWidget
{
  final String reportType;
  ReportSuccess(this.reportType);
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
            SizedBox(height: 20),


            Center(child: Image.asset('assets/check.png',width: 100,height: 100),),


            SizedBox(height: 20),

            Center(
              child: Text(
                'Thanks for reporting '+reportType,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w500,
                    color: Colors.black),
              ),
            ),


            SizedBox(height: 10),

            Padding(padding: EdgeInsets.symmetric(horizontal: 15),

              child: Text(
                'You\'ll get a notification once we review your report.Thanks for helping us keep AHA a safe and supportive application which is only here to spread happinness.',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w500,
                    color: Colors.grey),
                textAlign: TextAlign.center,
              ),


            ),

            SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                      height: 47,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.themeColor,
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Close',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w600,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
            )












          ],
        ),
      )),
    );
  }

}