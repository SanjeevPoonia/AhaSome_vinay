import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor



  MyMarker(this.globalKeyMyWidget,this.count);
  final GlobalKey globalKeyMyWidget;
  final int count;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width:85,
            height:85,
            decoration:
            const BoxDecoration(shape: BoxShape.circle),
          ),
          Container(
            width:55,
            height:55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.gradient4,
              border: Border.all(
                  color: AppTheme.gradient1,
                  width: 4
              ),
            ),

            child:  Center(
              child:  Text(
                count.toString(),
                style: TextStyle(
                    color: Colors
                        .white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Allerta',
                    fontSize:
                    17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
