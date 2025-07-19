part of 'package:aha_project_files/network/bloc/dashboard_bloc.dart';
@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(false) bool isLoading,
    @Default(10) int status,
    @Default('') String message,
    @Default([]) List<ShowPost> homePost,
    @Default([]) List<String> promisesList,
    @Default([]) List<UserProfile> aboutUser,
    @Default(null)  int? ahaByMe,
    @Default(null)  int? groupCount,
    @Default(null)  int? friendsCount,
    @Default(null)  int? gratitudeCount,
    @Default(null)  int? notCount,
  }) = _DashboardState;

}
