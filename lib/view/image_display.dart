
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/app_theme.dart';
import '../widgets/app_bar_widget.dart';

class ImageDisplay extends StatelessWidget {
  final String image;

  const ImageDisplay({Key? key, required this.image})
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
                  child:
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: image,
                    placeholder: (context, url) => Icon(Icons.photo_rounded,size: 30),
                    errorWidget: (context, url, error) => Container(),
                  ),





                 /* Image.network(image,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },

                  )*/



                  /*PhotoView(
                    imageProvider: CachedNetworkImageProvider(image),
                  ),*/
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
