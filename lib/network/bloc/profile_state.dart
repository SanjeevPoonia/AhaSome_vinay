part of 'package:aha_project_files/network/bloc/profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default(false) bool isDialogLoading,
    @Default('') String message,
    @Default([]) List<AllGroup> myGroupList,
    @Default([]) List<GroupPost> groupPosts,
    @Default([]) List<GroupInfo>? groupInfo,
    @Default(0)  int isGroupMember,
  }) = _ProfileState;

}
