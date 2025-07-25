
import 'package:aha_project_files/widgets/custom_drawer/constants.dart';
import 'package:aha_project_files/widgets/custom_drawer/runtime_variables.dart';
import 'package:flutter/material.dart';

import 'bloc/generic_bloc.dart';
import 'bloc/shadow_bloc.dart';

ShadowState? shadowState;

class Shadow extends StatefulWidget {
  final Color? bgColor;

  Shadow({required this.bgColor});

  @override
  ShadowState createState() => ShadowState();
}

class ShadowState extends State<Shadow> {
  @override
  Widget build(BuildContext context) {
    shadowState = this;
    return AnimatedContainer(
        transform: GenericBLOC.changeValues(
            ShadowBLOC.xOffSet, ShadowBLOC.yOffSet, ShadowBLOC.angle),
        duration: GenericBLOC.setDuration(
            RuntimeVariables.shadowSpeedUserInput ?? Constants.SHADOW_DURATION),
        decoration:
            GenericBLOC.getDecoration(widget.bgColor ?? Constants.SHADOW_COLOR),
        child: SafeArea(
            child:
                Container(width: Constants.width, height: Constants.height)));
  }
}
