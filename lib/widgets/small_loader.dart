
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallLoader extends StatelessWidget
{
  final Color loaderColor;
  SmallLoader(this.loaderColor);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.all(5),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor : AlwaysStoppedAnimation(loaderColor),
      ),
    );
  }

}