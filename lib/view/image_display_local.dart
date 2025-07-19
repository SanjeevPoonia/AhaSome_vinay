
import 'dart:io';

import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';

class ImageDisplayLocal extends StatelessWidget {
  final String image;

  const ImageDisplayLocal({Key? key, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(child: Scaffold(
        body:Stack(
          children: [

            //BackgroundWidget(),
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


                Expanded(child: Center(
                  child: PhotoView(
                    imageProvider: FileImage(File(image)),
                  ),
                ))

              ],
            )
          ],
        )



      )),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
    }
  }
}
