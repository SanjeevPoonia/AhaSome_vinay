
import 'package:aha_project_files/widgets/custom_drawer/bloc/generic_bloc.dart';
import 'package:aha_project_files/widgets/custom_drawer/bloc/home_page_bloc.dart';
import 'package:aha_project_files/widgets/custom_drawer/constants.dart';
import 'package:aha_project_files/widgets/custom_drawer/runtime_variables.dart';
import 'package:aha_project_files/widgets/custom_drawer/shadow.dart';
import 'package:flutter/material.dart';

import 'bloc/shadow_bloc.dart';

class HomePage extends StatefulWidget {
  final Widget body;

  HomePage({required this.body});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        transform: GenericBLOC.changeValues(
            HomePageBloc.xOffSet, HomePageBloc.yOffSet, HomePageBloc.angle),
        duration: GenericBLOC.setDuration(
            RuntimeVariables.homePageSpeedUserInput?? Constants.HOME_SCREEN_DURATION
        ),
        child: ClipRRect(
          borderRadius: GenericBLOC.getBorderRadius(),
          child: Stack(
            children: [
              widget.body,
              SafeArea(
                child: HomePageBloc.isOpen ? _closeButton() : _openButton(),
              )
            ],
          ),
        ));
  }

  _openButton() {
    return IconButton(
        icon: RuntimeVariables.openIconUserInput ?? Constants.DRAWER_OPEN_ICON,
        onPressed: () {
          HomePageBloc().openDrawer();
          ShadowBLOC().openDrawer();

          setState(() {});
          shadowState!.setState(() {});
        });
  }

  _closeButton() {
    return IconButton(
        icon:
        RuntimeVariables.closeIconUserInput ?? Constants.DRAWER_CLOSE_ICON,
        onPressed: () {
          HomePageBloc().closeDrawer();
          ShadowBLOC().closeDrawer();
          setState(() {});
          shadowState!.setState(() {});
        });
  }
}
