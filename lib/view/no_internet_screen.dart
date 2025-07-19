

import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       width: MediaQuery.of(context).size.width,
       height: MediaQuery.of(context).size.height,
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [

           SizedBox(height: 35),
           Center(
             child: Image.asset('assets/network.png',width:100,height:100),
           ),
           const SizedBox(height: 20),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15),
             child: Text(
               'No internet connection',
               style: TextStyle(
                   color:Colors.brown,
                   height: 2,
                   fontSize: 16),
             ),
           ),


         ],
       ),
     )

    );
  }

}