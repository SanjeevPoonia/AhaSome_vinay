
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 63,
            padding: EdgeInsets.symmetric(horizontal: 12),
            color: Color(0xFFFDD217),
            child: Row(
              children: [

                
                Image.asset('assets/back_ic.png',width: 25,height: 25),

                SizedBox(width: 20),


                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey,
                          spreadRadius: 3)
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundImage:
                    AssetImage('assets/profile_dummy.jpg'),
                  ),
                ),
                SizedBox(width: 25),

                Text(
                  'Odeusz Piotrowski',
                  style:
                  TextStyle(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w600


                  ),
                ),

                Spacer(),

                Icon(Icons.more_vert_outlined, color: Colors.white),


              ],
            ),
          ),

          SizedBox(height: 20),



          Center(
            child: Text(
              '3 MAR 13:34',
              style:
              TextStyle(color: Color(0xFFDD2E44), fontSize: 16,



              ),
            ),
          ),

          SizedBox(height: 10),


         Stack(
           children: [

             Container(
               padding: EdgeInsets.only(left: 40,top: 10,bottom: 10,right: 10),
               margin: EdgeInsets.symmetric(horizontal: 10),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Color(0xFFDBF4B4)
               ),
               child:  Expanded(
                 child:    Text(
                   'Anybody affected by coronavirus?',
                   style:
                   TextStyle(color: Colors.black, fontSize: 16,
                       fontWeight: FontWeight.w300



                   ),
                 ),
               ),
             ),
             Container(
               margin: EdgeInsets.only(left: 12,top: 22),
               child: CircleAvatar(
                 radius: 20.0,
                 backgroundImage:
                 AssetImage('assets/profile_dummy.jpg'),
               ),
             ),
           ],
         ),


          SizedBox(height: 10),

          Row(
            children: [

              SizedBox(width: 100,),

              Container(
                width: 50,
                padding: EdgeInsets.all(15),
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC42562)
                ),
                child: Image.asset('assets/cross_ic.png',width: 25,height: 25),
              ),


              SizedBox(width: 15),

              Container(
                width: 50,
                padding: EdgeInsets.all(15),
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF42BFB7)
                ),
                child: Image.asset('assets/arrow_down.png',width: 25,height: 25),
              ),

              SizedBox(width: 15),
              
              Container(
                  width: 120,height: 150,

                  child: Image.asset('assets/chat_dummy.png',))
              



            ],
          ),

          SizedBox(height: 10),


          Container(
            padding: EdgeInsets.only(left: 40,top: 10,bottom: 10,right: 10),
            margin: EdgeInsets.only(left: 60,right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFE7F4FA)
            ),
            child:  Expanded(
              child:    Text(
                'At out office 3 ppl are infected. We work from home.',
                style:
                TextStyle(color: Colors.black, fontSize: 16,
                    fontWeight: FontWeight.w300



                ),
              ),
            ),
          ),


          SizedBox(height: 20),


         Padding(
           padding: const EdgeInsets.only(left: 15),
           child: Row(
             children: [
               Expanded(
                 child: Container(
                   height: 50,
                   child: TextFormField(
                       style: TextStyle(
                         fontSize: 15.0,
                         color: Colors.black,
                       ),
                       decoration: InputDecoration(
                         suffixIcon: Container(
                           padding: EdgeInsets.all(12),
                           decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: Color(0xffC4C4C4)
                           ),
                           child: Image.asset('assets/send_ic.png'),
                         ),
                         border: OutlineInputBorder(
                           borderSide: BorderSide(
                             width: 0,
                             style: BorderStyle.none,
                           ),
                           borderRadius:
                           BorderRadius.circular(25.0),
                         ),
                         fillColor: Color(0xffEEEEEE),
                         filled: true,
                         contentPadding: EdgeInsets.fromLTRB(
                             20.0, 12.0, 0.0, 12.0),
                         hintText: 'Reply',
                         labelStyle: TextStyle(
                           fontSize: 15.0,
                           color: Color(0XFFA6A6A6),
                         ),
                       )),
                 ),
               ),
               SizedBox(width: 15),


               Container(
                 padding: EdgeInsets.all(12),
                 width: 50,
                 height: 50,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Color(0xFFDD3648)
                 ),
                 
                 child: Image.asset('assets/camera_ic.png'),
               ),

               SizedBox(width: 15),




             ],

           ),
         ),

          SizedBox(height: 20),
















        ],
      ),




    ));
  }

}
