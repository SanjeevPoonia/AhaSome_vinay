import 'package:aha_project_files/models/app_modal.dart';
import 'package:aha_project_files/network/bloc/friends_bloc.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/utils/utils.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:readmore/readmore.dart';
import '../widgets/app_bar_widget.dart';
class ShoutOuts extends StatefulWidget
{
  @override
  ShoutState createState()=>ShoutState();
}
class ShoutState extends State<ShoutOuts>
{
  List<dynamic> postList = [];
  final friendsBloc=Modular.get<FriendsCubit>();
  @override
  Widget build(BuildContext context) {
   return Container(
     color: AppTheme.navigationRed,
     child: SafeArea(child:  Scaffold(
       backgroundColor: Colors.white,
       body: BlocBuilder(
         bloc: friendsBloc,
         builder: (context,state)
         {
           return Stack(
             children: [
               BackgroundWidget(),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   AppBarNew(
                     onTap: () {
                       Navigator.pop(context);
                     },
                     iconButton: PopupMenuButton<String>(
                       icon: const Icon(Icons.more_vert_outlined,
                           color: Colors.white),
                       onSelected: handleClick,
                       itemBuilder: (BuildContext context) {
                         return {'Logout'}.map((String choice) {
                           return PopupMenuItem<String>(
                             value: choice,
                             child: Text(choice),
                           );
                         }).toList();
                       },
                     ),
                     showBackIc: true,
                   ),
                   const SizedBox(height: 15),
                   const Padding(
                     padding: EdgeInsets.only(left: 15),
                     child: Text(
                       'Past Shout Out',
                       style: TextStyle(
                           color: Color(0xFfDD2E44),
                           fontWeight: FontWeight.w600,
                           fontSize: 15),
                     ),
                   ),
                   const SizedBox(height: 10),



                   Expanded(child:
                   friendsBloc.state.isLoading?
                   Loader():
                       friendsBloc.state.shoutList.length==0?

                           const Center(
                             child: Text('No Shout outs'),
                           )

                       :

                   ListView.builder(
                       itemCount: friendsBloc.state.shoutList.length,
                       itemBuilder: (BuildContext context,int pos)
                       {
                         return  Column(
                           children: [
                             Card(
                               elevation:4,
                               shadowColor: AppTheme.gradient2,
                               margin: const EdgeInsets.symmetric(horizontal: 15),
                               shape: RoundedRectangleBorder(
                                   borderRadius:
                                   BorderRadius
                                       .circular(
                                       10)),
                               child: Container(
                                   padding: const EdgeInsets.all(10),
                                   width: double.infinity,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [

                                       ReadMoreText(
                                         friendsBloc.state.shoutList[pos].promise!,
                                         trimLines: 2,
                                         style: TextStyle(
                                             color: AppTheme.gradient1,
                                             fontSize: 15,
                                             fontWeight:
                                             FontWeight
                                                 .w500),
                                         colorClickableText: Colors.blue,
                                         trimMode: TrimMode.Line,
                                         trimCollapsedText: 'Show more',
                                         trimExpandedText: 'Show less',
                                         moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),
                                       ),


                                       /*Text(
                                         friendsBloc.state.shoutList[pos].promise!,
                                         style: const TextStyle(
                                             color: AppTheme.gradient1,
                                             fontSize: 15,
                                             fontWeight:
                                             FontWeight
                                                 .w500),
                                       ),*/
                                       const SizedBox(height: 5),
                                       Text(
                                         _parseServerDate(friendsBloc.state.shoutList[pos].created_at!),
                                         style: const TextStyle(
                                             color: AppTheme.gradient4,
                                             fontSize: 15,
                                             fontWeight:
                                             FontWeight
                                                 .w500),
                                       ),




                                     ],
                                   )
                               ),
                             ),

                             const SizedBox(height: 12),
                           ],
                         );
                       }


                   ))






                 ],
               ),
             ],
           );
         }

         ,
       )

     )),
   );
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }
  String _parseServerDate(String date) {
    var dateTime22 = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date, true);
    var dateLocal = dateTime22.toLocal();
    String timeStamp = timeago.format(dateLocal).toString();
    return timeStamp;
  }

  @override
  void initState() {
    super.initState();
    var requestModel={
      'auth_key':AppModel.authKey
    };

    friendsBloc.fetchAllShouts(context, requestModel);
  }


}
