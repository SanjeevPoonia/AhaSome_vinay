

import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.train,
      ),
      title: const Text('Page 2'),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

}