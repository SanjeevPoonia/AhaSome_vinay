
import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/image_assets.dart';
class UpdateAppScreen extends StatefulWidget
{
  UpdateAppState createState()=>UpdateAppState();
}
class UpdateAppState extends State<UpdateAppScreen>
{
  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
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
                    const SizedBox(height: 75),
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
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16,color: AppTheme.gradient1),
                            ),
                            const SizedBox(height: 15),

                            const Text(
                              'A new version of AHAsome is available on store,please update your app ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),

                            const SizedBox(height: 15),

                            Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 6),
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppTheme.themeColor),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              side: BorderSide(
                                                  color: AppTheme.themeColor)))),
                                  onPressed: () {
                                    if(Platform.isAndroid)
                                      {
                                        launchUrl(
                                          Uri.parse('https://play.google.com/store/apps/details?id=com.happy.aha'),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    else
                                      {
                                        launchUrl(
                                          Uri.parse('https://apps.apple.com/in/app/ahasome/id1637076364'),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                  },
                                  child: const Text("UPDATE", style: TextStyle(fontSize: 14))),
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
        ));
  }

}