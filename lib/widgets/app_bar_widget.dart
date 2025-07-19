import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/chat_listing_screen.dart';
import 'package:aha_project_files/view/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../models/app_modal.dart';
import '../network/bloc/dashboard_bloc.dart';
import '../utils/image_assets.dart';

class GradientAppBar extends StatelessWidget {
  final Widget iconButton;
  bool showBackIc;
  Function onTap;



  GradientAppBar(
      {Key? key,
      required this.iconButton,
      required this.showBackIc,
      required this.onTap,



      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppTheme.gradient2,
            AppTheme.gradient1,
            AppTheme.gradient3,
            AppTheme.gradient4,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, 0, 0.47, 1],
        ),
      ),
      child: Row(
        children: [
          showBackIc
              ? Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: IconButton(
                      onPressed: () {
                        onTap();
                      },
                      icon: const Icon(Icons.keyboard_backspace_outlined,
                          color: Colors.white)),
                )
              : Container(),

          showBackIc ? const SizedBox(width: 10) : const SizedBox(width: 55),

          Container(
            width: 60,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageAssets.logoWithText),
                    fit: BoxFit.fill)),
          ),
          const Spacer(),

          iconButton,
          //  Icon(Icons.more_vert_outlined,color: Colors.white),
        ],
      ),
    );
  }
}

class AppBarNew extends StatelessWidget {
  final Widget iconButton;
  bool showBackIc;
  Function onTap;

  AppBarNew(
      {Key? key,
      required this.iconButton,
      required this.showBackIc,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppTheme.gradient2,
            AppTheme.gradient1,
            AppTheme.gradient3,
            AppTheme.gradient4,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, 0, 0.47, 1],
        ),
      ),
      child: Row(
        children: [
          showBackIc
              ? Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: IconButton(
                      onPressed: () {
                        onTap();
                      },
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white)),
                )
              : Container(),
          const SizedBox(width: 10),
          Container(
            width: 60,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageAssets.logoWithText),
                    fit: BoxFit.fill)),
          ),
          const Spacer(),
          iconButton,
          const SizedBox(width: 5)
        ],
      ),
    );
  }
}



class TermsAppBar extends StatelessWidget {
  bool showBackIc;
  Function onTap;

  TermsAppBar(
      {Key? key,
        required this.showBackIc,
        required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 2),
      decoration: const BoxDecoration(
        /*borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),*/
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppTheme.gradient2,
            AppTheme.gradient1,
            AppTheme.gradient3,
            AppTheme.gradient4,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, 0, 0.47, 1],
        ),
      ),
      child: Row(
        children: [
          showBackIc
              ? Padding(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: IconButton(
                onPressed: () {
                  onTap();
                },
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white)),
          )
              : Container(),
          const SizedBox(width: 10),
          Container(
            width: 60,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageAssets.logoWithText),
                    fit: BoxFit.fill)),
          ),

          const SizedBox(width: 5)
        ],
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  final dashboardBloc = Modular.get<DashboardCubit>();
  final Widget iconButton;
  bool showBackIc;
  Function onTap;
  Function onNotificationTap;
  Function onChatTap;
  HomeAppBar(
      {Key? key,
      required this.iconButton,
      required this.showBackIc,
      required this.onTap,
        required this.onNotificationTap,
        required this.onChatTap
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 20.0,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppTheme.gradient2,
            AppTheme.gradient1,
            AppTheme.gradient3,
            AppTheme.gradient4,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0, 0, 0.47, 1],
        ),
      ),
      child: Row(
        children: [
          showBackIc
              ? Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: IconButton(
                      onPressed: () {
                        onTap();
                      },
                      icon: const Icon(Icons.keyboard_backspace_outlined,
                          color: Colors.white)),
                )
              : Container(),

          showBackIc ? const SizedBox(width: 40) : const SizedBox(width: 55),

          Container(
            width: 60,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageAssets.logoWithText),
                    fit: BoxFit.fill)),
          ),
          const Spacer(),


         InkWell(
             onTap: (){
               onChatTap();
             },

             child: Image.asset('assets/chat_icc.png',color: Colors.white,width: 30,height: 35)),
          SizedBox(width: 10),

          InkWell(
              onTap: () {
                onNotificationTap();
                // dashboardBloc.fetchHomeCounts(context, formData);



               /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()));*/
              },
              child:Container(
                width: 35,
                height: 30,
                child: Stack(
                  children:  [

                    const Icon(Icons.notifications, color: Colors.white),
                    dashboardBloc.state.notCount==null || dashboardBloc.state.notCount!<=0?Container():
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        transform: Matrix4.translationValues(
                            0.0, -2.0, 0.0),
                        width:
                        25,
                        height:
                        17,
                        decoration:
                         BoxDecoration(color: AppTheme.navigationRed,
                         borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white,width: 1)

                        ),
                        child:
                        Center(
                          child:
                          dashboardBloc.state.notCount!>9?
                          const Text(
                          '9+'
                            ,
                            style: TextStyle(color: Colors.white,fontSize: 10),
                          ): Text(
                            dashboardBloc.state.notCount!.toString(),
                            style: const TextStyle(color: Colors.white,fontSize: 10),
                          )
                        ),
                      ),
                    )




                  ],
                ),
              )),

          SizedBox(width: 15)



          //iconButton,
          //  Icon(Icons.more_vert_outlined,color: Colors.white),
        ],
      ),
    );
  }
}
