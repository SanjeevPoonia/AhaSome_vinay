

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedImageWidget extends StatelessWidget
{
  final String url;
  RoundedImageWidget(this.url);
  @override
  Widget build(BuildContext context) {
    return  CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/circle_thumb.jpeg'),radius:24 ),
    );
  }

}


class RoundedImage extends StatelessWidget
{
  final String url;
  final double size;
  RoundedImage(this.url,this.size);
  @override
  Widget build(BuildContext context) {
    return  CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width:size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/circle_thumb.jpeg'),radius:24),
    );
  }

}