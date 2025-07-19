

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverImageWidget extends StatelessWidget
{
  final String url;
  CoverImageWidget(this.url);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 165,
      margin: const EdgeInsets.only(top: 45),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) =>Center(child: Image.asset('assets/thumb2.jpeg')),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

}

class GroupCoverWidget extends StatelessWidget
{
  final String url;
  GroupCoverWidget(this.url);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,

      margin: const EdgeInsets.only(top: 45),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          width: MediaQuery.of(context).size.width,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) =>Center(child: Image.asset('assets/thumb2.jpeg')),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

}