
import 'package:aha_project_files/widgets/custom_drawer/constants.dart';
import 'package:flutter/material.dart';

class ThirdLayer extends StatelessWidget {
  final Widget menu;

  ThirdLayer({required this.menu});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Constants.height,
        width: Constants.height,
        color: Colors.transparent,
        child: menu /*?? Container()*/);
  }
}
