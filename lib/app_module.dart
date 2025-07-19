

import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
import 'package:aha_project_files/network/bloc/profile_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'network/bloc/friends_bloc.dart';


class AppModule extends Module
{
  @override
  List<Bind<Object>> get binds => [
    Bind.singleton<AuthCubit>((i) => AuthCubit()),
    Bind.singleton<DashboardCubit>((i) => DashboardCubit()),
    Bind.singleton<FriendsCubit>((i) => FriendsCubit()),
    Bind.singleton<ProfileCubit>((i) => ProfileCubit())
  ];
}