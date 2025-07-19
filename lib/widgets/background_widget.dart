
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return  Container(

      width: MediaQuery.of(context).size
          .width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              fit: BoxFit.fill,
              image:AssetImage(
                  'assets/background.png'
              )
          )
      ),
    );
  }

}

